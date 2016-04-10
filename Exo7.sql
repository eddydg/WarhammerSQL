CREATE OR REPLACE VIEW ex7 AS
WITH scores AS (
	SELECT 
		extract(year from scheduled) as year,
		extract(month from scheduled) as month,
		sum(points)
	FROM upkeeps
	GROUP BY scheduled
)
SELECT
	curr_year as year,
	(SELECT sum FROM scores WHERE year = curr_year AND month = 1) as jan,
	(SELECT sum FROM scores WHERE year = curr_year AND month = 2) as feb,
	(SELECT sum FROM scores WHERE year = curr_year AND month = 3) as mar,
	(SELECT sum FROM scores WHERE year = curr_year AND month = 4) as apr,
	(SELECT sum FROM scores WHERE year = curr_year AND month = 5) as may,
	(SELECT sum FROM scores WHERE year = curr_year AND month = 6) as jun,
	(SELECT sum FROM scores WHERE year = curr_year AND month = 7) as jul,
	(SELECT sum FROM scores WHERE year = curr_year AND month = 8) as aug,
	(SELECT sum FROM scores WHERE year = curr_year AND month = 9) as sep,
	(SELECT sum FROM scores WHERE year = curr_year AND month = 10) as oct,
	(SELECT sum FROM scores WHERE year = curr_year AND month = 11) as nov,
	(SELECT sum FROM scores WHERE year = curr_year AND month = 12) as dec
FROM
	generate_series(
		(SELECT min(extract(year FROM scheduled)::INT) FROM upkeeps),
		(SELECT max(extract(year FROM scheduled)::INT) FROM upkeeps)
	) as curr_year
;

SELECT * FROM ex7;