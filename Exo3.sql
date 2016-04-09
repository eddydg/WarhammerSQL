SELECT
	result.id,
	result.name,
	count(*) AS sum
FROM (
	SELECT
		id,
		"name",
		points,
		lead(points) over (ORDER BY scheduled) AS prev_point
	FROM units
	JOIN upkeeps ON upkeeps.unit_id = units.id
) AS result
WHERE points is distinct FROM result.prev_point
GROUP BY id, "name";
