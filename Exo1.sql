WITH salary AS (
	SELECT
		units.id AS unit_id,
		(CASE squads.category
			WHEN 'HQ' THEN 100
			WHEN 'Elites' then 75
			WHEN 'Fast Attack' THEN 50
			WHEN 'Heavy Support' THEN 50
			WHEN 'Troops' THEN 25
		END)
		+ (CASE WHEN units.chief_id is NULL THEN 1 ELSE 0 END) * 5
		AS points
	FROM units
	JOIN squads ON units.squad_id = squads.id
) 
INSERT INTO upkeeps
SELECT
	salary.unit_id ,
	scheduled,
	points + floor(random() * 6) AS point
FROM salary
CROSS JOIN (SELECT generate_series(
		'2016-04-01', 
		'2016-04-01'::DATE + interval '1 month' * 47,
		'1 month'::interval
	)AS scheduled) AS a
