
CREATE FOREIGN TABLE public.ft_log_loads(
  id         NUMERIC,
  sourse_id  NUMERIC,
  state      varchar(50),
  operation_ varchar(16),
  object_    varchar(16),
  author_    varchar(32),
  time_      timestamp,
  comment_   varchar(80)
)
SERVER ssc55db OPTIONS (schema 'BARS_APPL', table 'LOG_LOADS');


ALTER FOREIGN TABLE public.ft_log_loads OWNER TO postgres;

CREATE FOREIGN TABLE public.ft_divisions(
 id           NUMERIC,
 code         varchar(32), 
 name         varchar(128), 
 parent_id    NUMERIC, 
 sourse_id    NUMERIC,
last_log_id  NUMERIC
)
SERVER ssc55db OPTIONS (schema 'BARS_APPL', table 'DIVISIONS');


ALTER FOREIGN TABLE public.ft_divisions OWNER TO postgres;

CREATE FOREIGN TABLE public.ft_RELATIONS(
 log_id NUMERIC, 
 obj_id NUMERIC
 )
SERVER ssc55db OPTIONS (schema 'BARS_APPL', table 'RELATION');

ALTER FOREIGN TABLE public.ft_RELATIONS OWNER TO postgres;

CREATE FOREIGN TABLE public.ft_INDICATORS(
id              NUMERIC, 
 state           varchar(50), 
 log_id          NUMERIC, 
 technology_type varchar(50), 
 service_type    varchar(50), 
 abonent_types   varchar(50), 
 division_id     NUMERIC, 
 region_id       NUMERIC,
 tariff_id       NUMERIC, 
 period_type     varchar(50), 
 period          date, 
 valbeg          NUMERIC, 
 sumbeg          NUMERIC, 
 valdb           NUMERIC, 
 sumdb           NUMERIC, 
 valcr           NUMERIC, 
 sumcr           NUMERIC, 
 valend          NUMERIC, 
 sumend          NUMERIC

 )
SERVER ssc55db OPTIONS (schema 'BARS_APPL', table 'INDICATORS');

ALTER FOREIGN TABLE public.ft_INDICATORS OWNER TO postgres;

