create function test1(params_ form_join_conditions[]) returns text
	language plpgsql
as $$
DECLARE
  xx int;
BEGIN
  PERFORM create_temp_indicators();
  RETURN 'TRUE';
END;
$$
;

create function test1(p_form_id integer, p_params text) returns text
	language plpgsql
as $$
DECLARE
  c_params RECORD;
BEGIN
  PERFORM create_temp_indicators();
  FOR c_params IN
    WITH
    fm AS (SELECT unnest(join_conditions) as f from forms where id = p_form_id),
    pm AS (SELECT json_populate_recordset(null::form_join_conditions, p_params::json) as p )

      SELECT field_(f) AS field_f, expr_(f) AS expr_f , oper_(f) AS oper_f, exprval_(f) AS exprval_f,
             field_(p) AS field_p, expr_(p) AS expr_p , oper_(p) AS oper_p, exprval_(p) AS exprval_p
      FROM fm FULL OUTER JOIN pm ON ((fm.f).field_ = (pm.p).field_)
      LOOP

    -- Здесь "mviews" содержит одну запись из cs_materialized_views

    RAISE NOTICE 'Refreshing materialized view %s ...', quote_ident(c_params.field_f)|| quote_ident(c_params.field_p) ;

  END LOOP;
  RETURN 'TRUE';
END;
$$
;

create function sql_indicators_gen(p_form_id integer, p_params text) returns text
	language plpgsql
as $$
DECLARE
  m_SQL text = 'INSERT INTO temp_indicators (' || chr(13) ||
                     'form_item_id, id, state,' || chr(13) ||
                     'technology_type, service_type, abonent_type,' || chr(13) ||
                     'division_id, region_id, tariff_id, period_type, period,' || chr(13) ||
                     'valbeg, sumbeg, valdb, sumdb, valcr, sumcr, valend, sumend)' || chr(13) ||
               ' SELECT f.id, i.id, i.state,' || chr(13) ||
                      'i.technology_type, i.service_type, i.abonent_type,' || chr(13) ||
                      'i.division_id, i.region_id, i.tariff_id, i.period_type, i.period,' || chr(13) ||
                      'i.valbeg, i.sumbeg, i.valdb, i.sumdb, i.valcr, i.sumcr, i.valend, i.sumend' || chr(13) ||
               ' FROM indicators i, form_items f';

  m_Condition  text = '';
BEGIN
  WITH
      fm AS (SELECT unnest(join_conditions) as f from forms where id = p_form_id),
      pm AS (SELECT json_populate_recordset(null::form_join_conditions, p_params::json) as p ),
      jn AS (SELECT field_(f) AS field_f, expr_(f) AS expr_f , oper_(f) AS oper_f, exprval_(f) AS exprval_f,
             field_(p) AS field_p, expr_(p) AS expr_p , oper_(p) AS oper_p, exprval_(p) AS exprval_p
              FROM fm FULL OUTER JOIN pm ON ((fm.f).field_ = (pm.p).field_)
            )
      SELECT
          string_agg( CASE WHEN field_p IS NULL
                         THEN coalesce(expr_f, 'i.' || field_f) || ' ' || oper_f || ' ' || coalesce(exprval_f, 'f.' || field_f)
                         ELSE coalesce(expr_p, 'i.' || field_p) || ' ' || oper_p || ' ' || coalesce(exprval_p, 'f.' || field_p)
                         END, ' AND ' || chr(13))
      INTO m_Condition
      FROM jn;

   RETURN m_SQL  || chr(13) || ' WHERE f.form_id = ' || p_form_id || ' AND '  || chr(13) || m_Condition;
END;
$$
;

create function form_make_definition(p_form_id integer, OUT o_sql_get_data text, OUT o_def_columns text, OUT o_def_rows text) returns record
	language plpgsql
as $$
DECLARE
  m_attr_cols form_attr[];
  m_attr_rows form_attr[];

  m_attr_col_keys form_attr_keys[];
  m_attr_row_keys form_attr_keys[];

  m_columns form_attributes[];
  m_rows form_attributes[];
  m_values form_attributes[];

  m_SQL text;
  m_XX text;
  m_s text;

BEGIN
  SELECT columns, rows, values INTO m_columns , m_rows, m_values FROM forms WHERE id = p_form_id;

  m_attr_cols = form_make_attrs(m_columns);
  m_attr_rows = form_make_attrs(m_rows);

  m_attr_col_keys = form_make_keys(m_attr_cols);
  m_attr_row_keys = form_make_keys(m_attr_rows);

  SELECT to_json(m_attr_rows), to_json(m_attr_row_keys),to_json(m_attr_col_keys) INTO o_sql_get_data, o_def_rows, o_def_columns ;

  RETURN;
END;
$$
;

create function import_from_foreign_db(p_max_records integer DEFAULT 9) returns SETOF ft_log_loads
	language plpgsql
as $$
DECLARE
  r_log ft_log_loads%rowtype;
  m_log_id INTEGER;
  c_log refcursor;
  m_cnt integer;
  m_RC  TEXT;
  m_MSG TEXT;

BEGIN
 -- PERFORM create_temp_indicators();
  OPEN c_log NO SCROLL FOR
    SELECT * FROM ft_log_loads
    WHERE state IN ('нормализована') -- AND object_ =  'divisions' -- Фильтр отладки
    ORDER BY object_, id
    LIMIT p_max_records;
  LOOP
    FETCH c_log INTO r_log;
    EXIT WHEN NOT FOUND;

   BEGIN
      WITH
        i  AS ( INSERT INTO log_loads (source_id, state, operation_, object_, author_, time_, comment_)
                SELECT r_log.id, r_log.state::log_record_states, r_log.operation_, r_log.object_,
                       r_log.author_, r_log.time_, r_log.comment_
                WHERE NOT EXISTS (SELECT 1 FROM log_loads WHERE source_id = r_log.id)
                RETURNING id
              )
      SELECT COALESCE((SELECT id FROM i), (SELECT id FROM log_loads WHERE source_id = r_log.id)) INTO m_log_id;

      IF r_log.object_ = 'indicators' THEN
          SELECT import_fdb_indicators(r_log.id::INTEGER, m_log_id) INTO m_RC;
      ELSEIF r_log.object_ = 'divisions' THEN
          SELECT import_fdb_divisions(r_log.id::INTEGER, m_log_id) INTO m_RC;
      ELSEIF r_log.object_ = '???types???' THEN

        NULL;
      END IF;

      UPDATE log_loads SET state = 'принята', time_ = now() WHERE id = m_log_id;
/**/
      UPDATE ft_log_loads SET state = 'передана' WHERE id = r_log.id;    
    EXCEPTION WHEN others THEN
          GET STACKED DIAGNOSTICS /*text_var1 = MESSAGE_TEXT,*/ m_MSG = PG_EXCEPTION_DETAIL;
          UPDATE ft_log_loads SET state = 'ошибка', error_ = m_MSG WHERE id = r_log.id;
          UPDATE log_loads SET state = 'ошибка', error_ = m_MSG WHERE id = m_log_id;

    END; /**/
    RETURN NEXT r_log;
  END LOOP;
  CLOSE c_log;
  RETURN;
END;
$$
;

create function import_fdb_divisions(p_log_id integer, m_log_id integer) returns text
	language plpgsql
as $$
DECLARE
  r_ft_div ft_divisions[];
  r_div divisions[];
BEGIN
-- Копирование агружаемых данных в массив
  SELECT ARRAY( SELECT ROW(id, code, name, parent_id)::ft_divisions
                FROM ft_divisions fd
                WHERE fd.id IN (SELECT obj_id FROM ft_relations r WHERE r.log_id = p_log_id))
  INTO r_ft_div;
-- Вставка отсутствующих записей
  WITH
    f  AS ( SELECT (r).* from (SELECT unnest(r_ft_div) as r) x),
    fi AS ( SELECT f.code, f.name, f.parent_id, f.id, d.source_id
            FROM f
            LEFT JOIN divisions d ON (d.source_id = f.id)
            WHERE d.id IS NULL
          ),
    i  AS ( INSERT INTO divisions (code, name, source_id)
            SELECT code, name, id FROM fi /*WHERE fi.source_id IS NULL*/ ORDER BY ID
            RETURNING *
          )
  SELECT ARRAY( SELECT ROW(id, code, name, parent_id, source_id)::divisions FROM i) INTO r_div;
-- Изменение атрибутов записей и вычисление source_id для вставленных записей
  WITH
    f  AS ( SELECT (r).* from (SELECT unnest(r_ft_div) as r) x),
    i  AS ( SELECT (r).* from (SELECT unnest(r_div) as r) x),
    fu AS ( SELECT d.id, f.code, f.name, p.id AS parent_id
            FROM divisions d
            LEFT JOIN f ON (f.id = d.source_id)

            LEFT JOIN i ON (i.id = d.id)
            LEFT JOIN f AS fp ON (fp.id = i.source_id)
            LEFT JOIN divisions p ON (p.source_id = fp.parent_id)

            WHERE (d.source_id IN (SELECT id FROM f) OR d.id IN (SELECT id FROM i)) AND
                  (i.source_id IS NOT NULL OR d.name <> f.name OR d.code <> f.code)
          )
    UPDATE divisions d
    SET code = fu.code,
        name = fu.name,
        parent_id = coalesce(fu.parent_id, 0)
    FROM fu WHERE d.id = fu.id;

  RETURN NULL;
END;
$$
;

create function import_fdb_indicators(p_log_id integer, m_log_id integer) returns text
	language plpgsql
as $$
DECLARE
  r_ft_ind ft_indicators[];
BEGIN
  -- Копирование агружаемых данных в массив
  SELECT ARRAY( SELECT ROW(ft.id, ft.state, ft.log_id, ft.technology_type, ft.service_type, ft.abonent_type,
                           coalesce(d.id, ft.division_id), coalesce(r.id, ft.region_id), coalesce(t.id, ft.tariff_id),
                           ft.period_type, ft.period,
                           ft.valbeg, ft.sumbeg, ft.valdb, ft.sumdb, ft.valcr, ft.sumcr, ft.valend, ft.sumend)::ft_indicators
                FROM ft_indicators ft
                  LEFT JOIN divisions d ON (d.source_id = ft.division_id)
                  LEFT JOIN regions r ON (r.source_id = ft.region_id)
                  LEFT JOIN tariffs t ON (t.source_id = ft.tariff_id)
                WHERE ft.id IN (SELECT obj_id FROM ft_relations r WHERE r.log_id = p_log_id))
  INTO r_ft_ind;
  -- Отметка замененными записи загруженные по другим операциям
  WITH
      f  AS ( SELECT (r).* from (SELECT unnest(r_ft_ind) as r) x),
      s  AS ( SELECT i.id
              FROM f, indicators i
              WHERE i.source_id = f.id AND i.state = 'активная'  AND
                    NOT (array_position(i.log_id, m_log_id) = 1 AND array_length(i.log_id, 1) = 1) -- наличие ссылок на другие записи в логе
            )
  UPDATE indicators i
  SET state = 'заменена', log_id = array_append(array_remove(log_id, m_log_id), m_log_id)
  FROM s WHERE i.id = s.id;
-- Замена ранее загруженных записей
  WITH
      f  AS ( SELECT (r).* from (SELECT unnest(r_ft_ind) as r) x),
      s  AS ( SELECT i.id, f.technology_type, f.service_type, f.abonent_type,
                     f.division_id, f.region_id, f.tariff_id, f.period_type, f.period,
                     f.valbeg, f.sumbeg, f.valdb, f.sumdb, f.valcr, f.sumcr, f.valend, f.sumend
              FROM f, indicators i
              WHERE i.source_id = f.id AND i.state = 'активная'   AND
                    array_position(i.log_id, m_log_id) = 1 AND array_length(i.log_id, 1) = 1 -- наличие ссылок на другие записи в логе
            )
  UPDATE indicators i
  SET (technology_type, service_type, abonent_type,
       division_id, region_id, tariff_id, period_type, period,
       valbeg, sumbeg, valdb, sumdb, valcr, sumcr, valend, sumend) =
        (SELECT s.technology_type::technology_types, s.service_type::service_types, s.abonent_type::abonent_types,
                s.division_id, s.region_id, s.tariff_id, s.period_type::period_types, s.period,
                s.valbeg, s.sumbeg, s.valdb, s.sumdb, s.valcr, s.sumcr, s.valend, s.sumend
         FROM s
             WHERE i.id = s.id)
  WHERE i.id IN (SELECT id FROM s);
  -- Вставка отсутствующих записей
  WITH
      f  AS ( SELECT (r).* from (SELECT unnest(r_ft_ind) as r) x)
  INSERT INTO indicators (state, log_id, technology_type, service_type, abonent_type,
                          division_id, region_id, tariff_id, period_type, period,
                          valbeg, sumbeg, valdb, sumdb, valcr, sumcr, valend, sumend, source_id)
  (SELECT f.state::record_states, array[m_log_id], f.technology_type::technology_types,
     f.service_type::service_types, f.abonent_type::abonent_types,
     f.division_id, f.region_id, f.tariff_id, f.period_type::period_types, f.period,
     f.valbeg, f.sumbeg, f.valdb, f.sumdb, f.valcr, f.sumcr, f.valend, f.sumend, f.id
   FROM f
     LEFT JOIN indicators i ON (i.source_id = f.id AND i.state = 'активная')
   WHERE f.state = 'активная' AND i.id IS NULL);

  RETURN NULL;
END;
$$
;

create function form_division_decode(p_div_id integer, p_type integer DEFAULT 0) returns character varying
	language sql
as $$
SELECT name FROM divisions WHERE id = p_div_id
$$
;

create function form_make_attrs(p_attr_defs form_attributes[]) returns form_attr[]
	language plpgsql
as $$
DECLARE
  m_rec RECORD;
  m_attr form_attr[];
  m_attr_tmp form_attr[];
  m_prev_field_ varchar(16);
  m_attr_num SMALLINT;
  m_value_num SMALLINT;
  m_SQL text;
  m_val text;
  m_for_name text;
  m_for_sort text;
BEGIN

  m_prev_field_ = '';
  m_attr_num = 0;
  FOR m_rec IN
  WITH
      c_ AS (SELECT unnest(p_attr_defs) AS r),
      c  AS (SELECT row_number() OVER() AS rn, (r).* FROM c_ WHERE length((r).field_) > 0)
  SELECT * FROM c LOOP
    IF m_rec.field_ <> 'value' THEN
      m_attr_num = m_attr_num  + 1;
      m_val = m_rec.field_;
      IF m_rec.expr_ IS NULL THEN
        m_for_name = m_rec.field_;
        m_for_sort = m_rec.field_;
      ELSE
        m_for_name = m_rec.expr_ || '(' || m_rec.field_;
        m_for_sort = m_for_name || ', 1)';
        m_for_name = m_for_name || ')';
      END IF;
      m_SQL = format('SELECT (ARRAY(SELECT ROW(y.*)::form_attr ' ||
                     'FROM (SELECT %s, row_number() OVER(), %2$L, %3$s, %4$s, %5$s ' ||
                     'FROM (SELECT DISTINCT %2$s FROM indicators) x ORDER BY 6) y ) )',
                     m_attr_num, m_rec.field_,  m_val, m_for_name, m_for_sort );
      -- raise notice 'r: %', m_SQL;
      EXECUTE m_SQL INTO m_attr_tmp;
    ELSE
      IF m_prev_field_ <> 'value' THEN
        m_value_num = 1;
        m_attr_num = m_attr_num  + 1;
      else
        m_value_num = m_value_num + 1;
      END IF;
      SELECT (ARRAY(SELECT ROW(m_attr_num, m_value_num, m_rec.field_, m_rec.expr_, NULL, NULL)::form_attr))
      INTO m_attr_tmp;
    END IF;
    m_prev_field_ = m_rec.field_;
    m_attr = array_cat(m_attr, m_attr_tmp);
    m_attr_tmp = null::form_attr[];
  END LOOP;

  RETURN m_attr;
END;
$$
;

create function form_make_keys(p_attr form_attr[]) returns form_attr_keys[]
	language plpgsql
as $$
BEGIN
  RETURN
    ARRAY(SELECT ROW( attr_key_in, attr_key_out )::form_attr_keys
        FROM (WITH RECURSIVE z(lavel, attr_num, attr_key_in, attr_key_out)
               AS ( SELECT 0::integer, 0::integer, null::varchar(32)[], ''::varchar(16)
                    UNION ALL
                    SELECT lavel+1, y.attr_num, array_cat(attr_key_in, ARRAY[y.val])::varchar(32)[], (attr_key_out || to_char(y.num,'FM09'))::varchar(16)
                    FROM z,(SELECT (r).* FROM (SELECT unnest(p_attr) AS r) rr) y
                    WHERE z.lavel < 10 and y.attr_num = z.attr_num + 1
               )
               SELECT attr_key_in, attr_key_out FROM z WHERE lavel = (SELECT max(lavel) FROM z rr)
               ORDER BY attr_key_out
             ) x );
END;
$$
;

