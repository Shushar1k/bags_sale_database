/*Индекс, чтобы ускорить поиск нужной сумки, т.к. id сложно будет запомнить с расширением ассортимента, а название и цвет -- проще, поэтому далее такие поиски будет оправданы...*/
CREATE INDEX index_model_and_color ON bags.Models(name_of_model, color);

/*Этот индекс будет ускорять поиск дополнительных услуг в технической таблице.*/
CREATE INDEX index_delivery_features ON bags.Delivery_company_features(delivery_id, feature_id);
