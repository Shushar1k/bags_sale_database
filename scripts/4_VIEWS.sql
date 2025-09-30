/*Таблица для более наглядной демонстрации деталей заказов.*/
CREATE VIEW sales_analysis AS
SELECT 
    o.order_id,
    o.order_date,
    m.name_of_model,
    m.color,
    m.cost as price,
    (m.cost - m.cost_price) as profit,
    c.first_name || ' ' || c.second_name as customer_name,
    c.city,
    d.name_of_company as delivery_company
FROM bags.Orders o
JOIN bags.Models m ON o.model_id = m.model_id
JOIN bags.Customers c ON o.customer_id = c.customer_id
JOIN bags.Delivery d ON o.delivery_id = d.delivery_id
WHERE m.cost IS NOT NULL;


/*Таблица с информацией о каждом клиенте: какую сумку и когда он купил.*/
CREATE VIEW customer_orders AS
SELECT 
    c.customer_id,
    c.first_name || ' ' || c.second_name as customer_name,
    c.city,
    o.order_id,
    o.order_date,
    m.name_of_model,
    m.color,
    m.cost
FROM bags.Customers c
JOIN bags.Orders o ON c.customer_id = o.customer_id
JOIN bags.Models m ON o.model_id = m.model_id
ORDER BY c.customer_id, o.order_id;
