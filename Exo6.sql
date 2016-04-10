with missions_squads AS (
	select
		missions.id as mission_id,
		missions.name as mission_name,
		missions.start_date,
		missions.end_date,
		units.squad_id as squad_id
	from missions
	join volunteers on volunteers.mission_id = missions.id
	join units on units.id = volunteers.unit_id
),
dependent_squads AS (
	select
		missions_squads.mission_id,
		missions_squads.mission_name,
		missions_squads.start_date,
		missions_squads.end_date,
		squads.id as squad_id,
		missions_squads.squad_id as leader_id
	from missions_squads
	join squads on squads.leader_id = missions_squads.squad_id
		or squads.id = missions_squads.squad_id -- we also include first own squad's units
),
squad_unit AS (
	select
		distinct(units.id) as unit_id,
		mission_id,
		mission_name,
		start_date,
		end_date
	from dependent_squads
	join units on units.squad_id = dependent_squads.squad_id
),
unbound_mission AS (
	select
		mission_id as id,
		mission_name as name,
		start_date,
		end_date,
		bilan.scheduled,
		sum(bilan.points) as points
	from squad_unit
	join get_bilan(unit_id) as bilan on bilan.id = unit_id
	where scheduled >= start_date and scheduled < end_date
	group by mission_id, mission_name, start_date, end_date, bilan.scheduled
	order by squad_unit.mission_id
)
select
	id,
	name,
	scheduled,
	points,
	sum(points) over (partition by id order by scheduled) as total
from unbound_mission
;
