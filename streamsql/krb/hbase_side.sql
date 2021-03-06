CREATE TABLE ods_foo (
  id INT,
  name VARCHAR NOT NULL
) WITH (
  type ='kafka11',
  bootstrapServers ='kudu1:9092',
  offsetReset = 'latest',
  topic = 'wuren_foo'
);

CREATE TABLE dim_foo (
  -- cf1:id INT,
  cf1:name VARCHAR as name,
  PRIMARY KEY (rowkey),
  PERIOD FOR SYSTEM_TIME
) WITH (
	type ='hbase',
	zookeeperQuorum ='cdp003.dtstack.com:2181,cdp002.dtstack.com:2181,cdp001.dtstack.com:2181',
	zookeeperParent ='/hbase',
	tableName ='wuren_foo',
  parallelism ='1',
  cache ='LRU',
  hbase.security.auth.enable='true',
  hbase.security.authentication='kerberos', 
  hbase.sasl.clientconfig='HBaseClient',
  hbase.kerberos.regionserver.principal='hbase/_HOST@DTSTACK.COM',  
  hbase.keytab='krb5.keytab',
  hbase.principal='wuren@DTSTACK.COM',
  java.security.krb5.conf='krb5.conf'
);

CREATE TABLE dwd_foo(
  id INT,
  name VARCHAR
) with (
  type = 'console'
);

INSERT INTO dwd_foo
    SELECT ods_foo.id, dim_foo.name
    FROM ods_foo
    LEFT JOIN dim_foo
    ON ods_foo.id = dim_foo.rowkey;