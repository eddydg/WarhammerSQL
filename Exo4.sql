WITH sum_list AS (
	select
		squads.id AS squad_id,
		squads.name AS squad_name,
		units.id AS unit_id,
		units.name AS unit_name,
		upkeeps.points AS amount,
		sum(points) over (partition by units.id) AS sum_amount
	from units
	JOIN upkeeps ON upkeeps.unit_id = units.id
	JOIN squads ON units.squad_id = squads.id
), max_summary AS (
	SELECT
		*,
		max(sum_amount) over (partition by squad_id) AS max_amount,
		ROW_NUMBER() OVER(PARTITION BY squad_id
					 ORDER BY amount DESC) AS rk
	 FROM sum_list
 ), min_summary AS (
	SELECT
		*,
		min(sum_amount) over (partition by squad_id) AS min_amount,
		ROW_NUMBER() OVER(PARTITION BY squad_id
					 ORDER BY amount) AS rk
	 FROM sum_list
 )
select squad_id, squad_name, max_summary.unit_id, unit_name, max_amount AS amount, 'best' AS comment from max_summary
where max_summary.rk = 1
UNION
select squad_id, squad_name, min_summary.unit_id, unit_name, min_amount AS amount, 'worst' AS comment from min_summary
where min_summary.rk = 1
ORDER BY squad_id, unit_id DESC
;