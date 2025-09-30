/*Хотим таблицу, которая будет показывать сводную информацию о "флагманах продаж" в дорогом сегменте.*/
SELECT
    m.model_id, m.name_of_model, m.color, m.cost_price, m.cost, 
    SUM(mar.quantity_of_orders) as quantity_of_orders_by_this_model,
    SUM(mar.quantity_of_clicks) as quantity_of_clicks_by_this_model,
    (SUM(mar.quantity_of_orders) * (m.cost - m.cost_price)) as total_profit_from_this_model
FROM bags.Marketing mar
JOIN bags.Models m on mar.model_id = m.model_id
WHERE m.cost >= 2000
GROUP BY m.model_id, m.name_of_model, m.color, m.cost_price, m.cost
HAVING SUM(mar.quantity_of_orders) > 15
ORDER BY total_profit_from_this_model DESC;


/*Хотим узнать информацию о службах доставки и их дополнительных услугах.*/
SELECT 
    d.delivery_id,
    d.name_of_company,
    f.name_of_feature,
    f.cost as feature_cost
FROM bags.Delivery d
JOIN bags.Delivery_company_features df ON d.delivery_id = df.delivery_id
JOIN bags.Features f ON df.feature_id = f.feature_id
ORDER BY d.name_of_company, f.cost;


/*Хотим вывести информацию о 3 самых дорогих сумках коричневого цвета.*/
SELECT
    model_id, name_of_model, color, cost_price, cost, comment
FROM bags.Models
WHERE color = 'brown'
ORDER BY cost DESC
LIMIT 3;


/*Хотим вывести информацию о всех коричневых сумках, не считая 3 самых дорогих.*/
SELECT
    model_id, name_of_model, color, cost_price, cost, comment
FROM bags.Models
WHERE color = 'brown' AND cost IS NOT NULL
ORDER BY cost DESC
OFFSET 3;


/*Хотим вывести информацию о всех моделях, стоимость которых больше, чем стоимость всех моделей Ottawa.*/
SELECT 
    m.model_id, m.name_of_model, m.color, m.cost_price, m.cost, m.comment
FROM bags.Models m
WHERE m.cost IS NOT NULL
AND m.cost > ALL (
    SELECT cost 
    FROM bags.Models 
    WHERE (name_of_model = 'Ottawa' OR name_of_model = 'Ottawa 2') AND cost IS NOT NULL
)
ORDER BY m.cost DESC;


/*Хотим вывести топ-3 самые дорогие сумки каждого из цветов.*/
SELECT
    model_id, name_of_model, color, cost
FROM (
    SELECT 
        model_id, name_of_model, color, cost,
            ROW_NUMBER() OVER (PORTITION BY color ORDER BY cost DESC) as model_rank
    FROM bags.Models
    WHERE cost IS NOT NULL
)
WHERE model_rank <= 3;


/*Хотим для каждой сумки понять, насколько она отличается от самой дорогой сумки в данном цвете. Потом немного структурируем и сортируем данные, чтобы с ними приятно было работать.*/
SELECT
    model_id, 
    name_of_model, 
    color, 
    cost,
    FIRST_VALUE(cost) OVER (PARTITION BY color ORDER BY cost DESC) as most_expensive_in_this_color,
    FIRST_VALUE(cost) OVER (PARTITION BY color ORDER BY cost DESC) - cost as difference_from_most_expensive
FROM bags.Models
WHERE cost IS NOT NULL
ORDER BY color, cost DESC;


/*Хотим выделить клиентов, которые сделали не 1 заказ, а хотя бы 2...*/
SELECT
    c.customer_id, c.first_name, c.second_name, c.city
FROM bags.Customers
WHERE EXISTS(
    SELECT 1
    FROM bags.Orders o
    WHERE o.customer_id = c.customer_id
    GROUP BY customer_id
    HAVING COUNT(*) > 1
);
    
    
/*Хотим выбрать модели определённого цвета, которые в какой-то момент времени хорошо продавались.*/
SELECT
    m.model_id, m.name_of_model, m.color, m.cost
FROM bags.Models m
WHERE m.color IN ('black', 'brown')
AND m.model_id IN (
    SELECT DISTINCT model_id
    FROM bags.Marketing
    WHERE quantity_of_orders > 29
)
AND m.cost IS NOT NULL
ORDER BY m.cost DESC;
    
    
/*Хотим получить информацию о покупателях, которые сделали заказ на Ottawa.*/
SELECT DISTINCT
    c.customer_id,
    c.first_name,
    c.second_name,
    c.city
FROM bags.Customers c
WHERE c.customer_id IN (
    SELECT o.customer_id
    FROM bags.Orders o
    WHERE o.model_id IN (
        SELECT model_id
        FROM bags.Models
        WHERE name_of_model = 'Ottawa'
    )
);    
    
    
/*Хотим получить информацию о заказах, которые мы доставляли через СДЭК или OZON.*/    
SELECT 
    o.order_id,
    o.order_date,
    o.customer_id,
    d.name_of_company as delivery_company
FROM bags.Orders o
JOIN bags.Delivery d ON o.delivery_id = d.delivery_id
WHERE o.delivery_id IN (
    SELECT delivery_id
    FROM bags.Delivery
    WHERE name_of_company IN ('СДЭК', 'OZON')
)
ORDER BY o.order_date DESC;
