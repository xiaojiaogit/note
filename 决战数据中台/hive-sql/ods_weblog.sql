drop table if exists ods_tmp;
create table ods_tmp(
  remote_addr string comment '地址',
  x01 string,
  remote_user string comment '用户',
  datetimes bigint comment '日期时间',
  http_method string comment '请求方法',
  url string comment '连接网址',
  domains string comment '域名',
  url_2 string comment ' http://localhost:8081 ',
  title string comment 'Title_svip',
  screen_height string comment '显示屏的高度',
  screen_width string comment '显示屏的宽度',
  screen_colordepth string comment '显示屏的',
  navigator_language string comment '语言',
  account string comment '账户',
  session_id string comment '识别码',
  http_version string comment '版本',
  http_status string comment '状态',
  body_bytes_sent string comment '字节',
  http_referer string comment '来源',
  http_user_agent string comment '客户端',
  http_x_forwarded_for string comment '递交文档'
)
partitioned by (dt string)
row format delimited fields terminated by '\001';

load data inpath '/flume/t_yunpan/2021/03/06/09' overwrite into table ods_tmp partition(dt='2021-03-06');

drop table if exists ods_weblog;
create table ods_weblog(
  remote_addr string comment '地址',
  remote_user string comment '用户',
  datetimes string comment '日期时间',
  year string comment '年',
  month string comment '月',
  day string comment '日', 
  hour string comment '时',
  minute string comment '分',
  http_method string comment '请求方法',
  url string comment '连接网址',
  domains string comment '域名',
  url_2 string comment ' http://localhost:8081 ',
  title string comment 'Title_svip',
  screen_height string comment '显示屏的高度',
  screen_width string comment '显示屏的宽度',
  screen_colordepth string comment '显示屏的',
  navigator_language string comment '语言',
  account string comment '账户',
  session_id string comment '识别码',
  http_version string comment '版本',
  http_status string comment '状态',
  body_bytes_sent string comment '字节',
  http_referer string comment '来源',
  http_user_agent string comment '客户端',
  http_x_forwarded_for string comment '递交文档'
)
partitioned by (dt string);


drop table if exists dwd_weblog_result;
create table if not exists  dwd_weblog_result(
    year string,
    month string,
    day string,
    hour string,
    pv int,
    uv int,
    ip int,
    newuser int,
    visit_tmes int,
    avg_pv decimal(10, 2),
    avg_visit_times decimal(10, 2),
    time_frame string
) ROW FORMAT delimited FIELDS TERMINATED BY '\t';

drop table if exists dwd_weblog_user_history;
create table if not exists  dwd_weblog_user_history (
  ip string,
  year string,
  month string,
  day string,
  hour string
) ROW FORMAT delimited FIELDS TERMINATED BY '\t';


