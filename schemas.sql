-- 1.1 Номенклатура
CREATE TABLE nomenclatures (
    id          SERIAL PRIMARY KEY,
    name        VARCHAR(300) NOT NULL,
    quantity    INTEGER      NOT NULL DEFAULT 0,
    price       DECIMAL(10,2) NOT NULL
)


-- 1.2 Каталог номенклатуры / Дерево категорий
CREATE TABLE categories (
    id        SERIAL PRIMARY KEY,
    name      VARCHAR(200) NOT NULL,
    parent_id INTEGER REFERENCES categories(id)
)


-- 1.3 Клиенты
CREATE TABLE clients (
    id      SERIAL PRIMARY KEY,
    name    VARCHAR(200) NOT NULL,
    address TEXT
)


-- 1.4 Заказы покупателей
CREATE TABLE orders (
    id        SERIAL PRIMARY KEY,
    client_id INTEGER NOT NULL REFERENCES clients(id)
)


-- возможность делать заказ из разного набора товаров.
CREATE TABLE order_items (
    id              SERIAL PRIMARY KEY,
    order_id        INTEGER NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    nomenclature_id INTEGER NOT NULL REFERENCES nomenclatures(id),
    quantity        INTEGER NOT NULL CHECK (quantity > 0),
    price           DECIMAL(10,2) NOT NULL,
    UNIQUE (order_id, nomenclature_id)
)


-- 2.1. Получение информации о сумме товаров заказанных под каждого клиента
SELECT
    c.name AS "Наименование клиента",
    SUM(oi.quantity * oi.price) AS "Сумма"
FROM
    clients c
LEFT JOIN
    orders o ON o.client_id = c.id
LEFT JOIN
    order_items oi ON oi.order_id = o.id
GROUP BY
    c.id
ORDER BY
    "Сумма" DESC


-- 2.2. Найти количество дочерних элементов первого уровня вложенности для категорий номенклатуры.
SELECT
    c.name AS "Категория 1 уровня",
    COUNT(*) AS "Количество прямых дочерних категорий"
FROM
    categories c
LEFT JOIN
    categories child ON child.parent_id = c.id
WHERE
    c.parent_id IS NULL
GROUP BY
    c.id, c.name
ORDER BY "Количество прямых дочерних категорий" DESC

-- 2.3, 2.3.1 не умею

