--SORT_QUERY_RESULTS

-- Java JCE must be installed in order to hava a key length of 256 bits
DROP TABLE IF EXISTS table_key_1;
CREATE TABLE table_key_1 (key INT, value STRING) LOCATION '/build/ql/test/data/warehouse/table_key_1';
CRYPTO CREATE_KEY --keyName key_1 --bitLength 128;
CRYPTO CREATE_ZONE --keyName key_1 --path /build/ql/test/data/warehouse/table_key_1;

DROP TABLE IF EXISTS table_key_2;
CREATE TABLE table_key_2 (key INT, value STRING) LOCATION '/build/ql/test/data/warehouse/table_key_2';
CRYPTO CREATE_KEY --keyName key_2 --bitLength 256;
CRYPTO CREATE_ZONE --keyName key_2 --path /build/ql/test/data/warehouse/table_key_2;

INSERT OVERWRITE TABLE table_key_1 SELECT * FROM src;
INSERT OVERWRITE TABLE table_key_2 SELECT * FROM src;

EXPLAIN EXTENDED SELECT * FROM table_key_1 t1 JOIN table_key_2 t2 WHERE (t1.key = t2.key);
SELECT * FROM table_key_1 t1 JOIN table_key_2 t2 WHERE (t1.key = t2.key);

DROP TABLE table_key_1;
DROP TABLE table_key_2;

CRYPTO DELETE_KEY --keyName key_1;
CRYPTO DELETE_KEY --keyName key_2;