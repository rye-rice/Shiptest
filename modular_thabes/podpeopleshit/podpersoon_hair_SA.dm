/datum/sprite_accessory/hair/pod
	icon = 'modular_thabes/podpeopleshit/podperson_hair.dmi'

/datum/sprite_accessory/hair/pod/ivy
	name = "Ivy (Podperson)"
	icon_state = "hair_ivy"

/datum/sprite_accessory/hair/pod/cabbage
	name = "Cabbage (Podperson)"
	icon_state = "hair_cabbage"

/datum/sprite_accessory/hair/pod/spinach
	name = "Spinach (Podperson)"
	icon_state = "hair_spinach"

/datum/sprite_accessory/hair/pod/prayer
	name = "Prayer (Podperson)"
	icon_state = "hair_prayer"

/datum/sprite_accessory/hair/pod/vine
	name = "Vine (Podperson)"
	icon_state = "hair_vine"

/datum/sprite_accessory/hair/pod/shrub
	name = "Shrub (Podperson)"
	icon_state = "hair_shrub"

/datum/sprite_accessory/hair/pod/rose
	name = "Rose (Podperson)"
	icon_state = "hair_rose"

/datum/sprite_accessory/hair/pod/orchid
	name = "Orchid (Podperson)"
	icon_state = "hair_orchid"

/datum/sprite_accessory/hair/pod/fig
	name = "Fig (Podperson)"
	icon_state = "hair_fig"

/datum/sprite_accessory/hair/pod/hibiscus
	name = "Hibiscus (Podperson)"
	icon_state = "hair_hibiscus"

//while im here, heres some custom code for an event i wanna run

/turf/open/floor/plating/asteroid/dirt
	gender = PLURAL
	name = "dirt"
	desc = "It's quite dirty."
	icon = 'icons/turf/floors.dmi'
	base_icon_state = "dirt"
	icon_state = "dirt"
	planetary_atmos = FALSE
	footstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SAND
	clawfootstep = FOOTSTEP_SAND
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	tiled_dirt = TRUE
	baseturfs = /turf/open/floor/plating/asteroid/dirt
	floor_variance = 0
	var/update_lighting_on_init = TRUE
	var/has_grass = FALSE

/turf/open/floor/plating/asteroid/dirt/examine(mob/user)
	. = ..()
	if(has_grass)
		return
	if(ismob(user, /datum/species/pod))
		. += "<span class='notice'>While this plot of land is now farmable and fertile, theres nothing growing on it. Perhaps you could add <i>grass?</i></span>"

/turf/open/floor/plating/asteroid/dirt/Initialize(mapload, inherited_virtual_z)
	. = ..()
	if(smoothing_flags)
		var/matrix/translation = new
		translation.Translate(-9, -9)
		transform = translation
	if(!update_lighting_on_init)
		return
	var/area/selected_area = get_area(src)
	if(istype(selected_area, /area/overmap_encounter) && !istype(selected_area, /area/overmap_encounter/planetoid/cave)) //cheap trick, but i dont want to automate this shit
		light_range = 2
		light_power = 0.80
		update_light()

/turf/open/floor/plating/asteroid/dirt/attackby(obj/item/item_attacked_by, mob/user, params)
	. = ..()
	if(has_grass)
		return
	if(!istype(item_attacked_by, /obj/item/reagent_containers/food/snacks/grown/grass))
		return FALSE
	var/grass_to_plant = /turf/open/floor/plating/asteroid/dirt/grass

	if(istype(item_attacked_by, /obj/item/reagent_containers/food/snacks/grown/grass/fairy))
		grass_to_plant = /turf/open/floor/plating/asteroid/dirt/grass/fairy

	visible_message("<span class='notice'>You plant the [item_attacked_by], and the dirt accepts it. It should be breathable now.</span>")
	qdel(item_attacked_by)
	ChangeTurf(grass_to_plant, flags = CHANGETURF_IGNORE_AIR)


/turf/open/floor/plating/asteroid/dirt/getDug()
	. = ..()
	ScrapeAway()

/turf/open/floor/plating/asteroid/dirt/burn_tile()
	ScrapeAway()
	return TRUE

/turf/open/floor/plating/asteroid/dirt/ex_act(severity, target)
	. = ..()
	ScrapeAway()

/turf/open/floor/plating/asteroid/dirt/grass
	name = "grass"
	desc = "A patch of grass."
	icon_state = "grass0"
	base_icon_state = "grass"
	bullet_bounce_sound = null
	footstep = FOOTSTEP_GRASS
	barefootstep = FOOTSTEP_GRASS
	clawfootstep = FOOTSTEP_GRASS
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_TURF_OPEN, SMOOTH_GROUP_FLOOR_GRASS)
	canSmoothWith = list(SMOOTH_GROUP_CLOSED_TURFS, SMOOTH_GROUP_FLOOR_GRASS)
	layer = HIGH_TURF_LAYER
	icon = 'icons/turf/floors/grass.dmi'
	planetary_atmos = TRUE
	baseturfs = /turf/open/floor/plating/asteroid/dirt
	floor_variance = 100
	max_icon_states = 3
	tiled_dirt = FALSE
	update_lighting_on_init = TRUE
	has_grass = TRUE

/turf/open/floor/plating/asteroid/dirt/grass/fairy
	light_range = 2
	light_power = 0.80
	light_color = COLOR_BLUE_LIGHT
	update_lighting_on_init = FALSE

/turf/open/floor/plating/asteroid/basalt/lava_land_surface/basin
	name = "dried basin"
	desc = "Dried up basin."
	icon_state = "dried_up"
	icon_plating = "dried_up"
	base_icon_state = "dried_up"
	digResult = /obj/item/stack/ore/glass/basalt
	initial_gas_mix = LAVALAND_DEFAULT_ATMOS
	planetary_atmos = TRUE
	baseturfs = /turf/open/floor/plating/asteroid/basalt/lava_land_surface/basin
	var/update_lighting_on_init = TRUE
	var/current_water = 0 //yeah

/turf/open/floor/plating/asteroid/basalt/lava_land_surface/basin/examine(mob/user)
	. = ..()
	if(ismob(user, /datum/species/pod))
		. += "<span class='notice'>It could hold water, maybe 50 units per meter could do the trick. Currently, it has <i>[current_water]</i> units.</span>"

/turf/open/floor/plating/asteroid/basalt/lava_land_surface/basin/Initialize(mapload, inherited_virtual_z) //inheritance moment
	. = ..()
	if(!update_lighting_on_init)
		return
	var/area/selected_area = get_area(src)
	if(istype(selected_area, /area/overmap_encounter) && !istype(selected_area, /area/overmap_encounter/planetoid/cave)) //cheap trick, but i dont want to automate this shit
		light_range = 2
		light_power = 0.80
		update_light()

/turf/open/floor/plating/asteroid/sand/terraform
	light_color = LIGHT_COLOR_TUNGSTEN
	var/update_lighting_on_init = TRUE

/turf/open/floor/plating/asteroid/sand/terraform/Initialize(mapload, inherited_virtual_z) //inheritance moment
	. = ..()
	if(!update_lighting_on_init)
		return
	var/area/selected_area = get_area(src)
	if(istype(selected_area, /area/overmap_encounter) && !istype(selected_area, /area/overmap_encounter/planetoid/cave)) //cheap trick, but i dont want to automate this shit
		light_range = 2
		light_power = 0.80
		update_light()


//the ultimate fertilizer
/datum/reagent/genesis
	name = "Genesis Serum"
	description = "A mysterious substance capable of spontaneously gestating plant life when given a surface to adhere to."
	color = "#328242"
	taste_description = "primordial essence"
	reagent_state = LIQUID
	var/list/turf_whitelist = list(
	/turf/open/floor/plating/asteroid,
	/turf/open/lava,
	/turf/open/acid,
	/turf/open/floor/plating/moss,
	/turf/open/floor/plating/grass
	)

/datum/reagent/genesis/expose_turf(turf/exposed_turf, reac_volume)
	var/allowed = FALSE //idk how to do this better
	for(var/turf/checked_turf as anything in turf_whitelist)
		if(!istype(exposed_turf, checked_turf))
			continue
		else
			allowed = TRUE
			break
	if(!allowed)
		return ..()

	if(isopenturf(exposed_turf))
		var/turf/open/floor/terraform_target = exposed_turf

		if(istype(terraform_target, /turf/open/lava) || istype(terraform_target, /turf/open/acid)) //if hazard, reeplace with basin
			if(istype(terraform_target, /turf/open/lava))
				terraform_target.ChangeTurf(/turf/open/floor/plating/asteroid/basalt/lava_land_surface/basin, flags = CHANGETURF_INHERIT_AIR)
			if(istype(terraform_target, /turf/open/acid))
				terraform_target.ChangeTurf(/turf/open/floor/plating/asteroid/whitesands/dried, flags = CHANGETURF_INHERIT_AIR)
			terraform_target.visible_message("<span class='notice'>As the serum touches [terraform_target.name], it all starts drying up, leaving a dry basin behind!</span>")
			playsound(exposed_turf, 'sound/effects/bubbles.ogg', 50)
			return ..()

		if(istype(terraform_target, /turf/open/floor/plating/asteroid/basalt/lava_land_surface/basin) || istype(terraform_target, /turf/open/floor/plating/asteroid/whitesands/dried)|| istype(terraform_target, /turf/open/floor/plating/asteroid/sand)) //if basin, replace with water
			return ..()

		if(istype(terraform_target, /turf/open/floor/plating/asteroid/purple))
			terraform_target.ChangeTurf(/turf/open/floor/plating/asteroid/sand/terraform, flags = CHANGETURF_INHERIT_AIR)
			terraform_target.visible_message("<span class='notice'>The chemicals in the sand disolve, and the sand looks more natural.</span>")
			playsound(exposed_turf, 'sound/effects/bubbles.ogg', 50)
			return ..()

		if(!istype(terraform_target, /turf/open/floor/plating/asteroid/dirt)) // if not dirt, acutally terraform
			terraform_target.ChangeTurf(/turf/open/floor/plating/asteroid/dirt, flags = CHANGETURF_INHERIT_AIR)
			terraform_target.visible_message("<span class='notice'>The harsh land becomes fertile dirt, but more work needs to be done for it to be growable and breathable. Perhaps add grass?</span>")
			playsound(exposed_turf, 'sound/effects/bubbles.ogg', 50)
			return ..()


		if(istype(terraform_target, /turf/open/floor/plating/asteroid/dirt/grass)) //if grass, plant shit
			for(var/obj/object as anything in terraform_target.contents)
				if(!istype(object, /obj/structure/flora))
					continue
				terraform_target.visible_message("<span class='danger'>Theres already flora on the tile!</span>")
				return ..()

			terraform_target.visible_message("<span class='notice'>As the serum touches the grass, suddenly flora grows out of it!</span>")
			playsound(exposed_turf, 'sound/effects/bubbles.ogg', 50)
			if(prob(70))
				new /obj/effect/spawner/lootdrop/flower(exposed_turf)
			else if(prob(5))
				new /obj/structure/flora/ash/garden(exposed_turf)
			else
				new /obj/effect/spawner/lootdrop/flora(exposed_turf)

	return ..()

/datum/reagent/water/expose_turf(turf/exposed_turf, reac_volume)
	if(!isopenturf(exposed_turf))
		return ..()
	var/turf/open/floor/plating/asteroid/basalt/lava_land_surface/basin/terraform_target = exposed_turf

	if(istype(terraform_target,  /turf/open/floor/plating/asteroid/basalt/lava_land_surface/basin) || istype(terraform_target, /turf/open/floor/plating/asteroid/whitesands/dried)) //if basin, replace with water
		terraform_target.current_water += reac_volume
		if(terraform_target.current_water >= 50)
			terraform_target.ChangeTurf(/turf/open/water/beach, flags = CHANGETURF_INHERIT_AIR)
			terraform_target.visible_message("<span class='notice'>The [terraform_target.name] fills up with water!</span>")
			return ..()
		else
			terraform_target.visible_message("<span class='notice'>The [terraform_target.name] is filled up with [terraform_target.current_water] units of water.</span>")
			return ..()

/datum/reagent/water/expose_obj(obj/exposed_object, reac_volume)
	. = ..()
	if(istype(exposed_object, /obj/structure/flora/rock/lava) || istype(exposed_object, /obj/structure/flora/rock/pile/lava))
		exposed_object.icon = 'icons/obj/flora/rocks.dmi'
		exposed_object.visible_message("<span class='notice'>[src]cools down.</span>")

/obj/structure/flora/rock/lava/examine(mob/user)
	. = ..()
	if(ismob(user, /datum/species/pod))
		. += "<span class='notice'>If I pour some <i>water</i> onto it, maybe it can cool down?</span>"


/obj/structure/flora/rock/pile/lava/examine(mob/user)
	. = ..()
	if(ismob(user, /datum/species/pod))
		. += "<span class='notice'>If I pour some <i>water</i> onto it, maybe it can cool down?</span>"
