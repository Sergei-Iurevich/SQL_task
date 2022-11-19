-- 1. Все товары, в которых в название есть пометка urgent или название начинается с Animal

SELECT *
from Warehouse.StockItems 
where StockItemName like '%urgent%' or StockItemName like 'Animal%'

--2. Поставщиков, у которых не было сделано ни одного заказа (потом покажем как это делать через подзапрос, сейчас сделайте через JOIN)

select sup.SupplierID, sup.SupplierName, ord.PurchaseOrderID
from Purchasing.Suppliers as sup
LEFT JOIN Purchasing.PurchaseOrders as ord 
on (ord.SupplierID=sup.SupplierID)
WHERE ord.PurchaseOrderID is NULL

--3. Продажи с названием месяца, в котором была продажа, номером квартала, к которому относится продажа, включите также к какой трети года относится дата - каждая треть по 4 месяца, дата забора заказа должна быть задана, с ценой товара более 100$ либо количество единиц товара более 20. Добавьте вариант этого запроса с постраничной выборкой пропустив первую 1000 и отобразив следующие 100 записей. Соритровка должна быть по номеру квартала, трети года, дате продажи.

select ord.OrderID,ord.OrderDate, DATENAME(MONTH,ord.OrderDate) as month,DATENAME(QUARTER,ord.OrderDate) as quarter,
case 
    when Month(ord.OrderDate)<=4 then '1 third'
    when Month(ord.OrderDate)<=8 then '2 third'
    else '3 third'
end as third,
ord.ExpectedDeliveryDate,
ol.UnitPrice
from Sales.Orders as ord
INNER JOIN Sales.OrderLines as ol on (ol.OrderID=ord.OrderID)
WHERE (ol.UnitPrice>100 or ol.Quantity>20)

select DATENAME(MONTH,ord.OrderDate) as month,DATENAME(QUARTER,ord.OrderDate) as quarter,
case 
    when Month(ord.OrderDate)<=4 then '1 third'
    when Month(ord.OrderDate)<=8 then '2 third'
    else '3 third'
end as third,
ord.ExpectedDeliveryDate
from Sales.Orders as ord
INNER JOIN Sales.OrderLines as ol on (ol.OrderID=ord.OrderID)
WHERE (ol.UnitPrice>100 or ol.Quantity>20)
order by quarter,third, ord.OrderDate
OFFSET 1000 ROWS FETCH NEXT 100 ROWS ONLY

--4. Заказы поставщикам, которые были исполнены за 2014й год с доставкой Road Freight или Post, добавьте название поставщика, имя контактного лица принимавшего заказ

select po.PurchaseOrderID,year(po.ExpectedDeliveryDate) as year,s.SupplierName, p.FullName, dm.DeliveryMethodName
from Purchasing.PurchaseOrders as po 
INNER JOIN Application.DeliveryMethods as dm on (dm.DeliveryMethodID=po.DeliveryMethodID)
INNER JOIN Purchasing.Suppliers as s on (s.SupplierID = po.SupplierID)
INNER JOIN  Application.People as p on (p.PersonID = po.SupplierID and p.IsEmployee=1)
WHERE dm.DeliveryMethodName in ('Road Freight','Post') 
and year(po.ExpectedDeliveryDate) =2014

--5. 10 последних по дате продаж с именем клиента и именем сотрудника, который оформил заказ.

select so.OrderID, apc.FullName as name_customer, aps.FullName as name_salesperson, so.OrderDate as orderdate
from Sales.Orders as so 
INNER JOIN Application.People as apc ON (apc.PersonID=so.CustomerID)
INNER JOIN Application.People as aps on (aps.PersonID=so.SalespersonPersonID)
ORDER BY orderdate desc
OFFSET 0 rows FETCH NEXT 10 rows ONLY

--6. Все ид и имена клиентов и их контактные телефоны, которые покупали товар Chocolate frogs 250g 

SELECT so.CustomerID,ap.FullName, ap.PhoneNumber
from Sales.OrderLines as sol
INNER JOIN Warehouse.StockItems as wsi on (wsi.StockItemID=sol.StockItemID and wsi.StockItemName='Chocolate frogs 250g')
INNER JOIN Sales.Orders as so on (so.OrderID=sol.OrderID)
INNER JOIN Application.People as ap on (ap.PersonID=so.CustomerID)


