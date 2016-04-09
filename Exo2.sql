-- Exercice 2
SELECT
	units.id,
	units.name,
	upkeeps.scheduled,
	upkeeps.points,
	sum(upkeeps.points) OVER (
		PARTITION BY units.id
		ORDER BY upkeeps.scheduled
	) AS cumul
FROM units
JOIN upkeeps ON upkeeps.unit_id = units.id;

-- Exercice 2 (bis)
CREATE OR REPLACE FUNCTION get_bilan (wantedId int)
    RETURNS TABLE(
	id int,
	"name" character varying,
	scheduled date,
	points int,
	cumul bigint
    )
    AS $$
BEGIN
	RETURN QUERY
	SELECT
		units.id,
		units.name,
		upkeeps.scheduled,
		upkeeps.points,
		sum(upkeeps.points) OVER (
			PARTITION BY units.id
			ORDER BY upkeeps.scheduled
		) AS cumul
	FROM units
	JOIN upkeeps ON upkeeps.unit_id = units.id
	WHERE units.id = wantedId;
END;
$$ LANGUAGE plpgsql;

--SELECT get_bilan(1);
