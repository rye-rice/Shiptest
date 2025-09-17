#define MINIMUM_LIGHT_FOR_LUMINOSITY 0.3
#define VALUES_PER_TRANSITION 5
#define TRANSITION_VALUE (1 / VALUES_PER_TRANSITION)
#define ALL_TRANSITIONS (VALUES_PER_TRANSITION * 6)
#define TWEAK_HOUR_SHIFT -1.5 //The amount of hours we tweak forwards to make the cycle more earth-like

/**
 * Handles daynight cycles.
 * * Meant to increase difficulty as irl time gets late and also to remind people to SLEEP, but also above all, look really pretty

 * * Days are split into 6 times:
 * * * Noon 9-12
 * * * Midday (Default) 12-15
 * * * Evening 15-17
 * * * Sunset 18
 * * * Night 19-22
 * * * Midnight 22-24
 * * After midnight, we go in reverse...
* * * Midnight 0-2
* * * Night 2-4
* * * Sunset 5
* * * Evening 6-9
 *
 * Returns TRUE or FALSE depending on if it actually fired a shot.
 * Arguments:
 * * target - The atom we are trying to hit.
 * * user - The living mob firing the gun, if any.
 * * message - Do we show the usual messages? eg. "x fires the y!"
 * * params - Is the params string from byond [/atom/proc/Click] code, see that documentation.
 * * zone_override - The bodypart we attempt to hit, sometimes hits another.
 * * bonus_spread - Adds this value to spread, in this case used by dual wielding.
 * * burst_firing - Not to be confused with currently_firing_burst. This var is TRUE when we are doing a burst except for the first shot in a burst, as to override the spam burst checks.
 * * spread_override - Bullet spread is forcibly set to this. This is usually because of bursts attempting to share the same burst trajectory.
 * * iteration - Which shot in a burst are we in.
 */
/datum/day_night_controller
	///Do we ignore simulating this planet's time in favor of matching with the irl server's clock?
	var/synced_to_server_time = TRUE
	///How many hours are in this planet's day?
	var/hours_in_a_day = 24
	///How many minutes are in this planet's hour? Determines how often this controller is updated
	var/minutes_in_ahour = 60

	var/noon_range = 2
	var/noon_power = 0.80
	var/noon_color = "#e6d9b5"

	///set this to the old "lit" turf's colors
	var/midday_range = 2
	var/midday_power = 0.80
	var/midday_color = COLOR_BEACHPLANET_LIGHT

	var/evening_range = 2
	var/evening_power = 0.80
	var/evening_color = "#bf8e60"

	var/sunset_range = 2
	var/sunset_power = 0.80
	var/sunset_color = "#6e182b"

	var/night_range = 2
	var/night_power = 0.80
	var/night_color = "#330f4d"

	var/midnight_range = 2
	var/midnight_power = 0.80
	var/midnight_color = "#010103"

	var/last_color = "#FFFFFF"
	var/last_alpha = 1
	/// The linked map zone of our controller
	var/datum/map_zone/mapzone
	/// Areas to be affected by changing time of day
	var/list/affected_areas = list()

/datum/day_night_controller/New(datum/map_zone/passed_mapzone)
	. = ..()
	mapzone = passed_mapzone
	mapzone.day_night_controller = src
	SSday_night.day_night_controllers += src

	//Compile the lookup tables
	compile_transition(midnight_color, midnight_light, noon_color, noon_range, 0)
	compile_transition(noon_color, noon_range, midday_color, noon_light, VALUES_PER_TRANSITION)
	compile_transition(midday_color, noon_light, evening_color, midday_light, VALUES_PER_TRANSITION*2)
	compile_transition(evening_color, midday_light, sunset_color, evening_light, VALUES_PER_TRANSITION*3)
	compile_transition(sunset_color, evening_light, night_color, night_light, VALUES_PER_TRANSITION*4)
	compile_transition(night_color, night_light, midnight_color, midnight_light, VALUES_PER_TRANSITION*5)

/datum/day_night_controller/proc/compile_transition(color1, light1, color2, light2, start_index)
	var/my_index = start_index + 1
	var/transition_value = 0
	color_lookup_table["[my_index]"] = color1
	light_lookup_table["[my_index]"] = light1
	for(var/i in 1 to VALUES_PER_TRANSITION-1)
		my_index++
		transition_value += TRANSITION_VALUE
		var/next_color = BlendRGB(color1, color2, transition_value)
		var/next_light = (light1*(1-transition_value))+(light2*(0+transition_value))
		color_lookup_table["[my_index]"] = next_color
		light_lookup_table["[my_index]"] = next_light

/datum/day_night_controller/Destroy()
	free_areas()
	mapzone.day_night_controller = null
	mapzone = null
	SSday_night.day_night_controllers -= src
	return ..()

/datum/day_night_controller/process()
	update_areas()

/datum/day_night_controller/proc/update_areas()
	if(!length(affected_areas))
		build_areas() //Need to get it later because otherwise it wont get the areas, quirky stuff
	//Station time goes from 0 to 864000, which makes 600 a 1 minute
	var/time = station_time() / 600 / 60 //600 - minutes //60 - hours. We get from 0 to 24 here

	//We add a "tweak" offset to make the cycle more earth-like
	time += TWEAK_HOUR_SHIFT
	if(time < 0)
		time += 24

	time = time / 4 * VALUES_PER_TRANSITION //4 hours per transition and 5 transitions
	time = CEILING(time, 1)
	time = clamp(time, 1, ALL_TRANSITIONS)

	var/target_color = color_lookup_table["[time]"]
	var/target_light = light_lookup_table["[time]"]

	if(mapzone && mapzone.weather_controller)
		target_light *= (1-mapzone.weather_controller.skyblock)
		if(target_light < 0)
			target_light = 0

	target_light *= 255

	if(target_color == last_color && target_light == last_alpha)
		return

	remove_effect()


	last_color = target_color
	last_alpha = target_light

	for(var/area/my_area as anything in affected_areas)
		for(var/turf/open/affecting_turf as turf in my_area.contents)
			if(!istype(affecting_turf))
				continue
			SEND_SIGNAL(affecting_turf, COMSIG_OVERMAPTURF_UPDATE_LIGHT, target_light, target_power, target_color,)




/*
"#e6d9b5"
"#bf8e60"
"#995632"
"#6e182b"
"#611929"
"#330f4d"
"#130c2b"
"#060721"
"#010103"
"#1c1d3b"
*/
