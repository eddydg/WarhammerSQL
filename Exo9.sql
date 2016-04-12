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
)
select
	concat(
		leaders.title,
		(SELECT string_agg(concat(E'\t', units.name, ' [', units.id, ']'), E'\n') FROM units WHERE units.squad_id = leaders.squad_id),
		E'\n',
		(SELECT string_agg(concat(E'\t(', squads.category, ') ', squads.name, ' [', squads.id, ']'), E'\n')
			FROM squads
			WHERE squads.leader_id = leaders.squad_id)
	)
FROM leaders;
;



