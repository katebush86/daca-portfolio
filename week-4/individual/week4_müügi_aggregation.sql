-- Müük kuude kaupa
SELECT
  DATE_TRUNC('month', sale_date) AS kuu,
  COUNT(sale_id) AS tellimuste_arv,
  SUM(total_price) AS kogukäive,
  ROUND(AVG(total_price), 2) AS keskmine_tellimus
FROM sales
WHERE sale_date >= '2024-01-01'
GROUP BY DATE_TRUNC('month', sale_date)
ORDER BY kuu;

--formaat
SELECT
  TO_CHAR(DATE_TRUNC('month', sale_date), 'YYYY-MM') AS kuu,
  COUNT(sale_id) AS tellimuste_arv,
  SUM(total_price) AS kogukäive,
  ROUND(AVG(total_price), 2) AS keskmine_tellimus
FROM sales
WHERE sale_date >= DATE '2024-01-01'
GROUP BY DATE_TRUNC('month', sale_date)
ORDER BY DATE_TRUNC('month', sale_date);

-- Müük kuude kaupa 2024
SELECT
  DATE_TRUNC('month', sale_date) AS kuu,
  COUNT(sale_id) AS tellimuste_arv,
  SUM(total_price) AS kogukäive,
  ROUND(AVG(total_price), 2) AS keskmine_tellimus
FROM sales
WHERE sale_date >= DATE '2024-01-01'
  AND sale_date < DATE '2025-01-01'
GROUP BY DATE_TRUNC('month', sale_date)
ORDER BY kuu;

-- Müük kategooriate kaupa - tooted
SELECT
  p.category,
  COUNT(p.product_id) AS toodete_arv,
  SUM(s.total_price) AS kogumüük,
  ROUND(AVG(s.total_price), 2) AS keskmine_hind
FROM sales s
JOIN products p ON p.product_id = s.product_id
GROUP BY p.category
HAVING SUM(s.total_price) > 1000
ORDER BY kogumüük DESC;

-- müük kategooriate kaupa - müügiread
SELECT
  p.category,
  SUM(s.quantity) AS müüdud_ühikuid,
  SUM(s.total_price) AS kogumüük,
  ROUND(AVG(s.total_price), 2) AS keskmine_müük
FROM sales s
JOIN products p ON p.product_id = s.product_id
GROUP BY p.category
HAVING SUM(s.quantity) > 0
ORDER BY müüdud_ühikuid DESC;

select * from sales Limit 10
select * from products Limit 10
Limit 10

-- Kuised trendid CTE-ga
WITH kuu_myyk AS (
  SELECT
    DATE_TRUNC('month', sale_date) AS kuu,
    SUM(total_price) AS käive
  FROM sales
  WHERE sale_date >= '2024-01-01'
  GROUP BY DATE_TRUNC('month', sale_date)
)
SELECT
  kuu,
  käive,
  LAG(käive) OVER (ORDER BY kuu) AS eelmine_kuu,
  käive - LAG(käive) OVER (ORDER BY kuu) AS muutus
FROM kuu_myyk
ORDER BY kuu;

-- parima/halvima müügiga kuu
SELECT
  DATE_TRUNC('month', sale_date) AS kuu,
  SUM(total_price) AS kogumüük
FROM sales
GROUP BY DATE_TRUNC('month', sale_date)
--ORDER BY kogumüük DESC;
ORDER BY kogumüük aSC;

-- käibe muutuse %
WITH kuude_muuk AS (
  SELECT
    DATE_TRUNC('month', sale_date) AS kuu,
    SUM(total_price) AS kaive
  FROM sales
  GROUP BY DATE_TRUNC('month', sale_date)
)
SELECT
  kuu,
  kaive,
  ROUND(
    (kaive - LAG(kaive) OVER (ORDER BY kuu))
    / NULLIF(LAG(kaive) OVER (ORDER BY kuu), 0) * 100,
    1
  ) AS kasvu_protsent
FROM kuude_muuk
ORDER BY kuu;

-- Müügisummad kvartalite kaupa
SELECT
  DATE_TRUNC('quarter', sale_date) AS kvartal,
  SUM(total_price) AS kogumüük
FROM sales
GROUP BY DATE_TRUNC('quarter', sale_date)
ORDER BY kvartal;

-- Müügisummad aastate kaupa
SELECT
  DATE_TRUNC('year', sale_date) AS aasta,
  SUM(total_price) AS kogumüük
FROM sales
GROUP BY DATE_TRUNC('year', sale_date)
ORDER BY aasta;

-- aastaarvule taandatud
SELECT
  TO_CHAR(DATE_TRUNC('year', sale_date), 'YYYY') AS aasta,
  SUM(total_price) AS kogumüük
FROM sales
GROUP BY DATE_TRUNC('year', sale_date)
ORDER BY DATE_TRUNC('year', sale_date);

-- müügid aastate ja kategooriate kaupa
SELECT
  DATE_TRUNC('year', s.sale_date) AS aasta,
  p.category AS kategooria,
  SUM(s.total_price) AS kogumüük
FROM sales s
JOIN products p ON p.product_id = s.product_id
GROUP BY
  DATE_TRUNC('year', s.sale_date),
  p.category
ORDER BY
  aasta,
  kategooria;

  -- pivot
SELECT
  p.category AS kategooria,
  SUM(s.total_price) FILTER (
    WHERE s.sale_date >= DATE '2022-01-01'
      AND s.sale_date < DATE '2023-01-01'
  ) AS "2022",
  SUM(s.total_price) FILTER (
    WHERE s.sale_date >= DATE '2023-01-01'
      AND s.sale_date < DATE '2024-01-01'
  ) AS "2023",
  SUM(s.total_price) FILTER (
    WHERE s.sale_date >= DATE '2024-01-01'
      AND s.sale_date < DATE '2025-01-01'
  ) AS "2024",
  SUM(s.total_price) FILTER (
    WHERE s.sale_date >= DATE '2025-01-01'
      AND s.sale_date < DATE '2026-01-01'
  ) AS "2025",
  SUM(s.total_price) FILTER (
    WHERE s.sale_date >= DATE '2026-01-01'
      AND s.sale_date < DATE '2027-01-01'
  ) AS "2026"
FROM sales s
JOIN products p ON p.product_id = s.product_id
GROUP BY p.category
ORDER BY p.category;

-- pivot al 2023
SELECT
  p.category AS kategooria,
  SUM(s.total_price) FILTER (
    WHERE s.sale_date >= DATE '2023-01-01'
      AND s.sale_date < DATE '2024-01-01'
  ) AS "2023",
  SUM(s.total_price) FILTER (
    WHERE s.sale_date >= DATE '2024-01-01'
      AND s.sale_date < DATE '2025-01-01'
  ) AS "2024",
  SUM(s.total_price) FILTER (
    WHERE s.sale_date >= DATE '2025-01-01'
      AND s.sale_date < DATE '2026-01-01'
  ) AS "2025",
  SUM(s.total_price) FILTER (
    WHERE s.sale_date >= DATE '2026-01-01'
      AND s.sale_date < DATE '2027-01-01'
  ) AS "2026"
FROM sales s
JOIN products p ON p.product_id = s.product_id
GROUP BY p.category
ORDER BY p.category;

-- kasvu% 
WITH aastamüük AS (
  SELECT
    DATE_TRUNC('year', sale_date) AS aasta,
    SUM(total_price) AS kogumüük
  FROM sales
  GROUP BY DATE_TRUNC('year', sale_date)
),
võrdlus AS (
  SELECT
    aasta,
    kogumüük,
    LAG(kogumüük) OVER (ORDER BY aasta) AS eelmise_aasta_müük
  FROM aastamüük
)
SELECT
  TO_CHAR(aasta, 'YYYY') AS aasta,
  kogumüük,
  ROUND(
    (kogumüük - eelmise_aasta_müük)
      / NULLIF(eelmise_aasta_müük, 0) * 100,
    1
  ) AS kasvu_protsent
FROM võrdlus
ORDER BY aasta;