/*
foreach squad_chief (where leader_id = null)
	foreach units (where units.squad_id = squad_chief.id)
	foreach squad (where squad.chef_id = squad_chief.id)
		foreach units (where units.squad_id = squad.id)

*/

WITH leaders AS (
	select
		squads.id as squad_id,
		concat('(', squads.category, ') ', squads.name, ' [', squads.id, E']\n') as title
	from squads
	where leader_id IS NULL
), pretty_units AS (
	SELECT
		units.squad_id,
		concat(E'\t', units.name, ' [', units.id, ']') as title
	FROM units
), pretty_squads AS (
	SELECT
		squads.id,
		squads.leader_id,
		concat(
			E'\t(', squads.category, ') ', squads.name, ' [', squads.id, ']',
			E'\n',
			string_agg(
				concat(
					E'\t\t',
					units.name, ' [', units.id, ']'
				),
				E'\n'
			)
		) as title
	FROM squads
	JOIN units ON units.squad_id = squads.id
	GROUP BY squads.id, squads.leader_id
)
select
	string_agg(
		concat(
			leaders.title,
			(SELECT string_agg(pretty_units.title, E'\n')
				FROM pretty_units
				WHERE pretty_units.squad_id = leaders.squad_id),
			E'\n',
			(SELECT concat(
					string_agg(pretty_squads.title, E'\n'),
					E'\n'
				)
				FROM pretty_squads
				WHERE pretty_squads.leader_id = leaders.squad_id)
		),
		E'\n'
	)
FROM leaders;
;
