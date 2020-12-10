install.packages("RSQLite")
install.packages("DBI")
library(RSQLite)
library(DBI)
db <- 'chinook.db'

conn = dbConnect(SQLite(),'chinook.db')
q <- "SELECT * FROM invoice;"
result <- dbGetQuery(conn, q)
result

#run query funtion 
run_query <- function(q) {
  conn <- dbConnect(SQLite(), db)
  res <- dbGetQuery(conn, q)
  dbDisconnect(conn)
  return(res)
}

show_tables <- function() {
  q <- "SELECT
    name,
    type
FROM sqlite_master
WHERE type IN ('table','view')"
  return(run_query(q))
  
}
show_tables()

#selecting new albums depending upon their total sales

albums_to_buy = 
  'WITH USA_tracks_sold AS
(
  SELECT il.* FROM invoice_line il
  INNER JOIN invoice i ON i.invoice_id = il.invoice_id
  INNER JOIN customer c ON c.customer_id = i.customer_id
  WHERE c.country = "USA"
)
SELECT g.name genre_name, count(uts.invoice_line_id) track_sold, 
cast(count(uts.invoice_line_id) AS FLOAT)/(SELECT COUNT(*) FROM USA_tracks_sold) percentage_sold
FROM USA_tracks_sold uts
INNER JOIN track t ON t.track_id = uts.track_id
INNER JOIN genre g ON g.genre_id = t.genre_id
INNER JOIN album a ON a.album_id = t.album_id
GROUP BY 1
ORDER BY 2 DESC 
LIMIT 10;'

run_query(albums_to_buy)
install.packages("ggplot2")
library(ggplot2)

album_sales = run_query(albums_to_buy)
ggplot(data = album_sales, aes(x = genre_name, y = percentage_sold)) + geom_bar(stat = "identity")

sales_support_performance = '
  WITH customer_sales AS
(
     SELECT
         i.customer_id,
         c.support_rep_id,
         SUM(i.total) total
     FROM invoice i
     INNER JOIN customer c ON i.customer_id = c.customer_id
     GROUP BY 1,2
    )
SELECT
    e.first_name || " " || e.last_name employee,
    e.hire_date,
    SUM(cs.total) total_sales
FROM customer_sales cs
INNER JOIN employee e ON e.employee_id = cs.support_rep_id
GROUP BY 1;
'
run_query(sales_support_performance)

sales_performance = run_query(sales_support_performance)
ggplot(data = sales_performance, aes(x = employee, y = total_sales)) + geom_bar(stat = "identity")

##statement 

purchase_different_countries <- 
  'WITH country_sales AS
        (
        SELECT c.country country, SUM(i.total) total 
        FROM invoice i
        INNER JOIN customer c ON i.customer_id = c.customer_id
        GROUP BY 1,2
        ) 
        SELECT COUNT(customer_id), csl.total, mean(csl.total) 
        FROM country_sales cls
        INNER JOIN 
          '