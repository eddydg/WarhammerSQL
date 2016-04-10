WITH
-- Total Costs by Units
sum_squad AS (
	SELECT
		squads.id AS squad_id,
		squads.name AS squad_name,
		units.id AS unit_id,
		units.name AS unit_name,
		sum(upkeeps.points) AS sums
	FROM units
	JOIN squads ON squads.id = units.squad_id
	JOIN upkeeps ON upkeeps.unit_id = units.id
	GROUP BY squads.id, squads.name, units.id, units.name
),
-- Max Costs by Squad
max_squad AS (
	SELECT DISTINCT ON (points)
		sum_squad.squad_id AS squad_id,
		max(sum_squad.sums) OVER (
			PARTITION BY sum_squad.squad_id
			ORDER BY sum_squad.sums DESC
		) AS points
	FROM sum_squad
),
-- Max Cost by any Squad
max_global_points AS (
	SELECT points FROM max_squad
	ORDER BY points
	DESC LIMIT 1
),
-- Total costs
total_points AS (
	SELECT sum(points) AS points
	FROM units
	JOIN upkeeps
	ON upkeeps.unit_id = units.id
 )
SELECT
	sum_squad.squad_id AS id,
	sum_squad.squad_name AS name,
	sum_squad.unit_id AS id,
	sum_squad.unit_name AS name,
	sum_squad.sums AS amount,
	ROUND (100.0 * sum_squad.sums / (SELECT points FROM max_squad
					  WHERE max_squad.squad_id = sum_squad.squad_id),
		3) AS percent_squad,
	ROUND (100.0 * sum_squad.sums / (SELECT points FROM max_global_points),
		3) AS percent_global,
	ROUND (100.0 * sum_squad.sums / (SELECT points FROM total_points),
		3) AS percent_total
FROM sum_squad
JOIN max_squad ON max_squad.squad_id = sum_squad.squad_id
ORDER BY sum_squad.squad_id, unit_id
;