(query (select :name :age) (from users) (where (> age 18)) (order-by age) (limit 10))
