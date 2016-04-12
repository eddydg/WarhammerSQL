   WITH units_by_category AS (
    SELECT
        units.id,
        units.name,
        squads.category,
        points,
        extract(year from upkeeps.scheduled) as year
    FROM squads
    JOIN units ON units.squad_id = squads.id
    JOIN upkeeps on upkeeps.unit_id = units.id
), results AS (
    SELECT
    distinct on (category, year)
	category,
        sum(points) OVER (PARTITION BY category, year) AS total,
        year
    FROM units_by_category as u
)
SELECT
	curr_year,
    (SELECT total FROM results WHERE category = 'HQ' and year = curr_year) as "	HQ",
    (SELECT total FROM results WHERE category = 'Elites' and year = curr_year) as "Elites",
    (SELECT total FROM results WHERE category = 'Troops' and year = curr_year) as "Troops",
    (SELECT total FROM results WHERE category = 'Fast Attack' and year = curr_year) as "Fast Attack",
    (SELECT total FROM results WHERE category = 'Heavy Support' and year = curr_year) as "Heavy Support"
FROM generate_series(
		(SELECT min(extract(year FROM scheduled)::INT) FROM upkeeps),
		(SELECT max(extract(year FROM scheduled)::INT) FROM upkeeps)
	) as curr_year
;