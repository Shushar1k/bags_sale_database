CREATE SCHEMA bags;

CREATE TABLE bags.Models (
    model_id INTEGER PRIMARY KEY,
    name_of_model VARCHAR(200) NOT NULL,
    color VARCHAR(200) NOT NULL,
    cost_price INTEGER NOT NULL,
    cost INTEGER NOT NULL,
    comment VARCHAR(200)
);

CREATE TABLE bags.Marketing (
    web_id INTEGER PRIMARY KEY,
    model_id INTEGER NOT NULL,
    quantity_of_clicks INTEGER,
    quantity_of_orders INTEGER,
    start_date DATE,
    finish_date DATE,
    FOREIGN KEY (model_id) REFERENCES bags.Models(model_id)
);

CREATE TABLE bags.Customers (
    customer_id INTEGER PRIMARY KEY,
    first_name VARCHAR(200) NOT NULL,
    second_name VARCHAR(200) NOT NULL,
    city VARCHAR(200) NOT NULL,
    pickup_address VARCHAR(200) NOT NULL,
    comment VARCHAR(200)
);

CREATE TABLE bags.Delivery (
    delivery_id INTEGER PRIMARY KEY,
    name_of_company VARCHAR(200) NOT NULL,
    address_of_warehouse VARCHAR(200) NOT NULL,
    personal_manager_phone VARCHAR(200)
);

CREATE TABLE bags.Features (
    feature_id INTEGER PRIMARY KEY,
    name_of_feature VARCHAR(200) NOT NULL,
    cost INTEGER
);

CREATE TABLE bags.Delivery_company_features (
    delivery_id INTEGER NOT NULL,
    feature_id INTEGER NOT NULL,
    PRIMARY KEY (delivery_id, feature_id),
    FOREIGN KEY (delivery_id) REFERENCES bags.Delivery(delivery_id),
    FOREIGN KEY (feature_id) REFERENCES bags.Features(feature_id)
);

CREATE TABLE bags.Orders (
    order_id INTEGER PRIMARY KEY,
    model_id INTEGER NOT NULL,
    customer_id INTEGER NOT NULL,
    delivery_id INTEGER NOT NULL,
    order_date DATE NOT NULL,
    comment VARCHAR(200),
    FOREIGN KEY (model_id) REFERENCES bags.Models(model_id),
    FOREIGN KEY (customer_id) REFERENCES bags.Customers(customer_id),
    FOREIGN KEY (delivery_id) REFERENCES bags.Delivery(delivery_id)
);
