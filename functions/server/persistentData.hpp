/*--------------------------------------------------------------------
	file: persistentData.hpp
	========================
	Author: Bhaz <>
	Description: Macro shortcuts into the database arrays.
--------------------------------------------------------------------*/

/* -------------------------------------------------------
	PERSISTENT DATA ROAD MAP

	ITD_version - current version of save data

	ITD_progress - array of general mission vars
		0 - kill count,
		1 - support counter (for next unlock),
		2 - camp counter (for next unlock),
		3 - support crew available,				(global: ITD_global_crewAvailable)
		4 - additional camps available,			(global: ITD_global_campsAvailable)
		5 - tech1 available,					(global: ITD_global_tech1)

	ITD_camps - array of camp locations, one entry per camp
		0 - building array:
			0 - HQ position
			1 - HQ direction
			2 - detected by enemy (bool)
			3 - [service position, service direction, [serviceData]]
			4 - [recruit position, recruit direction]

	ITD_objectives - forEach array containing state of all objectives
		0 - objective name
		1 - objective state (integer)
------------------------------------------------------- */
#define PUBLIC(var,value) var = value; publicVariable #var

#define DB_PROGRESS ITD_server_db_progress

#define DB_PROGRESS_KILLS DB_PROGRESS select 0
#define DB_PROGRESS_SUPPORT_COUNTER DB_PROGRESS select 1
#define DB_PROGRESS_CAMP_COUNTER DB_PROGRESS select 2
#define DB_PROGRESS_CREW_AVAILABLE DB_PROGRESS select 3
#define DB_PROGRESS_CAMPS_AVAILABLE DB_PROGRESS select 4
#define DB_PROGRESS_TECH1 DB_PROGRESS select 5

#define SET_DB_PROGRESS_KILLS(var) DB_PROGRESS set [0, var]
#define SET_DB_PROGRESS_SUPPORT_COUNTER(var) DB_PROGRESS set [1, var]
#define SET_DB_PROGRESS_CAMP_COUNTER(var) DB_PROGRESS set [2, var]
#define SET_DB_PROGRESS_CREW_AVAILABLE(var) DB_PROGRESS set [3, var]
#define SET_DB_PROGRESS_CAMPS_AVAILABLE(var) DB_PROGRESS set [4, var]
#define SET_DB_PROGRESS_TECH1(var) DB_PROGRESS set [5, var]

#define DB_CAMPS ITD_server_db_camps
#define DB_CAMPS_ID ITD_server_db_camps select _id

#define DB_CAMPS_HQ_POSITION DB_CAMPS select _id select 0
#define DB_CAMPS_HQ_DIRECTION DB_CAMPS select _id select 1
#define DB_CAMPS_HQ_DETECTED DB_CAMPS select _id select 2

#define DB_CAMPS_SERVICE DB_CAMPS select _id select 3
#define DB_CAMPS_SERVICE_POSITION DB_CAMPS_SERVICE select 0
#define DB_CAMPS_SERVICE_DIRECTION DB_CAMPS_SERVICE select 1
#define DB_CAMPS_SERVICE_DATA DB_CAMPS_SERVICE select 2
#define DB_CAMPS_SERVICE_DATA_FUEL DB_CAMPS_SERVICE_DATA select 0
#define DB_CAMPS_SERVICE_DATA_PARTS DB_CAMPS_SERVICE_DATA select 1
#define DB_CAMPS_SERVICE_DATA_MILITARY DB_CAMPS_SERVICE_DATA select 2

#define DB_CAMPS_RECRUIT ITD_server_db_camps select _id select 4
#define DB_CAMPS_RECRUIT_POSITION DB_CAMPS_RECRUIT select 0
#define DB_CAMPS_RECRUIT_DIRECTION DB_CAMPS_RECRUIT select 1

#define DB_OBJECTIVES ITD_server_db_objectives
