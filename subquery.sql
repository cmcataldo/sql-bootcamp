/*
In summary, this query first identifies the ProductIDs of products 
that have been ordered in a total quantity greater than 100 using 
a subquery. Then, it joins this information back to the Production.
Product and Sales.SalesOrderDetail tables to retrieve the names of 
these popular products and their corresponding total ordered quantities.
*/

SELECT
    p.Name AS ProductName,
    TotalQuantityOrdered = SUM(sod.OrderQty)
FROM
    Production.Product AS p
INNER JOIN
    Sales.SalesOrderDetail AS sod ON p.ProductID = sod.ProductID
WHERE
    p.ProductID IN (SELECT sod_inner.ProductID
                    FROM Sales.SalesOrderDetail AS sod_inner
                    GROUP BY sod_inner.ProductID
                    HAVING SUM(sod_inner.OrderQty) > 100)
GROUP BY
    p.Name
ORDER BY
    TotalQuantityOrdered DESC;