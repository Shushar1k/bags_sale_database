/*Индекс, чтобы ускорить поиск нужной сумки, т.к. id сложно будет запомнить с расширением ассортимента, а название и цвет -- проще, поэтому далее такие поиски будет оправданы...*/
CREATE INDEX index_model_and_color ON bags.Models(name_of_model, color);

/*Этот индекс будет ускорять поиск покупателя по ФИО.*/
CREATE INDEX index_name ON bags.Customers(first_name, second_name);
