
/*Cabin areas*/
/area/awaymission/cabin
	name = "Cabin"
	icon_state = "away2"
	requires_power = TRUE
	static_lighting = TRUE

/area/awaymission/cabin/snowforest
	name = "Snow Forest"
	icon_state = "away"
	static_lighting = FALSE
	base_lighting_alpha = 255

/area/awaymission/cabin/snowforest/sovietsurface
	name = "Snow Forest"
	icon_state = "awaycontent29"
	requires_power = FALSE

/area/awaymission/cabin/lumbermill
	name = "Lumbermill"
	icon_state = "away3"
	requires_power = FALSE
	static_lighting = FALSE
	base_lighting_alpha = 255

/area/awaymission/cabin/caves/sovietcave
	name = "Soviet Bunker"
	icon_state = "awaycontent4"

/area/awaymission/cabin/caves
	name = "North Snowdin Caves"
	icon_state = "awaycontent15"
	static_lighting = FALSE
	base_lighting_alpha = 255
	base_lighting_color = COLOR_WHITE

/area/awaymission/cabin/caves/mountain
	name = "North Snowdin Mountains"
	icon_state = "awaycontent24"

/obj/structure/firepit
	name = "firepit"
	desc = "Warm and toasty."
	icon = 'icons/obj/fireplace.dmi'
	icon_state = "firepit-active"
	density = FALSE
	var/active = TRUE

/obj/structure/firepit/Initialize()
	..()
	toggleFirepit()

/obj/structure/firepit/interact(mob/living/user)
	if(active)
		active = FALSE
		toggleFirepit()

/obj/structure/firepit/attackby(obj/item/W,mob/living/user,params)
	if(!active)
		var/msg = W.ignition_effect(src, user)
		if(msg)
			active = TRUE
			visible_message(msg)
			toggleFirepit()
		else
			return ..()
	else
		W.fire_act()

/obj/structure/firepit/proc/toggleFirepit()
	active = !active
	if(active)
		set_light(8)
		icon_state = "firepit-active"
	else
		set_light(0)
		icon_state = "firepit"

/obj/structure/firepit/extinguish()
	if(active)
		active = FALSE
		toggleFirepit()

/obj/structure/firepit/fire_act(exposed_temperature, exposed_volume)
	if(!active)
		active = TRUE
		toggleFirepit()



//other Cabin Stuff//

/obj/machinery/recycler/lumbermill
	name = "lumbermill saw"
	desc = "Faster then the cartoons!"
	obj_flags = CAN_BE_HIT | EMAGGED
	item_recycle_sound = 'sound/weapons/chainsawhit.ogg'

/obj/machinery/recycler/lumbermill/recycle_item(obj/item/grown/log/L)
	if(!istype(L))
		return
	else
		var/potency = L.seed.potency
		..()
		new L.plank_type(src.loc, 1 + round(potency / 25))

/mob/living/simple_animal/chicken/rabbit/normal
	icon_state = "b_rabbit"
	icon_living = "b_rabbit"
	icon_dead = "b_rabbit_dead"
	icon_prefix = "b_rabbit"
	minbodytemp = 0
	eggsleft = 0
	egg_type = null
	speak = list()
