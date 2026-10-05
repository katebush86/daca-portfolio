-- Tabeli ridade arv
SELECT count(*) FROM sales

-- Esimesed 10 rida, et nähe andmeid ja veergude pealkirju
SELECT *
FROM sales
LIMIT 10;

-- Tallinna kaupluse tehingud
SELECT * FROM sales
WHERE store_location = 'Tallinn'
LIMIT 15;

-- Suurimad tehingud
SELECT * FROM sales
ORDER BY total_price DESC LIMIT 10;

-- Väikseimad tehingud
SELECT * FROM sales
ORDER BY total_price ASC LIMIT 10;

-- Read, kus kliendi andmed on puudu
SELECT *
FROM sales
WHERE customer_id IS NULL
LIMIT 10;

-- Puuduolev klient per poe asukoht
SELECT store_location AS poe_asukoht,
COUNT(*) AS puuduv_klient FROM sales
WHERE customer_id IS NULL
GROUP BY store_location
ORDER BY store_location
LIMIT 10;

--Müükide arv per unikaalne müügikanal:
SELECT
    channel AS müügikanal,
    COUNT(*) AS müükide_arv
FROM sales
GROUP BY channel
ORDER BY channel;

--Puuduolevad andmed - Otsi NULL väärtusi olulistes veergudes - klient
SELECT customer_id FROM sales
--WHERE customer_id IS NULL;
COUNT(*) - COUNT(customer_id) AS puuduv_klient;