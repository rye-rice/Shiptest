#define BAD_HIT_PENALTY 3

/obj/structure/anvil
	name = "anvil"
	desc = "An object with the intent to hammer metal against. One of the most important parts for forging an item."
	icon = 'icons/obj/forge_structures.dmi'
	icon_state = "anvil_empty"

	anchored = TRUE
	density = TRUE

	var/obj/item/forging/incomplete/current_hammered_item

/obj/structure/anvil/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/forging/hammer) && current_hammered_item)
		if(COOLDOWN_FINISHED(current_hammered_item, heating_remainder))
			to_chat(user, "<span class='warning'>You mess up, the metal was too cool!</span>")
			playsound(src, 'sound/misc/forge_fail.ogg', 50, TRUE)
			current_hammered_item.times_hit -= BAD_HIT_PENALTY
			return TRUE
		if(COOLDOWN_FINISHED(current_hammered_item, striking_cooldown))
			var/skill_modifier = user.mind.get_skill_modifier(/datum/skill/smithing, SKILL_SPEED_MODIFIER) * current_hammered_item.average_wait
			COOLDOWN_START(current_hammered_item, striking_cooldown, skill_modifier)
			current_hammered_item.times_hit++
			to_chat(user, "<span class='nicegreen'>You hit!</span>") //ReplaceWithBalloonAlertLater
			playsound(src, 'sound/misc/forge.ogg', 50, TRUE)
			user.mind.adjust_experience(/datum/skill/smithing, 1) //A good hit gives minimal experience
			if(current_hammered_item?.times_hit >= current_hammered_item.average_hits)
				to_chat(user, "<span class='notice'>The metal sounds ready.</span>")
			return TRUE
		current_hammered_item.times_hit -= BAD_HIT_PENALTY
		to_chat(user, "<span class='notice'>Bad hit!</span>") //ReplaceWithBalloonAlertLater
		playsound(src, 'sound/misc/forge_fail.ogg', 50, TRUE)
		if(current_hammered_item?.times_hit <= -(current_hammered_item.average_hits))
			to_chat(user, "<span class='warning'>The hits were too inconsistent-- the metal breaks!</span>")
			playsound(src, 'sound/misc/forge_break.ogg', 50, TRUE)
			icon_state = "anvil_empty"
			qdel(current_hammered_item)
		return TRUE

	if(istype(I, /obj/item/forging/tongs))
		var/obj/item/forging/forge_item = I
		if(forge_item.in_use)
			to_chat(user, "<span class='warning'>You cannot do multiple things at the same time!</span>")
			return
		var/obj/item/forging/incomplete/search_incomplete_item = locate(/obj/item/forging/incomplete) in I.contents
		if(current_hammered_item && !search_incomplete_item)
			current_hammered_item.forceMove(I)
			icon_state = "anvil_empty"
			I.icon_state = "tong_full"
			return TRUE
		if(!current_hammered_item && search_incomplete_item)
			search_incomplete_item.forceMove(src)
			icon_state = "anvil_full"
			I.icon_state = "tong_empty"
		return TRUE

	if(I.tool_behaviour == TOOL_WRENCH)
		new /obj/item/stack/sheet/metal/ten(get_turf(src))
		qdel(src)
		return

	return ..()

#undef BAD_HIT_PENALTY
