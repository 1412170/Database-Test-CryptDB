DROP DATABASE IF EXISTS cryptdbtest;
CREATE DATABASE IF NOT EXISTS cryptdbtest;
USE cryptdbtest;
------------------------------
-- TEST SINGLE INSERT
------------------------------
CREATE TABLE test_insert (id integer , age integer, salary integer, address text, name text);
INSERT INTO test_insert VALUES (1, 21, 100, '24 Rosedale, Toronto, ONT', 'Pat Carlson');
SELECT * FROM test_insert;
INSERT INTO test_insert (id, age, salary, address, name) VALUES (2, 23, 101, '25 Rosedale, Toronto, ONT', 'Pat Carlson2');
SELECT * FROM test_insert;
INSERT INTO test_insert (age, address, salary, name, id) VALUES (25, '26 Rosedale, Toronto, ONT', 102, 'Pat2 Carlson', 3);
SELECT * FROM test_insert;
INSERT INTO test_insert (age, address, salary, name) VALUES (26, 'test address', 30, 'test name');
SELECT * FROM test_insert;
INSERT INTO test_insert (age, address, salary, name) VALUES (27, 'test address2', 31, 'test name');
INSERT INTO test_insert (age) VALUES (40);
SELECT age FROM test_insert;
INSERT INTO test_insert (name) VALUES ('Wendy');
SELECT name FROM test_insert WHERE id = 10;

-- update test_insert id oEq DET
INSERT INTO test_insert (name, address, id, age) VALUES ('Peter Pan', 'first star to the right and straight on till morning', 42, 10);
SELECT name, address, age FROM test_insert WHERE id = 42;
DROP TABLE test_insert;

------------------------------
--  TEST SINGLE SELECT
------------------------------
CREATE TABLE IF NOT EXISTS test_select (id integer, age integer, salary integer, address text, name text);
INSERT INTO test_select VALUES (1, 10, 0, 'first star to the right and straight on till morning', 'Peter Pan');
INSERT INTO test_select VALUES (2, 16, 1000, 'Green Gables', 'Anne Shirley');
INSERT INTO test_select VALUES (3, 8, 0, 'London', 'Lucy');
INSERT INTO test_select VALUES (4, 10, 0, 'London', 'Edmund');
INSERT INTO test_select VALUES (5, 30, 100000, '221B Baker Street', 'Sherlock Holmes');
SELECT * FROM test_select WHERE id IN (1, 2, 10, 20, 30);
-- update test_select id oEq DET
SELECT * FROM test_select WHERE id BETWEEN 3 AND 5;
-- update test_select id oOrder OPE
SELECT NULLIF(1, id) FROM test_select;
SELECT NULLIF(id, 1) FROM test_select;
SELECT NULLIF(id, id) FROM test_select;
SELECT NULLIF(1, 2) FROM test_select;
SELECT NULLIF(1, 1) FROM test_select;
SELECT * FROM test_select;
SELECT max(id) FROM test_select;
SELECT max(salary) FROM test_select;
-- update test_select salary oOrder OPE
SELECT COUNT(*) FROM test_select;
SELECT COUNT(DISTINCT age) FROM test_select;
-- update test_select age oEq DET
SELECT COUNT(DISTINCT(address)) FROM test_select;
--update test_select address oEq DET
SELECT name FROM test_select;
SELECT address FROM test_select;
SELECT * FROM test_select WHERE id>3;
SELECT * FROM test_select WHERE age = 8;
SELECT * FROM test_select WHERE salary = 15;
--update test_select salary oEq DET
SELECT * FROM test_select WHERE age > 10;
-- update test_select age oOrder OPE
SELECT * FROM test_select WHERE age = 10 AND salary = 0;
SELECT * FROM test_select WHERE age = 10 OR salary = 0;
SELECT * FROM test_select WHERE name = 'Peter Pan';
-- update test_select name oEq DET
SELECT * FROM test_select WHERE address='Green Gables';
SELECT * FROM test_select WHERE address <= '221C';
-- update test_select address oOrder OPE))
SELECT * FROM test_select WHERE address >= 'Green Gables' AND age > 9;
SELECT * FROM test_select WHERE address >= 'Green Gables' OR age > 9;
SELECT * FROM test_select WHERE address < 'ffFFF';
SELECT * FROM test_select ORDER BY id;
SELECT * FROM test_select ORDER BY salary;
SELECT * FROM test_select ORDER BY name;
--  update test_select name oOrder OPE
SELECT * FROM test_select ORDER BY address;
SELECT sum(age) FROM test_select GROUP BY address ORDER BY address;
SELECT salary, max(id) FROM test_select GROUP BY salary ORDER BY salary;
SELECT * FROM test_select GROUP BY age ORDER BY age;
SELECT * FROM test_select ORDER BY age ASC;
SELECT * FROM test_select ORDER BY address DESC;
SELECT sum(age) as z FROM test_select;
SELECT sum(age) z FROM test_select;
SELECT min(t.id) a FROM test_select AS t;
SELECT t.address AS b FROM test_select t;
SELECT * FROM test_select HAVING age;

-- update test_select age oPLAIN PLAINVAL
SELECT * FROM test_select HAVING age && id;

DROP TABLE test_select;

------------------------------
-- TEST SUBQUERY
------------------------------
CREATE TABLE subqueryphun (morse integer, code integer);
CREATE TABLE numerouno (uno integer, dos integer, tres integer);
INSERT INTO subqueryphun VALUES (100, 200), (1000, 2000), (200, 100), (25, 25), (50, 50);
INSERT INTO numerouno VALUES (1, 2, 3), (100, 200, 300), (1000, 2000, 3000);

-- SINGLE ROW SUBQUERIES
-- bad query, subquery returns multiple rows
-- > forces cryptdb to propagate an error on a query after onion adjustment
SELECT * FROM subqueryphun WHERE (SELECT code FROM subqueryphun);
SELECT * FROM subqueryphun WHERE (SELECT code FROM subqueryphun LIMIT 1);
SELECT * FROM subqueryphun WHERE morse IN (SELECT morse FROM subqueryphun);
SELECT * FROM subqueryphun wHERE morse IN (SELECT 100 FROM subqueryphun);
SELECT * FROM subqueryphun WHERE (SELECT 1 FROM subqueryphun AS q WHERE q.morse LIMIT 1);
-- use a table from higher level select in subquery
SELECT * FROM numerouno WHERE (SELECT dos FROM subqueryphun WHERE subqueryphun.morse = numerouno.uno LIMIT 1);
-- use an alias from higher level select in subquery
SELECT * FROM numerouno AS n1 WHERE (SELECT tres FROM subqueryphun WHERE subqueryphun.morse = n1.uno LIMIT 1);

-- IN SUBQUERIES
SELECT * FROM subqueryphun WHERE morse IN (SELECT morse FROM subqueryphun);

-- EXISTS SUBQUERIES
SELECT * FROM subqueryphun WHERE EXISTS(SELECT * FROM subqueryphun);
SELECT * FROM numerouno as n1 WHERE EXISTS(SELECT * FROM subqueryphun WHERE subqueryphun.morse = n1.uno);

-- MISC SUBQUERY BUGS
-- summation in subquery was causing segfault
SELECT (SELECT SUM(uno) FROM numerouno);
SELECT * FROM numerouno WHERE (SELECT SUM(uno) FROM numerouno);
DROP TABLE subqueryphun;
DROP TABLE numerouno;

------------------------------
-- TEST SINGLE JOIN
------------------------------
CREATE TABLE test_join1 (id integer, age integer, salary integer, address text, name text);
CREATE TABLE test_join2 (id integer, books integer, name text);
INSERT INTO test_join1 VALUES (1, 10, 0, 'first star to the right and straight on till morning','Peter Pan');
INSERT INTO test_join1 VALUES (2, 16, 1000, 'Green Gables', 'Anne Shirley');
INSERT INTO test_join1 VALUES (3, 8, 0, 'London', 'Lucy');
INSERT INTO test_join1 VALUES (4, 10, 0, 'London', 'Edmund');
INSERT INTO test_join1 VALUES (5, 30, 100000, '221B Baker Street', 'Sherlock Holmes');
INSERT INTO test_join2 VALUES (1, 6, 'Peter Pan');
INSERT INTO test_join2 VALUES (2, 8, 'Anne Shirley');
INSERT INTO test_join2 VALUES (3, 7, 'Lucy');
INSERT INTO test_join2 VALUES (4, 7, 'Edmund');
INSERT INTO test_join2 VALUES (10, 4, '221B Baker Street');
SELECT address FROM test_join1, test_join2 WHERE test_join1.id=test_join2.id;
-- update (test_join1 (id (oEq DETJOIN))) (test_join2 (id (oEq DETJOIN)))))
SELECT test_join1.id, test_join2.id, age, books, test_join2.name FROM test_join1, test_join2 WHERE test_join1.id = test_join2.id;
SELECT test_join1.name, age, salary, test_join2.name, books FROM test_join1, test_join2 WHERE test_join1.age=test_join2.books;
-- update (test_join1 (age (oEq DETJOIN))) (test_join2 (books (oEq DETJOIN)))))
SELECT * FROM test_join1, test_join2 WHERE test_join1.name=test_join2.name;
-- update (test_join1 (name (oEq DETJOIN))) (test_join2 (name (oEq DETJOIN)))))
SELECT * FROM test_join1, test_join2 WHERE test_join1.address=test_join2.name;
-- update (test_join1 (address (oEq DETJOIN)))))
SELECT address FROM test_join1 AS a, test_join2 WHERE a.id=test_join2.id;
SELECT a.id, b.id, age, books, b.name FROM test_join1 a, test_join2 AS b WHERE a.id=b.id;
SELECT test_join1.name, age, salary, b.name, books FROM test_join1, test_join2 b WHERE test_join1.age = b.books;
DROP TABLE test_join1;
DROP TABLE test_join2;

------------------------------
-- TEST SINGLE UPDATE
------------------------------
CREATE TABLE test_update (id integer, age integer, salary integer, address text, name text);
INSERT INTO test_update VALUES (1, 10, 0, 'first star to the right and straight on till morning', 'Peter Pan');
INSERT INTO test_update VALUES (2, 16, 1000, 'Green Gables', 'Anne Shirley');
INSERT INTO test_update VALUES (3, 8, 0, 'London', 'Lucy');
INSERT INTO test_update VALUES (4, 10, 0, 'London', 'Edmund');
INSERT INTO test_update VALUES (5, 30, 100000, '221B Baker Street', 'Sherlock Holmes');
INSERT INTO test_update VALUES (6, 11, 0 , 'hi', 'no one');
SELECT * FROM test_update;
UPDATE test_update SET age = age, address = name;
SELECT * FROM test_update;
UPDATE test_update SET name = address;
SELECT * FROM test_update;
UPDATE test_update SET salary=0;
SELECT * FROM test_update;
UPDATE test_update SET age=21 WHERE id = 6;
-- update test_update id oEq DET
SELECT * FROM test_update;
UPDATE test_update SET address='Pemberly', name = 'Elizabeth Darcy' WHERE id = 6;
SELECT * FROM test_update;
UPDATE test_update SET salary = 55000 WHERE age = 30;
-- update test_update age oEq DET
SELECT * FROM test_update;
UPDATE test_update SET salary=20000 WHERE address='Pemberly';
-- update test_update address oEq DET
SELECT * FROM test_update;
SELECT age FROM test_update WHERE age > 20;
-- update test_update age oOrder OPE
SELECT id FROM test_update;
SELECT sum(age) FROM test_update;
UPDATE test_update SET age=20 WHERE name='Elizabeth Darcy';
-- update test_update name oEq DET
SELECT * FROM test_update WHERE age > 20;
SELECT sum(age) FROM test_update;
UPDATE test_update SET age = age + 2;
SELECT age FROM test_update;
UPDATE test_update SET id = id + 10, salary = salary + 19, name = 'xxx', address = 'foo' WHERE address = 'London';
SELECT * FROM test_update;
SELECT * FROM test_update WHERE address < 'fml';
-- update test_update address oOrder OPE
UPDATE test_update SET address = 'Neverland' WHERE id = 1;
SELECT * FROM test_update;
DROP TABLE test_update;

------------------------------
-- TEST HOMORPHIC ADDITION
------------------------------
CREATE TABLE test_HOM (id integer, age integer, salary integer, address text, name text);
INSERT INTO test_HOM VALUES (1, 10, 0, 'first star to the right and straight on till morning','Peter Pan');
INSERT INTO test_HOM VALUES (2, 16, 1000, 'Green Gables', 'Anne Shirley');
INSERT INTO test_HOM VALUES (3, 8, 0, 'London', 'Lucy');
INSERT INTO test_HOM VALUES (4, 10, 0, 'London', 'Edmund');
INSERT INTO test_HOM VALUES (5, 30, 100000, '221B Baker Street', 'Sherlock Holmes');
INSERT INTO test_HOM VALUES (6, 21, 2000, 'Pemberly', 'Elizabeth');
INSERT INTO test_HOM VALUES (7, 10000, 1, 'Mordor', 'Sauron');
INSERT INTO test_HOM VALUES (8, 25, 100, 'The Heath', 'Eustacia Vye');
INSERT INTO test_HOM VALUES (12, NULL, NULL, 'nucwinter', 'gasmask++');
SELECT * FROM test_HOM;
SELECT SUM(age) FROM test_HOM;
SELECT * FROM test_HOM;
SELECT SUM(age) FROM test_HOM;
UPDATE test_HOM SET age = age + 1;
SELECT SUM(age) FROM test_HOM;
SELECT * FROM test_HOM;
UPDATE test_HOM SET age = age + 3 WHERE id=1;
-- update test_HOM id oEq DET
SELECT * FROM test_HOM;
UPDATE test_HOM SET age = 100 WHERE id = 1;
SELECT * FROM test_HOM WHERE age = 100;
-- update test_HOM age oEq DET
SELECT COUNT(*) FROM test_HOM WHERE age > 100;
-- update test_HOM age oOrder OPE
SELECT COUNT(*) FROM test_HOM WHERE age < 100;
SELECT COUNT(*) FROM test_HOM WHERE age <= 100;
SELECT COUNT(*) FROM test_HOM WHERE age >= 100;
SELECT COUNT(*) FROM test_HOM WHERE age = 100;
SELECT SUM(address) FROM test_HOM;
-- update test_HOM address oPLAIN PLAINVAL))
DROP TABLE test_HOM;

------------------------------
-- TEST SINGLE DELETE
------------------------------
CREATE TABLE test_delete (id integer, age integer, salary integer, address text, name text);
INSERT INTO test_delete VALUES (1, 10, 0, 'first star to the right and straight on till morning','Peter Pan');
INSERT INTO test_delete VALUES (2, 16, 1000, 'Green Gables', 'Anne Shirley');
INSERT INTO test_delete VALUES (3, 8, 0, 'London', 'Lucy');
INSERT INTO test_delete VALUES (4, 10, 0, 'London', 'Edmund');
INSERT INTO test_delete VALUES (5, 30, 100000, '221B Baker Street', 'Sherlock Holmes');
INSERT INTO test_delete VALUES (6, 21, 2000, 'Pemberly', 'Elizabeth');
INSERT INTO test_delete VALUES (7, 10000, 1, 'Mordor', 'Sauron');
INSERT INTO test_delete VALUES (8, 25, 100, 'The Heath', 'Eustacia Vye');
DELETE FROM test_delete WHERE id = 1;
 -- update test_delete id oEq DET))
SELECT * FROM test_delete;
DELETE FROM test_delete WHERE age = 30;
 -- update test_delete age oEq DET))
SELECT * FROM test_delete;
DELETE FROM test_delete WHERE name = 'Eustacia Vye';
 -- update test_delete name oEq DET))
SELECT * FROM test_delete;
DELETE FROM test_delete WHERE address = 'London';
 -- update test_delete address oEq DET))
SELECT * FROM test_delete;
DELETE FROM test_delete WHERE salary = 1;
 -- update test_delete salary oEq DET))
SELECT * FROM test_delete;
INSERT INTO test_delete VALUES (1, 10, 0, 'first star to the right and straight on till morning','Peter Pan');
SELECT * FROM test_delete;
DELETE FROM test_delete;
SELECT * FROM test_delete;
DROP TABLE test_delete;

------------------------------
-- TEST MUTIPLE DELETE
------------------------------
CREATE TABLE gasoline (x integer);
CREATE TABLE coal (y integer);
CREATE TABLE nuclear (z integer);
INSERT INTO gasoline VALUES (1), (100), (1000), (10000);
INSERT INTO coal VALUES (1), (101), (1001), (10000);
INSERT INTO nuclear VALUES (2), (200), (2000), (20000);
-- no aliases
DELETE gasoline, coal FROM gasoline INNER JOIN coal ON gasoline.x = coal.y;
-- update (gasoline (x (oEq DETJOIN))) (coal     (y (oEq DETJOIN)))))
SELECT * FROM gasoline, coal, nuclear;
-- alias
DELETE g, nuclear FROM gasoline g, nuclear;
SELECT * FROM gasoline, coal, nuclear;
-- repopulate with data
INSERT INTO gasoline VALUES (16), (116), (1016), (10016);
INSERT INTO coal VALUES (16), (116), (1016), (10016);
INSERT INTO nuclear VALUES (16), (216), (2016), (20016);
SELECT count(*) FROM gasoline, coal, nuclear;
-- alias with where clause
DELETE g, nuclear FROM gasoline g, nuclear WHERE nuclear.z < g.x;
-- (:update (gasoline (x (oPLAIN PLAINVAL))) (nuclear  (z (oPLAIN PLAINVAL)))))
SELECT * FROM gasoline, coal, nuclear;
-- alias with same name as table
DELETE coal, gasoline FROM coal coal, gasoline;
SELECT * FROM gasoline, coal, nuclear;
DROP TABLE gasoline;
DROP TABLE coal;
DROP TABLE nuclear;

------------------------------
-- TEST AUTO INCREMEMENT
------------------------------
CREATE TABLE msgs (msgid integer PRIMARY KEY AUTO_INCREMENT, zooanimals integer, msgtext text);
-- set (msgs (msgid (oPLAIN PLAINVAL)) (zooanimals (oEq RND) (oOrder RND) (oADD HOM)) (msgtext (oEq RND) (oOrder RND) (oADD HOM)))))
CREATE TABLE moremore (x INTEGER, y integer PRIMARY KEY AUTO_INCREMENT) AUTO_INCREMENT = 456;
-- (:set (moremore (x (oEq RND) (oOrder RND) (oADD HOM)) (y (oPLAIN PLAINVAL)))))
INSERT INTO msgs (msgtext, zooanimals) VALUES ('hello world', 100);
INSERT INTO msgs (msgtext, zooanimals) VALUES ('hello world2', 21);
INSERT INTO msgs (msgtext, zooanimals) VALUES ('hello world3', 10909);
INSERT INTO moremore (x) VALUES (1), (2), (3), (4);
SELECT msgtext FROM msgs WHERE msgid=1;
SELECT msgtext FROM msgs WHERE msgid=2;
SELECT msgtext FROM msgs WHERE msgid=3;
INSERT INTO msgs VALUES (3, 2012, 'sandman') ON DUPLICATE KEY UPDATE zooanimals = VALUES(zooanimals), zooanimals = 22;
SELECT * FROM msgs;
SELECT SUM(zooanimals) FROM msgs;
INSERT INTO msgs VALUES (3, 777, 'golfpants') ON DUPLICATE KEY UPDATE zooanimals = 16, zooanimals = VALUES(zooanimals);
SELECT * FROM msgs;
SELECT SUM(zooanimals) FROM msgs;
INSERT INTO msgs VALUES (9, 105, 'message for alice from bob');
INSERT INTO msgs VALUES (9, 201, 'whatever') ON DUPLICATE KEY UPDATE msgid = msgid + 10;
SELECT * FROM msgs;
INSERT INTO msgs VALUES (1, 9001, 'lights are on') ON DUPLICATE KEY UPDATE msgid = zooanimals + 99, zooanimals = VALUES(zooanimals);
-- (:update "msgs" "zooanimals" "oPLAIN" "PLAINVAL;)
SELECT * FROM msgs;
INSERT INTO msgs VALUES (2, 1998, 'stacksondeck') ON DUPLICATE KEY UPDATE zooanimals = VALUES(zooanimals), msgtext = VALUES(msgtext);
SELECT * FROM msgs;
SELECT SUM(zooanimals) FROM msgs;
-- FAIL: not supported
ALTER TABLE msgs AUTO_INCREMENT = 555;
INSERT INTO msgs (msgtext, zooanimals) VALUES ('dolphins', 12);
-- FAIL: auto_increment
SELECT * FROM msgs;
INSERT INTO msgs (msgtext, zooanimals) VALUES ('sharks', 12);
-- FAIL: auto_increment
SELECT * FROM msgs;
SELECT * FROM moremore;
DROP TABLE msgs;
DROP TABLE moremore;

------------------------------
-- TEST NEGATIVES
------------------------------
CREATE TABLE negs (a integer, b integer, c integer);
INSERT INTO negs (a, b, c) VALUES (10, -20, -100);
INSERT INTO negs (a, b, c) VALUES (-100, 50, -12);
INSERT INTO negs (a, b, c) VALUES (-8, -50, -18);
SELECT a FROM negs WHERE b = -50 OR b = 50;
SELECT a FROM negs WHERE c = -100 OR b = -20;
INSERT INTO negs (c) VALUES (-1009);
INSERT INTO negs (c) VALUES (1009);
SELECT * FROM negs WHERE c = -1009;
DROP TABLE negs;

------------------------------
-- TEST NULL
------------------------------

CREATE TABLE test_null (uid integer, age integer, address text);
CREATE TABLE u_null (uid integer, username text);
INSERT INTO u_null VALUES (1, 'alice');
INSERT INTO u_null VALUES (), ();
INSERT INTO u_null VALUES (2, 'somewhere'), (3, 'cookies');
INSERT INTO test_null (uid, age) VALUES (1, 20);
SELECT * FROM test_null;
INSERT INTO test_null (uid, address) VALUES (1, 'somewhere over the rainbow');
INSERT INTO test_null () VALUES (), ();
INSERT INTO test_null VALUES (), ();
INSERT INTO test_null (address, age) VALUES ('cookies', 1);
INSERT INTO test_null (age, address) VALUES (1, 'two');
INSERT INTO test_null (address, uid) VALUES ('three', 4);
SELECT * FROM test_null;
INSERT INTO test_null (uid, age) VALUES (1, NULL);
SELECT * FROM test_null;
INSERT INTO test_null (uid, address) VALUES (1, NULL);
SELECT * FROM test_null;
INSERT INTO test_null VALUES (1, 25, 'Australia');
SELECT * FROM test_null;
SELECT * FROM test_null WHERE uid = 1;
-- update test_null uid oEq DET))
SELECT * FROM test_null WHERE age < 50;
-- update test_null age oOrder OPE))
SELECT SUM(uid) FROM test_null;
SELECT MAX(uid) FROM test_null;
-- update test_null uid oOrder OPE
SELECT * FROM test_null;
SELECT * FROM test_null WHERE address = 'cookies';
-- update test_null address oEq DET))
SELECT * FROM test_null WHERE address < 'amber';
-- update test_null address oOrder OPE))
SELECT * FROM test_null WHERE address LIKE 'aaron';
-- (:update test_null address oPLAIN PLAINVAL))
SELECT * FROM test_null LEFT JOIN u_null ON test_null.uid = u_null.uid;
-- update (test_null (uid (oEq DETJOIN))) (u_null (uid (oEq DETJOIN)))))
SELECT * FROM test_null, u_null;
SELECT * FROM test_null RIGHT JOIN u_null ON test_null.uid = u_null.uid;
SELECT * FROM test_null, u_null;
SELECT * FROM test_null RIGHT JOIN u_null ON test_null.address = u_null.username;
-- update (test_null (address (oEq DETJOIN))) (u_null (username (oEq DETJOIN)))))
SELECT * FROM test_null, u_null;
SELECT * FROM test_null LEFT JOIN u_null ON u_null.username = test_null.address;
SELECT * FROM test_null, u_null;
DROP TABLE test_null;
DROP TABLE u_null;

------------------------------
-- TEST BEST EFFORT
------------------------------
CREATE TABLE t (x integer, y integer);
INSERT INTO t VALUES (1, 100);
INSERT INTO t VALUES (22, 413);
INSERT INTO t VALUES (1001, 15);
INSERT INTO t VALUES (19, 18);
SELECT * FROM t;
SELECT x * x FROM t;
-- update "t" x oPLAIN PLAINVAL))
SELECT x * y FROM t;
-- update "t" y oPLAIN PLAINVAL))
SELECT 2 + 2 FROM t;
SELECT x + 2 + x FROM t;
SELECT 2 + x + 2 FROM t;
SELECT x + y + 3 + 4 FROM t;
SELECT 2 * x * 2 * y FROM t;
SELECT x, y FROM t WHERE x AND y;
-- update ("t" (x (oEq DET)) (y (oEq DET)))))
SELECT x, y FROM t WHERE x = 1 AND y < 200;
-- update ("t" (y (oOrder OPE)))))
SELECT x, y FROM t WHERE x AND y = 15;
-- update "t" y oEq DET))
SELECT 10, x + y FROM t WHERE x;
DROP TABLE t;

------------------------------
-- TEST DEFAULT VALUE
------------------------------
 ("DefaultValue" t
CREATE TABLE def_0 (x INTEGER NOT NULL DEFAULT 10, y VARCHAR(100) NOT NULL DEFAULT 'purpflowers', z INTEGER);
CREATE TABLE def_1 (a INTEGER NOT NULL DEFAULT '100', b INTEGER, c VARCHAR(100));
INSERT INTO def_0 VALUES (100, 'singsongs', 500), (220, 'heyfriend', 15);
INSERT INTO def_0 (z) VALUES (500), (220), (32);
INSERT INTO def_0 (z, x) VALUES (500, '500');
INSERT INTO def_0 (z) VALUES (100);
INSERT INTO def_1 VALUES (250, 10000, 'smile!');
INSERT INTO def_1 (a, b, c) VALUES (250, 100, '!');
INSERT INTO def_1 (b, c) VALUES (250, 'smile!'), (99, 'happybday!');
SELECT * FROM def_0, def_1;
SELECT * FROM def_0 WHERE x = 10;
 -- update def_0 x oEq DET))
INSERT INTO def_0 (z) VALUES (500), (12), (19);
SELECT * FROM def_0 WHERE x = 10;
SELECT * FROM def_0 WHERE y = 'purpflowers';
 -- update def_0 y oEq DET))
INSERT INTO def_0 (z) VALUES (450), (200), (300);
SELECT * FROM def_0 WHERE y = 'purpflowers';
SELECT * FROM def_0, def_1;

DROP TABLE def_0;
DROP TABLE def_1;

------------------------------
-- TEST DECIMAL
------------------------------
CREATE TABLE dec_0 (x DECIMAL(10, 5), y DECIMAL(10, 5) NOT NULL DEFAULT 12.125);
CREATE TABLE dec_1 (a INTEGER, b DECIMAL(4, 2));
INSERT INTO dec_0 VALUES (50, 100.5);
INSERT INTO dec_0 VALUES (20.50, 1000.5);
INSERT INTO dec_0 VALUES (50, 100.59);
INSERT INTO dec_0 (x) VALUES (1.1);
INSERT INTO dec_1 VALUES (8, 1000.5);
SELECT * FROM dec_0 WHERE x = 50;
SELECT * FROM dec_0 WHERE x < 50;
SELECT * FROM dec_0 WHERE y = 100.5;
SELECT * FROM dec_0;
INSERT INTO dec_0 VALUES (19, 100.5);
SELECT * FROM dec_0 WHERE y = 100.5;
SELECT * FROM dec_1;
SELECT * FROM dec_0, dec_1 WHERE dec_0.y = dec_1.b;
DROP TABLE dec_0;
DROP TABLE dec_1;

------------------------------
-- TEST NON STRICT MODE
------------------------------
CREATE TABLE not_strict (x INTEGER NOT NULL, y INTEGER NOT NULL DEFAULT 100, z VARCHAR(100) NOT NULL);
INSERT INTO not_strict VALUES (150, 230, 'flowers');
INSERT INTO not_strict VALUES (850, 930, 'rainbow');
INSERT INTO not_strict (y) VALUES (11930);
SELECT * FROM not_strict WHERE x = 0;
 -- update not_strict x oEq DET))
SELECT * FROM not_strict WHERE z = '';
 -- update not_strict z oEq DET))
INSERT INTO not_strict (y) VALUES (1212);
SELECT * FROM not_strict WHERE x = 0;
SELECT * FROM not_strict WHERE z = '';
INSERT INTO not_strict (x) VALUES (0);
INSERT INTO not_strict (x, z) VALUES (12001, 'sun');
INSERT INTO not_strict (z) VALUES ('curtlanguage');
SELECT * FROM not_strict WHERE x = 0;
SELECT * FROM not_strict WHERE z = '';
SELECT * FROM not_strict WHERE x < 110;
 -- update not_strict x oOrder OPE))
SELECT * FROM not_strict;
DROP TABLE not_strict;

------------------------------
-- TEST TRANSACTIONS
------------------------------
CREATE TABLE trans (a integer, b integer, c integer);
INSERT INTO trans VALUES (1, 2, 3);
INSERT INTO trans VALUES (33, 22, 11);
SELECT * FROM trans;

START TRANSACTION;
INSERT INTO trans VALUES (333, 222, 111);
ROLLBACK;
SELECT * FROM trans;
INSERT INTO trans VALUES (45, 22, 15);
UPDATE trans SET a = a + 1, b = c + 1;

-- special update in transaction
START TRANSACTION;
UPDATE trans SET a = a + a, b = b + 12;
SELECT * FROM trans;
ROLLBACK;
SELECT * FROM trans;

-- special update in transaction
START TRANSACTION;
UPDATE trans SET a = c + 1, b = a + 1;
COMMIT;
SELECT * FROM trans;
ROLLBACK;
SELECT * FROM trans;

START TRANSACTION;
-- query should fail as it's onion adjustment inside a transaction
UPDATE trans SET a = a + 1, c = 50 WHERE a < 50000;
-- update trans a oOrder OPE) :cryptdb :must-fail)
-- freeze things in case something went wrong
COMMIT;
SELECT * FROM trans;

START TRANSACTION;
INSERT INTO trans VALUES (1, 50, 150);
-- query should fail as it's onion adjustment inside a transaction
UPDATE trans SET b = b + 10 WHERE c = 50;
-- update trans c oEq DET) :cryptdb:must-fail)
ROLLBACK;
-- freeze things in case something went wrong
COMMIT;
SELECT * FROM trans;
DROP TABLE trans;

------------------------------
-- TEST TABLE ALIASES
------------------------------
CREATE TABLE star (a integer, b integer, c integer);
CREATE TABLE mercury (a integer, b integer, c integer);
CREATE TABLE moon (x integer, y integer, z integer);
INSERT INTO star VALUES (55, 66, 77), (99, 22, 109);
INSERT INTO mercury VALUES (55, 18, 17), (16, 15, 14);
INSERT INTO moon VALUES (55, 18, 1), (22, 22, 444);
SELECT s.a, e.b FROM star AS s INNER JOIN mercury AS e ON s.a = e.a WHERE s.c < 100;
-- update (star (a (oEq DETJOIN)) (c (oOrder OPE))) (mercury (a (oEq DETJOIN)))))
SELECT * FROM mercury INNER JOIN mercury AS e ON mercury.a = e.a;
SELECT o.x, o.y FROM moon AS o INNER JOIN moon AS o2 ON o.x = o2.y;
-- update (moon (x (oEq DETJOIN)) (y (oEq DETJOIN)))))
SELECT mercury.a, mercury.b, e.a FROM star AS mercury INNER JOIN mercury AS e ON (mercury.a = e.a) WHERE mercury.b <> 18 AND mercury.b <> 15;
-- update star b oEq DET))
-- throws an exception
SELECT * FROM star AS q WHERE a IN (SELECT a FROM mercury);
SELECT * FROM star, mercury, moon;
DROP TABLE star;
DROP TABLE mercury;
DROP TABLE moon;

------------------------------
-- TEST DDL
------------------------------
-- FIXME: onion checking doesn't play nice with adding/dropping columns
CREATE TABLE ddl_test (a integer, b integer, c integer);
INSERT INTO ddl_test VALUES (1, 2, 3);
SELECT * FROM ddl_test;
ALTER TABLE ddl_test DROP COLUMN a;
SELECT * FROM ddl_test;
ALTER TABLE ddl_test ADD COLUMN a integer;
SELECT * FROM ddl_test;
INSERT INTO ddl_test VALUES (3, 4, 5), (5, 6, 7),(7, 8, 9);
SELECT * FROM ddl_test;
ALTER TABLE ddl_test DROP COLUMN b, DROP COLUMN c;
SELECT * FROM ddl_test;
ALTER TABLE ddl_test ADD COLUMN b integer, DROP COLUMN a, ADD COLUMN c integer;
INSERT INTO ddl_test VALUES (15, '1212'), (20, '7676');
SELECT * FROM ddl_test;
DELETE FROM ddl_test;
INSERT INTO ddl_test VALUES (12, 15), (44, 14), (19, 5);
ALTER TABLE ddl_test ADD PRIMARY KEY(b);
SELECT * FROM ddl_test;
ALTER TABLE ddl_test DROP PRIMARY KEY, ADD PRIMARY KEY(b);
SELECT * FROM ddl_test;
ALTER TABLE ddl_test ADD INDEX j(b), ADD INDEX k(b, c);
SELECT * FROM ddl_test;
ALTER TABLE ddl_test DROP INDEX j, DROP INDEX k, ADD INDEX j(b), ADD INDEX k(b, c);
SELECT * FROM ddl_test;
CREATE INDEX i ON ddl_test (b, c);
ALTER TABLE ddl_test DROP INDEX i, ADD INDEX i(b);
ALTER TABLE ddl_test DROP INDEX i;
DROP TABLE ddl_test;
--- the oEq column will encrypt three times and all three of these will pad;
--- the mysql's maximum field size is 2**32 - 1; so the maximum field size
--- we support is 2**32 - 1 - (3 * AES_BLOCK_BYTES)

------------------------------
-- TEST MISCELLANEOUS BUGS
------------------------------
-- FIXME: support for non maxed columns
-- FIXME: floating point comparisons
CREATE TABLE crawlies (purple VARCHAR(4294967247), pink VARCHAR(0));
CREATE TABLE enums (x enum('this', 'that'));
CREATE TABLE bugs (spider TEXT);
CREATE TABLE more_bugs (ant INTEGER);
CREATE TABLE real_type_bug (a real, b real unsigned, c real unsigned not null);
INSERT INTO bugs VALUES ('8legs'), ('crawly'), ('manyiz');
INSERT INTO more_bugs VALUES (9012), (2913), (19114);
INSERT INTO enums VALUES ('this'), ('that');
SELECT * FROM enums;
SELECT spider + spider FROM bugs;
SELECT spider + spider FROM bugs;
SELECT SUM(spider) FROM bugs;
CREATE TABLE crawlers (pink DATE);
INSERT INTO crawlers VALUES ('0'), (0), ('2015-05-04 4:5:6');
SELECT * FROM crawlers;
INSERT INTO crawlers VALUES ('2415-05-04 4:5:6'), ('1998-500-04 4:5:6');
SELECT * FROM crawlers;
INSERT INTO crawlers VALUES ('100000-05-04 4:5:6'), ('1998-5-04 a:b:c'), ('1000-05-04 house'), ('1998-4-04 2015');
SELECT * FROM crawlers;
SELECT * FROM bugs, more_bugs, crawlers, crawlies;
INSERT INTO real_type_bug VALUES (1, 2, 3);
SELECT * FROM real_type_bug;
UPDATE real_type_bug SET a = a + 1, b = b + 1;
SHOW ENGINES;

-- SQL_SAFE_UPDATES will make us segfault
SET SQL_SAFE_UPDATES = 1;
-- :cryptdb :must-fail)

-- FAIL: we don't currently support; but it shouldn't crash the system
CREATE TABLE jjjSELECT * FROM enums;
DROP TABLE IF EXISTS jjj;

CREATE TABLE floating (x float);
INSERT INTO floating VALUES (23e+12), (12e+14), ('a'), (12), ('12e+5');
SELECT * FROM floating WHERE x < 11e+14;
-- FAIL: floating point comparison broke
SELECT * FROM floating;
DROP TABLE floating;

-- SpecialUpdate must correctly handle escaped chars
CREATE TABLE su (x integer, y text);
INSERT INTO su VALUES (1, 'some\'text');
UPDATE su SET x = x + 1;
SELECT * FROM su;
DROP TABLE su;

DROP TABLE crawlies;
DROP TABLE enums;
DROP TABLE bugs;
DROP TABLE more_bugs;
DROP TABLE real_type_bug;
DROP TABLE crawlers;

------------------------------
-- TEST MISCELLANEOUS BUGS 2
------------------------------
CREATE TABLE t (x integer);
INSERT INTO t values (1), (10), (100), (1000);
SELECT * FROM t;
-- with column: constant first
SELECT SUM(GREATEST(50, x)) FROM t;
-- update "t" x oOrder OPE))
-- with column: column first
SELECT SUM(GREATEST(x, 101)) FROM t;
-- constants: small first
SELECT SUM(GREATEST(50, 55)) FROM t;
-- constants: big first
SELECT SUM(GREATEST(55, 40)) FROM t;
-- with column: constant first
SELECT SUM(LEAST(50, x)) FROM t;
--  with column: column first
SELECT SUM(LEAST(x, 101)) FROM t;
--  constants: small first
SELECT SUM(LEAST(505, 3000)) FROM t;
--  constants: big first
SELECT SUM(LEAST(1000, 4)) FROM t;

--  with column: constant first
SELECT GREATEST(50, x) FROM t;
-- update "t" x oEq DET))
--  with column: column first
SELECT GREATEST(x, 101) FROM t;
--  constants: small first
SELECT GREATEST(50, 55) FROM t;
--  constants: big first
SELECT GREATEST(55, 40) FROM t;

--  with column: constant first
SELECT LEAST(50, x) FROM t;
--  with column: column first
SELECT LEAST(x, 101) FROM t;
--  constants: small first
SELECT LEAST(505, 3000) FROM t;
--  constants: big first
SELECT LEAST(1000, 4) FROM t;

SELECT * FROM t;

DROP TABLE t;

------------------------------
-- TEST MISCELLANEOUS BUGS 3
------------------------------
CREATE TABLE gutter (x integer, y integer);
INSERT INTO gutter VALUES (1, 2), (20, 21), (500, NULL), (NULL, 1);
SELECT * FROM gutter;
--  one column
SELECT 5 + 4 + x from gutter;
SELECT x + 4 + 5 from gutter;
SELECT 1 + x + 5 from gutter;
--  two (of the same) column
SELECT 1 + x + x from gutter;
SELECT x + 2 + x from gutter;
SELECT x + x + 3 from gutter;
--  three column
SELECT x + x + x from gutter;
--  goto plain
SELECT x + y from gutter;
-- update (gutter (x (oPlain PLAINVAL)) (y (oPlain PLAINVAL)))))

SELECT 1 + x + y FROM gutter;
SELECT x + 4 + y FROM gutter;
SELECT x + y + 6 FROM gutter;

SELECT * FROM gutter;

DROP TABLE gutter;

------------------------------
-- TEST ONLY SUPPORT INNODB TABLES
------------------------------
-- fIXME: do we want to test 'storage_engine' variable
CREATE TABLE u (x integer) Engine=CSV;
--   () :cryptdb :must-fail)
CREATE TABLE uu (x integer) Engine=MyISAM;
--  () :cryptdb :must-fail)
CREATE TABLE uuu (x integer) Engine=InnoDB;
CREATE TABLE uuuu (x integer);

DROP TABLE uuu;
DROP TABLE uuuu;

------------------------------
-- TEST SHOW TABLES
------------------------------
CREATE TABLE cside (x integer);
SHOW TABLES;
-- () :both :ignore-fields)
CREATE TABLE bside (y integer);
SHOW TABLES;
-- () :both :ignore-fields)
DROP TABLE cside;
SHOW TABLES;
-- () :both :ignore-fields)
DROP TABLE bside;
SHOW TABLES;
-- () :both :ignore-fields)
CREATE TABLE eside (z integer);
SHOW TABLES;
-- () :both :ignore-fields)
DROP TABLE eside;
SHOW TABLES;
-- :check :both :ignore-fields))

------------------------------
-- TEST QUOTED SCHEMA OBJECTS
------------------------------
DROP DATABASE IF EXISTS `over+there`;
CREATE DATABASE IF NOT EXISTS `over+there`;
USE `over+there`;
CREATE TABLE `over+there`.`more+quotes` (`quoted-+as*well` integer);
-- :cryptdb:must-succeed)
CREATE TABLE `more+quotes` (`quoted-+as*well` integer);
CREATE TABLE `hard-+=quotes` (`!@abc` text, `$$eda` integer);
INSERT INTO `hard-+=quotes` VALUES (1, 'quoting'), (12, 'shouldn;tbe'), (100, 'hard');
SELECT * FROM `hard-+=quotes`;
SELECT * FROM `hard-+=quotes` WHERE `!@abc` < 1200;
-- update "over+there" "hard-+=quotes" "!@abc" oOrder OPE))
SELECT * FROM `hard-+=quotes`;
SELECT * FROM `more+quotes`;
SELECT * FROM `over+there`.`more+quotes`;
-- check:cryptdb:must-succeed)
DROP DATABASE IF EXISTS `over+there`;
DROP TABLE `more+quotes`;
-- ():control:ignore)
USE cryptdbtest;
-- ():cryptdb:ignore))

------------------------------
--  TEST DIRECTIVES
------------------------------
-- NOTE: Difficult to test functionality because we use this technique to get onion level
CREATE TABLE directives (x integer, y text, z integer);
INSERT INTO directives VALUES (1, 'school learnin`', 7), (2, 'book learnin`', 8), (3, 'skool', 9);
SELECT * FROM directives;
--  try to do non-existent directive
SET @cryptdb='wontwork', @other='that';
-- ():cryptdb:must-fail)
--  try to do multiple directives
SET @cryptdb='adjust', @cryptdb='adjust', @and='that';
-- ():cryptdb:must-fail)
--  specity duplicate directive parameters for one directive
SET @cryptdb='adjust', @database='cryptdbtest', @table='directives', @field='x', @oOrder='OPE', @field='z';
-- ():cryptdb:must-fail)
--  try to adjust on a non existent database
SET @cryptdb='adjust', @database='notreal', @field='wontmatter', @table='irrelevant', @oHOM='OPE';
-- ():cryptdb:must-fail)
SELECT * FROM directives;
--  try to adjust a non existent table
SET @cryptdb='adjust', @table='notrealnotreal', @database='cryptdbtest', @field='doesntmatter', @oOrder='OPE';
-- ():cryptdb:must-fail)
SELECT * FROM directives;
--  try to adjust a non existent field
SET @cryptdb='adjust', @database='cryptdbtest', @oOrder='OPE', @table='directives', @field='made-up';
-- ():cryptdb:must-fail)
SELECT * FROM directives;
--  try to adjust a non existent onion
SET @field='x', @cryptdb='adjust', @database='cryptdbtest', @table='directives', @badbad='OPE';
-- ():cryptdb:must-fail)
SELECT * FROM directives;
--  try to adjust to non existent level
SET @database='cryptdbtest' @table='directives', @field='x', @oOrder='unreality', @cryptdb='adjust';
-- ():cryptdb:must-fail)
SELECT * FROM directives;
--  try to adjust onion to real level it doesnt support
--  > FIXME: handling of this is not nice
SET @cryptdb='adjust', @database='cryptdbtest', @table='directives', @field='x', @oOrder='HOM';
-- ():cryptdb:must-fail)
SELECT * FROM directives;
--  do real adjustment
SET @table='directives', @database='cryptdbtest', @cryptdb='adjust', @field='x', @oOrder='OPE';
SELECT * FROM directives WHERE x < 100;
--  do it again (adjust to current level)
SET @cryptdb='adjust', @database='cryptdbtest', @table='directives', @field='x', @oOrder='OPE';
SELECT * FROM directives WHERE x < 100;
SET @cryptdb='show', @random='stuff', @nothing='nothing';
-- ():cryptdb:must-succeed)
--  try to adjust upwards
SET @cryptdb='adjust', @database='cryptdbtest', @table='directives', @field='x', @oOrder='RND';
-- ():cryptdb:must-fail)
SELECT * FROM directives WHERE x < 100;
--  do multiple adjustments to same onion
--  NOTE: unsupported
SET @cryptdb='adjust', @database='cryptdbtest', @oEq='DETJOIN', @table='directives', @field='x', @oEq='DET';
-- () :cryptdb :must-fail)
SELECT * FROM directives;
--  adjust down multiple layers
SET @cryptdb='adjust', @database='cryptdbtest', @oEq='DETJOIN', @table='directives', @field='x';
SELECT * FROM directives WHERE x = 1;
--  multiple adjustments to different onions
SET @cryptdb='adjust', @database='cryptdbtest', @table='directives', @field='y', @oEq='DET', @oOrder='OPE';
SELECT * FROM directives WHERE y < 'somerandomtext';
SELECT * FROM directives WHERE y = 'moretext';
--  do a good adjustment and one that won't do anything
SET @cryptdb='adjust', @database='cryptdbtest', @table='directives', @field='z', @oEq='DET', @oOrder='RND';
SELECT * FROM directives WHERE z = 8;
SET @more='less', @cryptdb='show', @nothing='short';
-- () :cryptdb :must-succeed)
DROP TABLE directives;

------------------------------
-- TEST SENSITIVE DIRECTIVES
------------------------------
CREATE TABLE sense (x integer, y integer);
INSERT INTO sense VALUES (100, 'crayolacrayons'), (1212, 'jjjjjjj');
SELECT * FROM sense;
--  try multiple sensitives
SET @cryptdb='sensitive', @cryptdb='sensitive', @database='cryptdbtest', @table='sense', @field='x', @oOrder='OPE';
-- () :cryptdb :must-fail)
--  prevent the field from adjusting down oORDER
SET @cryptdb='sensitive', @database='cryptdbtest', @table='sense', @field='x', @oOrder='RND';
--  attempt adjustment
SELECT * FROM sense WHERE x < 100;
-- () :cryptdb :must-fail)
--  let the adjustment happen
SET @cryptdb='sensitive', @database='cryptdbtest', @table='sense', @field='x', @oOrder='OPE';
--  attempt adjustment
SELECT * FROM sense WHERE x < 100;
-- update sense x oOrder OPE))
--  make two onions unadjustable
SET @cryptdb='sensitive', @database='cryptdbtest', @table='sense', @field='y', @oOrder='RND', @oEq='RND';
SELECT * FROM sense WHERE y = 20;
-- ():cryptdb:must-fail)
SELECT * FROM sense WHERE y > 560;
-- ():cryptdb:must-fail)
--  do an invalid sensitize
SET @cryptdb='sensitive', @database='cryptdbtest', @table='sense', @field='x', @oOrder='notreal';
--():cryptdb:must-fail)
--  make three onions adjustable
SET @cryptdb='sensitive', @database='cryptdbtest', @table='sense', @field='y', @oOrder='OPE', @oEq='DET', @oAdd='HOM';
SELECT SUM(y) FROM sense;
SELECT * FROM sense WHERE y < 200;
-- update sense y oOrder OPE))
SELECT * FROM sense WHERE y = 100;
-- update sense y oEq DET))
--  try to sensitize upwards
SET @cryptdb='sensitive', @database='cryptdbtest', @table='sense', @field='y', @oOrder='RND';
-- ():cryptdb:must-fail)
--  sensitize to current level
SET @cryptdb='sensitive', @database='cryptdbtest', @table='sense', @field='y', @oOrder='OPE';
SELECT * FROM sense;
DROP TABLE sense;

------------------------------
-- TEST RANGE
------------------------------
-- FIXME: larget 64 bit value being misrepresented as -1, possibly a bug in sql library
-- we must run the control database in strict mode in order to match semantics
SET SESSION sql_mode = 'ANSI,TRADITIONAL';
-- () :control :ignore)
CREATE TABLE t (t TINYINT UNSIGNED DEFAULT 0, s SMALLINT UNSIGNED DEFAULT 0, m MEDIUMINT UNSIGNED DEFAULT 0, i INT UNSIGNED DEFAULT 0, b BIGINT UNSIGNED DEFAULT 0);
--  lets take a look at the largest value
INSERT INTO t (b) VALUES (18446744073709551615);
--  lets also force the UDF to handle some other values
INSERT INTO t (b) VALUES (18446), (1001), (2), (2000009);
SELECT * FROM t;
--  Query("SELECT SUM(b) FROM t;
SELECT * FROM t WHERE b > 18446744073709551614 AND b <= 18446744073709551615;
SELECT MAX(b) FROM t;
--  look at the largest value without server side decryption
INSERT INTO t (b) VALUES (18446744073709551615);
SELECT * FROM t WHERE b > 18446744073709551614 AND b <= 18446744073709551615;
SELECT MAX(b) FROM t;
--  unsigned minimum
INSERT INTO t VALUES (0, 0, 0, 0, 0);
SELECT * FROM t;
--  largest single value that will fit in each row
INSERT INTO t VALUES (255, 255, 255, 255, 255);
SELECT * FROM t;
--  largest value each field will support
INSERT INTO t VALUES (255, 65535, 16777215, 4294967295, 4294967295);
--  are leading zeros playing nice?
SELECT * FROM t ORDER BY b;
SELECT MIN(b) FROM t;
--  should fail on both because 5000 can't go in tiny
INSERT INTO t VALUES (5000, 5000, 5000, 5000, 5000);
SELECT * FROM t;
SELECT SUM(t), SUM(s), SUM(m), SUM(i) FROM t;
--  one more than maximum, should fail on both
INSERT INTO t (t) VALUES (256);
INSERT INTO t (s) VALUES (65536);
INSERT INTO t (m) VALUES (16777217);
INSERT INTO t (i) VALUES (4294967296);
SELECT * FROM t;
SELECT SUM(t), SUM(s), SUM(m), SUM(i) FROM t;
--  FIXME: will fail on cryptdb and succeed on the control database
INSERT INTO t (b) VALUES (4294967296);
SELECT * FROM t;
--  should fail on both
UPDATE t SET t = t + 5;
UPDATE t SET s = s + 5;
UPDATE t SET m = m + 5;
UPDATE t SET i = i + 5;
SELECT MAX(t), MAX(s), MAX(m), MAX(i), MAX(b) FROM t;
SELECT MIN(t), MIN(s), MIN(m), MIN(i), MIN(b) FROM t;
SELECT SUM(t), SUM(s), SUM(m), SUM(i) FROM t;
--  will fail on cryptdb and succeed on control database
UPDATE t SET b = b + 5;
SELECT SUM(b) FROM t;
SELECT * FROM t;
--  conditional selections
SELECT t, s FROM t WHERE t >= 255 AND s < 65535;
SELECT m, i FROM t WHERE m < 1677215;
SELECT m, i FROM t WHERE m > 1677215;
SELECT t, s, i FROM t WHERE i = 16777215;
SELECT * from t;
SELECT MAX(t), MAX(s), MAX(m), MAX(i), MAX(b) FROM t;
--  the comparisons fail because the constants are out of range
SELECT m, t, s FROM t WHERE s = 65536;
SELECT m, i FROM t WHERE m > 4294967290;
SELECT i FROM t WHERE i > 99999999999999999999;
SELECT t, i FROM t WHERE t < 99999999999999999999;
SELECT t, s, m, i FROM t;
SELECT t, s, m FROM t WHERE s = m AND b = i;
--  FAIL: we don't handle summations larger than 64 bits
SELECT SUM(b) FROM t;
DROP TABLE t;
SET SESSION sql_mode = '';
--  () :control :ignore))

------------------------------
 -- TEST UPDATE BUGS
------------------------------
-- > we were issuing the DELETE but failing to ROLLBACK when our INSERT failed
--   + the failure occurs becase the update causes duplicate entries on a 
--     PRIMARY KEY
-- SCENARIO 1: onion adjustment during UPDATE
CREATE TABLE ubug (x integer primary key);
--  (:set (ubug (x (oEq DET)              (oOrder RND)              (oAdd HOM)))))
INSERT INTO ubug VALUES (1), (2);
-- this must happen _before_ onion adjustment
UPDATE ubug SET x = x + 1 WHERE x < 2;
--  (:update ubug x oOrder OPE)
--  :both
--  :must-fail)
SELECT * FROM ubug;
-- was causing deadlock
UPDATE ubug SET x = 15;
DROP TABLE ubug;

-- SCENARIO 2: onion adjustment before UPDATE
CREATE TABLE ubug2 (x integer primary key);
--  (:set (ubug2 (x (oEq DET)               (oOrder RND)               (oAdd HOM)))))
SET @cryptdb='sensitive', @database='cryptdbtest', @table='ubug2', @field='x', @oOrder='OPE';
INSERT INTO ubug2 VALUES (1), (2);
-- onion adjust before we do the bad update
SELECT * FROM ubug2 WHERE x < 2;
--  (:update ubug2 x oOrder OPE))
UPDATE ubug2 SET x = x + 1 WHERE x < 2;
--  ()
--  :both
--  :must-fail)
-- '1' was missing from database
SELECT * FROM ubug2;
DROP TABLE ubug2;

-- SCENARIO 1 WITH TRANSACTION can't happen because onion adjustments can't
-- happen in a transaction

-- SCENARIO 2 WITH TRANSACTION
CREATE TABLE ubug_trx (x integer primary key);
-- (:set (ubug_trx (x (oEq DET)                   (oOrder RND)                   (oAdd HOM)))))
SET @cryptdb='sensitive', @database='cryptdbtest', @table='ubug_trx', @field='x', @oOrder='OPE';
SELECT * FROM ubug_trx WHERE x < 2;
--  (:update ubug_trx x oOrder OPE))
INSERT INTO ubug_trx VALUES (0);
START TRANSACTION;
INSERT INTO ubug_trx VALUES (1), (2);
-- we can not issue special updates inside of a transaction
-- > transaction should remain open
UPDATE ubug_trx SET x = x + 1 WHERE x < 2;
--  ()
--  :cryptdb
--  :must-fail)
SELECT * FROM ubug_trx;
-- make sure the transaction is still active
INSERT INTO ubug_trx VALUES (3);
SELECT * FROM ubug_trx;
ROLLBACK;
SELECT * FROM ubug_trx;
DROP TABLE ubug_trx;

-- SpecialUpdate has a special code path for an update that will affect
-- zero columns
CREATE TABLE ubug_none (x integer);
INSERT INTO ubug_none VALUES (1), (2);
SELECT * FROM ubug_none;
-- take the special path from within an onion adjustment
UPDATE ubug_none SET x = x + 10 WHERE x < 10;
--  (:update ubug_none x oOrder OPE))
SELECT * FROM ubug_none;
UPDATE ubug_none SET x = x + 10;
SELECT * FROM ubug_none;
DROP TABLE ubug_none;
