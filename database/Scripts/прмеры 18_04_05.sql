  /*
    m_s = 'WITH ' || CHR(13) ||
          's  AS (SELECT (r).* FROM (SELECT unnest($1::form_attr[]) AS r) x),' || CHR(13) || m_s ||
          'x AS (SELECT  s1.*,' || m_ord_col || ' ord_col' || CHR(13) || m_cross_col || ' ORDER BY ord_col)' || CHR(13) ||
          'SELECT num_attr, row_number () OVER(), attr, val, for_name, ord_col FROM x';
  */
/*  
  m_s = 'WITH ' || CHR(13) ||
      's  AS (select * from json_populate_recordset(null::form_attr,''[{"num_attr":1,"num":1,"attr":"period","val":"2017-01-01","for_name":"2017-01-01","for_sort":"2017-01-01"},{"num_attr":1,"num":2,"attr":"period","val":"2017-02-01","for_name":"2017-02-01","for_sort":"2017-02-01"},{"num_attr":1,"num":3,"attr":"period","val":"2017-03-01","for_name":"2017-03-01","for_sort":"2017-03-01"},{"num_attr":1,"num":4,"attr":"period","val":"2017-04-01","for_name":"2017-04-01","for_sort":"2017-04-01"},{"num_attr":1,"num":5,"attr":"period","val":"2017-05-01","for_name":"2017-05-01","for_sort":"2017-05-01"},{"num_attr":1,"num":6,"attr":"period","val":"2017-06-01","for_name":"2017-06-01","for_sort":"2017-06-01"},{"num_attr":1,"num":7,"attr":"period","val":"2017-07-01","for_name":"2017-07-01","for_sort":"2017-07-01"},{"num_attr":1,"num":8,"attr":"period","val":"2017-08-01","for_name":"2017-08-01","for_sort":"2017-08-01"},{"num_attr":1,"num":9,"attr":"period","val":"2017-09-01","for_name":"2017-09-01","for_sort":"2017-09-01"},{"num_attr":1,"num":10,"attr":"period","val":"2017-10-01","for_name":"2017-10-01","for_sort":"2017-10-01"},{"num_attr":1,"num":11,"attr":"period","val":"2017-11-01","for_name":"2017-11-01","for_sort":"2017-11-01"},{"num_attr":1,"num":12,"attr":"period","val":"2017-12-01","for_name":"2017-12-01","for_sort":"2017-12-01"},{"num_attr":1,"num":13,"attr":"period","val":"2018-01-01","for_name":"2018-01-01","for_sort":"2018-01-01"},{"num_attr":1,"num":14,"attr":"period","val":"2018-02-01","for_name":"2018-02-01","for_sort":"2018-02-01"},{"num_attr":1,"num":15,"attr":"period","val":"2018-03-01","for_name":"2018-03-01","for_sort":"2018-03-01"},{"num_attr":1,"num":16,"attr":"period","val":"2018-04-01","for_name":"2018-04-01","for_sort":"2018-04-01"},{"num_attr":1,"num":17,"attr":"period","val":"2018-05-01","for_name":"2018-05-01","for_sort":"2018-05-01"},{"num_attr":1,"num":18,"attr":"period","val":"2018-06-01","for_name":"2018-06-01","for_sort":"2018-06-01"},{"num_attr":1,"num":19,"attr":"period","val":"2018-07-01","for_name":"2018-07-01","for_sort":"2018-07-01"},{"num_attr":1,"num":20,"attr":"period","val":"2018-08-01","for_name":"2018-08-01","for_sort":"2018-08-01"},{"num_attr":1,"num":21,"attr":"period","val":"2018-09-01","for_name":"2018-09-01","for_sort":"2018-09-01"},{"num_attr":1,"num":22,"attr":"period","val":"2018-10-01","for_name":"2018-10-01","for_sort":"2018-10-01"},{"num_attr":1,"num":23,"attr":"period","val":"2018-11-01","for_name":"2018-11-01","for_sort":"2018-11-01"},{"num_attr":1,"num":24,"attr":"period","val":"2018-12-01","for_name":"2018-12-01","for_sort":"2018-12-01"},{"num_attr":2,"num":1,"attr":"abonent_type","val":"B2B","for_name":"B2B","for_sort":"B2B"},{"num_attr":2,"num":2,"attr":"abonent_type","val":"B2C","for_name":"B2C","for_sort":"B2C"},{"num_attr":2,"num":3,"attr":"abonent_type","val":"B2O","for_name":"B2O","for_sort":"B2O"},{"num_attr":2,"num":4,"attr":"abonent_type","val":"Всего","for_name":"Всего","for_sort":"Всего"},{"num_attr":2,"num":5,"attr":"abonent_type","val":"Выручка по сегментам","for_name":"Выручка по сегментам","for_sort":"Выручка по сегментам"},{"num_attr":2,"num":6,"attr":"abonent_type","val":"Доп план по Бюджет+","for_name":"Доп план по Бюджет+","for_sort":"Доп план по Бюджет+"},{"num_attr":2,"num":7,"attr":"abonent_type","val":"Итого","for_name":"Итого","for_sort":"Итого"},{"num_attr":2,"num":8,"attr":"abonent_type","val":"Прочие","for_name":"Прочие","for_sort":"Прочие"}]''::json)),' || CHR(13) || m_s ||
      'x AS (SELECT  s1.*,' || m_ord_col || ' ord_col' || CHR(13) || m_cross_col || ' ORDER BY ord_col)' || CHR(13) ||
      'SELECT num_attr, row_number () OVER(), attr, val, for_name, ord_col FROM x';

--  m_XX = to_json(m_attr);
  EXECUTE m_s INTO m_val;-- USING '[{"num_attr":1,"num":1,"attr":"period","val":"2017-01-01","for_name":"2017-01-01","for_sort":"2017-01-01"},{"num_attr":1,"num":2,"attr":"period","val":"2017-02-01","for_name":"2017-02-01","for_sort":"2017-02-01"},{"num_attr":1,"num":3,"attr":"period","val":"2017-03-01","for_name":"2017-03-01","for_sort":"2017-03-01"},{"num_attr":1,"num":4,"attr":"period","val":"2017-04-01","for_name":"2017-04-01","for_sort":"2017-04-01"},{"num_attr":1,"num":5,"attr":"period","val":"2017-05-01","for_name":"2017-05-01","for_sort":"2017-05-01"},{"num_attr":1,"num":6,"attr":"period","val":"2017-06-01","for_name":"2017-06-01","for_sort":"2017-06-01"},{"num_attr":1,"num":7,"attr":"period","val":"2017-07-01","for_name":"2017-07-01","for_sort":"2017-07-01"},{"num_attr":1,"num":8,"attr":"period","val":"2017-08-01","for_name":"2017-08-01","for_sort":"2017-08-01"},{"num_attr":1,"num":9,"attr":"period","val":"2017-09-01","for_name":"2017-09-01","for_sort":"2017-09-01"},{"num_attr":1,"num":10,"attr":"period","val":"2017-10-01","for_name":"2017-10-01","for_sort":"2017-10-01"},{"num_attr":1,"num":11,"attr":"period","val":"2017-11-01","for_name":"2017-11-01","for_sort":"2017-11-01"},{"num_attr":1,"num":12,"attr":"period","val":"2017-12-01","for_name":"2017-12-01","for_sort":"2017-12-01"},{"num_attr":1,"num":13,"attr":"period","val":"2018-01-01","for_name":"2018-01-01","for_sort":"2018-01-01"},{"num_attr":1,"num":14,"attr":"period","val":"2018-02-01","for_name":"2018-02-01","for_sort":"2018-02-01"},{"num_attr":1,"num":15,"attr":"period","val":"2018-03-01","for_name":"2018-03-01","for_sort":"2018-03-01"},{"num_attr":1,"num":16,"attr":"period","val":"2018-04-01","for_name":"2018-04-01","for_sort":"2018-04-01"},{"num_attr":1,"num":17,"attr":"period","val":"2018-05-01","for_name":"2018-05-01","for_sort":"2018-05-01"},{"num_attr":1,"num":18,"attr":"period","val":"2018-06-01","for_name":"2018-06-01","for_sort":"2018-06-01"},{"num_attr":1,"num":19,"attr":"period","val":"2018-07-01","for_name":"2018-07-01","for_sort":"2018-07-01"},{"num_attr":1,"num":20,"attr":"period","val":"2018-08-01","for_name":"2018-08-01","for_sort":"2018-08-01"},{"num_attr":1,"num":21,"attr":"period","val":"2018-09-01","for_name":"2018-09-01","for_sort":"2018-09-01"},{"num_attr":1,"num":22,"attr":"period","val":"2018-10-01","for_name":"2018-10-01","for_sort":"2018-10-01"},{"num_attr":1,"num":23,"attr":"period","val":"2018-11-01","for_name":"2018-11-01","for_sort":"2018-11-01"},{"num_attr":1,"num":24,"attr":"period","val":"2018-12-01","for_name":"2018-12-01","for_sort":"2018-12-01"},{"num_attr":2,"num":1,"attr":"abonent_type","val":"B2B","for_name":"B2B","for_sort":"B2B"},{"num_attr":2,"num":2,"attr":"abonent_type","val":"B2C","for_name":"B2C","for_sort":"B2C"},{"num_attr":2,"num":3,"attr":"abonent_type","val":"B2O","for_name":"B2O","for_sort":"B2O"},{"num_attr":2,"num":4,"attr":"abonent_type","val":"Всего","for_name":"Всего","for_sort":"Всего"},{"num_attr":2,"num":5,"attr":"abonent_type","val":"Выручка по сегментам","for_name":"Выручка по сегментам","for_sort":"Выручка по сегментам"},{"num_attr":2,"num":6,"attr":"abonent_type","val":"Доп план по Бюджет+","for_name":"Доп план по Бюджет+","for_sort":"Доп план по Бюджет+"},{"num_attr":2,"num":7,"attr":"abonent_type","val":"Итого","for_name":"Итого","for_sort":"Итого"},{"num_attr":2,"num":8,"attr":"abonent_type","val":"Прочие","for_name":"Прочие","for_sort":"Прочие"}]';
*/
  SELECT to_json(ARRAY(
                     select ROW(j.*) from json_populate_recordset(null::form_attr,to_json(m_attr)) j
                 )) INTO m_XX;
  -----------

/*
  SELECT MAX((f).num_) INTO m_max_attrs FROM (SELECT unnest(m_attr)::form_attr as f) x;

  WITH
      s AS (SELECT * FROM generate_series(1, m_max_attrs) as num_),
      co AS (SELECT unnest(m_columns) as f),
      at AS (SELECT (a).* FROM (SELECT unnest(m_attr) as a) at_),
      c  AS (SELECT row_number() OVER() AS num_c, (f).* FROM co)
  SELECT
    to_json(ARRAY( SELECT ROW(num_, field_, title_, attr_val, css_)::form_columns
                   FROM (SELECT s.num_, c.field_, c.title_,
                           coalesce(at.attr_val,CASE WHEN c.field_ = 'value' THEN c.expr_ ELSE NULL END ) as attr_val,
                           c.css_
                         FROM s
                           CROSS JOIN c
                           LEFT JOIN at on (at.attr_ = c.field_ and at.num_ = s.num_)
                         ORDER BY s.num_, c.num_c, at.num_ ) r1
            ))
  INTO o_def_columns ;
*/
--  o_sql_get_data = m_XX;

CREATE OR REPLACE FUNCTION form_make_definition(p_form_id integer,
  OUT o_sql_get_data text,
  OUT o_def_columns text,
  OUT o_def_rows text) AS $$
DECLARE
  m_rec RECORD;
  m_attr form_attr[];
  m_attr_tmp form_attr[];

  m_columns form_attributes[];
  m_rows form_attributes[];
  m_values form_attributes[];
  m_prev_field_ varchar(16);
  m_attr_num SMALLINT;
  m_value_num SMALLINT;

  m_SQL text;
  m_XX text;
  m_s text;

BEGIN
  SELECT columns, rows, values INTO m_columns , m_rows, m_values FROM forms WHERE id = p_form_id;

  m_prev_field_ = '';
  m_attr_num = 0;
  FOR m_rec IN
    WITH
        c_ AS (SELECT unnest(m_columns) AS r),
        c  AS (SELECT row_number() OVER() AS rn, (r).* FROM c_ WHERE length((r).field_) > 0)
    SELECT * FROM c LOOP
      IF m_rec.field_ <> 'value' THEN
          m_attr_num = m_attr_num  + 1;
          m_SQL = format('SELECT (ARRAY(SELECT ROW(%s, row_number() OVER(), %2$L, %2$s, %2$s, %2$s)::form_attr
                      FROM (SELECT DISTINCT %2$s FROM indicators ORDER BY %2$s) xx))', m_attr_num, m_rec.field_);
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
      raise notice 'r: %', m_rec.rn;
  END LOOP;
-----------

  SELECT to_json(ARRAY(
                     SELECT ROW( attr_key_in, attr_key_out ) FROM (
  WITH RECURSIVE z(lavel, attr_num, attr_key_in, attr_key_out)
  AS ( SELECT 0::integer, 0::integer, null::varchar(32)[], ''::varchar(16)
       UNION ALL
       SELECT lavel+1, y.attr_num, array_cat(attr_key_in, ARRAY[y.val])::varchar(32)[], (attr_key_out || to_char(y.num,'FM09'))::varchar(16)
       FROM z,(SELECT (r).* FROM (SELECT unnest(m_attr) AS r) rr) y
       WHERE z.lavel < 10 and y.attr_num = z.attr_num + 1
      )
  SELECT attr_key_in, attr_key_out FROM z WHERE lavel = (SELECT max(lavel) FROM z rr)
  ORDER BY attr_key_out

                 )XX)) INTO m_XX;

  SELECT m_s, to_json(m_attr), m_XX INTO o_sql_get_data, o_def_rows, o_def_columns ;

  RETURN;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION form_make_definition(p_form_id integer,
  OUT o_sql_get_data text,
  OUT o_def_columns text,
  OUT o_def_rows text) AS $$
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

  SELECT to_json(ARRAY(
                     SELECT ROW( attr_key_in, attr_key_out ) FROM (
  WITH RECURSIVE z(lavel, attr_num, attr_key_in, attr_key_out)
  AS ( SELECT 0::integer, 0::integer, null::varchar(32)[], ''::varchar(16)
       UNION ALL
       SELECT lavel+1, y.attr_num, array_cat(attr_key_in, ARRAY[y.val])::varchar(32)[], (attr_key_out || to_char(y.num,'FM09'))::varchar(16)
       FROM z,(SELECT (r).* FROM (SELECT unnest(m_attr_cols) AS r) rr) y
       WHERE z.lavel < 10 and y.attr_num = z.attr_num + 1
      )
  SELECT attr_key_in, attr_key_out FROM z WHERE lavel = (SELECT max(lavel) FROM z rr)
  ORDER BY attr_key_out

                 )XX)) INTO m_XX;

  SELECT m_s, to_json(m_attr_rows), m_XX INTO o_sql_get_data, o_def_rows, o_def_columns ;

  RETURN;
END;
$$ LANGUAGE plpgsql;