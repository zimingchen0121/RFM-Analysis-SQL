CREATE VIEW RFM_analysis AS
SELECT C.CustomerId,
IL.Quantity,
IL.UnitPrice,
--convert(varchar, InvoiceDate, 23) AS PurchaseDate,
CONVERT(varchar, MAX(INVOICEDATE), 23) AS LASTPURCHASEDATE,
DATEDIFF(DAY,CONVERT(varchar, MAX(INVOICEDATE), 23),'2015-12-31') AS Recency,
COUNT(C.CUSTOMERID) AS Frequency,
SUM(UnitPrice*Quantity) AS Monetary,
NTILE(4) OVER (ORDER BY DATEDIFF(DAY,CONVERT(varchar, MAX(INVOICEDATE), 23),'2015-12-31') ) AS RQuantile,
NTILE(4) OVER (ORDER BY COUNT(C.CUSTOMERID)DESC) AS FQuantile,
NTILE(4) OVER (ORDER BY SUM(UnitPrice*Quantity) DESC) AS MQuantile,

CONCAT(NTILE(4) OVER (ORDER BY DATEDIFF(DAY,CONVERT(varchar, MAX(INVOICEDATE), 23),'2015-12-31') ),
NTILE(4) OVER (ORDER BY COUNT(C.CUSTOMERID)DESC),
NTILE(4) OVER (ORDER BY SUM(UnitPrice*Quantity) DESC)) AS Score
FROM Customer C
JOIN Invoice I ON I.CustomerId = C. CustomerId
JOIN InvoiceLine IL ON IL.InvoiceId = I. InvoiceId
WHERE C.Country ='United States'	AND C.CustomerId IS NOT NULL 
AND Quantity IS NOT NULL AND UnitPrice IS NOT NULL AND InvoiceDate IS NOT NULL
AND YEAR(INVOICEDATE)=2015
GROUP BY
C.CustomerId,
IL.Quantity,
IL.UnitPrice,
CONVERT(varchar, InvoiceDate, 23)



--To define how many records in each year, I will use 2015 dataset because it contains the largest records.
/*SELECT COUNT(*),YEAR(INVOICEDATE) FROM  Customer C
JOIN Invoice I ON I.CustomerId = C. CustomerId
JOIN InvoiceLine IL ON IL.InvoiceId = I. InvoiceId
GROUP BY YEAR(INVOICEDATE)
ORDER BY  YEAR(INVOICEDATE) DESC 
*/

