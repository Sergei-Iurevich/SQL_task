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
