/**********************Rock Planet Areas**************************/

/area/rockplanet
	icon_state = "mining"
	has_gravity = STANDARD_GRAVITY
	flags_1 = NONE
	area_flags = VALID_TERRITORY | UNIQUE_AREA | FLORA_ALLOWED
	sound_environment = SOUND_AREA_ASTEROID

/area/rockplanet/surface
	name = "Rockplanet"
	icon_state = "explored"
	always_unpowered = TRUE
	power_environ = FALSE
	power_equip = FALSE
	power_light = FALSE
	requires_power = TRUE
	ambientsounds = CREEPY_SOUNDS
	area_flags = VALID_TERRITORY | UNIQUE_AREA | FLORA_ALLOWED

/area/rockplanet/underground
	name = "Rockplanet Caves"
	icon_state = "unexplored"
	always_unpowered = TRUE
	requires_power = TRUE
	power_environ = FALSE
	power_equip = FALSE
	power_light = FALSE
	ambientsounds = CREEPY_SOUNDS
	area_flags = VALID_TERRITORY | UNIQUE_AREA | FLORA_ALLOWED
/area/rockplanet/surface/outdoors
	name = "Rockplanet Wastes"
	outdoors = TRUE

/area/rockplanet/surface/outdoors/unexplored //monsters and ruins spawn here
	icon_state = "unexplored"
	area_flags = VALID_TERRITORY | UNIQUE_AREA | CAVES_ALLOWED | FLORA_ALLOWED | MOB_SPAWN_ALLOWED
	map_generator = /datum/map_generator/cave_generator/rockplanet

/area/rockplanet/surface/outdoors/unexplored/danger //megafauna will also spawn here
	icon_state = "danger"
	area_flags = VALID_TERRITORY | UNIQUE_AREA | CAVES_ALLOWED | FLORA_ALLOWED | MOB_SPAWN_ALLOWED | MEGAFAUNA_SPAWN_ALLOWED

/area/rockplanet/surface/outdoors/explored
	name = "Rockplanet Labor Camp"
	area_flags = VALID_TERRITORY | UNIQUE_AREA

/area/mine/rockplanet
	name = "Abandoned Syndicate Mining Facility"

/area/mine/rockplanet_nanotrasen
	name = "Abandoned Mining Facility"

