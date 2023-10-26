-- Создание таблицы KNI_t
CREATE TABLE KNI_t (
    x NUMBER(3) PRIMARY KEY,
    s VARCHAR(50)
);

-- Вставка данных в таблицу KNI_t
INSERT INTO KNI_t VALUES (1, 'First');
INSERT INTO KNI_t VALUES (2, 'Second');
INSERT INTO KNI_t VALUES (3, 'Third');

-- Выбор всех записей из таблицы KNI_t
SELECT * FROM KNI_t;

-- Обновление записей в таблице KNI_t
UPDATE KNI_t SET s = 'Updated' WHERE x < 3;

-- Повторный выбор всех записей из таблицы KNI_t
SELECT * FROM KNI_t;

-- Выбор максимального значения x из таблицы KNI_t
SELECT x, s
FROM KNI_t
WHERE x = (SELECT MAX(x) FROM KNI_t);

-- Удаление записей из таблицы KNI_t
DELETE FROM KNI_t WHERE x > 2;


-- Выбор всех записей из таблицы KNI_t после удаления
SELECT * FROM KNI_t;

-- Создание таблицы KNI_t1
CREATE TABLE KNI_t1 (
    x_id NUMBER(3),
    s VARCHAR(50),
    FOREIGN KEY (x_id) REFERENCES KNI_t(x)
);

-- Вставка данных в таблицу KNI_t1
INSERT INTO KNI_t1 (x_id, s) VALUES (1, 'First_t1');
INSERT INTO KNI_t1 (x_id, s) VALUES (2, 'Second_t1');
INSERT INTO KNI_t1 (x_id, s) VALUES (3, 'Third_t1');

-- Левое соединение (LEFT JOIN) между таблицами KNI_t и KNI_t1
SELECT KNI_t.x, KNI_t.s, KNI_t1.s AS s_t1
FROM KNI_t
LEFT JOIN KNI_t1 ON KNI_t.x = KNI_t1.x_id;

-- Правое соединение (RIGHT JOIN) между таблицами KNI_t и KNI_t1
SELECT KNI_t.x, KNI_t.s, KNI_t1.s AS s_t1
FROM KNI_t
RIGHT JOIN KNI_t1 ON KNI_t.x = KNI_t1.x_id;

-- Внутреннее соединение (INNER JOIN) между таблицами KNI_t и KNI_t1
SELECT KNI_t.x, KNI_t.s, KNI_t1.s AS s_t1
FROM KNI_t
INNER JOIN KNI_t1 ON KNI_t.x = KNI_t1.x_id;

-- Удаление таблиц KNI_t1 и KNI_t
DROP TABLE KNI_t1;
DROP TABLE KNI_t;
