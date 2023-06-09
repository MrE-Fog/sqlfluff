-- EXCEPT DISTINCT
SELECT c FROM number1 EXCEPT DISTINCT SELECT c FROM number2;

-- INTERSECT DISTINCT
(SELECT c FROM number1) INTERSECT DISTINCT (SELECT c FROM number2);

-- UNION DISTINCT
(SELECT c FROM number1) UNION DISTINCT (SELECT c FROM number2);

-- UNION ALL
SELECT c FROM number1 UNION ALL (SELECT c FROM number2);

-- nesting of UNIONs
(SELECT c FROM number1 UNION ALL SELECT c FROM number2)
UNION ALL
(SELECT c FROM number3 UNION ALL SELECT c FROM number4);
