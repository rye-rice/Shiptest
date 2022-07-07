///camo component
/*
put this on a item to make it camo applyable

set the base_icon_state of a item, so then it can apply the prefix
if one is not found, it will simply use the icon_state
*/

#define CAMOFLAUGE_CITY 0
#define CAMOFLAUGE_JUNGLE 1
#define CAMOFLAUGE_DESERT 2
#define CAMOFLAUGE_SNOW 3

#define CAMOFLAUGE_CITY_SUFFIX ""
#define CAMOFLAUGE_JUNGLE_SUFFIX "_jungle"
#define CAMOFLAUGE_DESERT_SUFFIX "_desert"
#define CAMOFLAUGE_SNOW_SUFFIX "_snow"

/datum/component/camo
	var/current_camo = CAMOFLAUGE_CITY
	var/list/allowed_camos = list(CAMOFLAUGE_CITY, CAMOFLAUGE_JUNGLE, CAMOFLAUGE_DESERT, CAMOFLAUGE_SNOW)


/datum/component/camo/Initialize(current_camo, allowed_camos = list(CAMOFLAUGE_CITY, CAMOFLAUGE_JUNGLE, CAMOFLAUGE_DESERT, CAMOFLAUGE_SNOW))
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE
	if(!parent.base_icon_state)
		parent.base_icon_state = parent.icon_state

	current_camo = current_camo
	allowed_camos = allowed_camos


/datum/component/camo/RegisterWithParent()
	RegisterSignal(parent, COMSIG_PARENT_ATTACKBY, .proc/apply_camo)

/datum/component/camo/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_PARENT_ATTACKBY)


/datum/component/camo/proc/apply_camo(datum/source, obj/item/attacked_by, mob/user)
	var/obj/item/stack/camoflauge/camo_being_applied
	if(!istype(/obj/item/stack/camoflauge))
		return

	camo_being_applied = attacked_by

	if(!(camo_being_applied.camo_type in allowed_camos))
		to_chat(user, "<span class='danger'>You can't apply [attacked_by] to [parent]!</span>")
		return

	user.visible_message(user,"<span class='notice'>[user] starts applying [attacked_by] to [parent].</span>", \
					"<span class='notice'>You start applying [attacked_by] to [parent]...</span>")
	if(do_after(user, 3 SECONDS, target = parent))
		finish_apply_camo(camo_type)


/datum/component/camo/proc/finish_apply_camo(camo_type)
	switch(camo_type)
		if(CAMOFLAUGE_CITY)
			parent.icon_state = "[parent.base_icon_state][CAMOFLAUGE_CITY_SUFFIX]"
		if(CAMOFLAUGE_JUNGLE)
			parent.icon_state = "[parent.base_icon_state][CAMOFLAUGE_JUNGLE_SUFFIX]"
		if(CAMOFLAUGE_DESERT)
			parent.icon_state = "[parent.base_icon_state][CAMOFLAUGE_DESERT_SUFFIX]"
		if(CAMOFLAUGE_SNOW)
			parent.icon_state = "[parent.base_icon_state][CAMOFLAUGE_SNOW_SUFFIX]"

#undef CAMOFLAUGE_CITY
#undef CAMOFLAUGE_JUNGLE
#undef CAMOFLAUGE_DESERT
#undef CAMOFLAUGE_SNOW

#undef CAMOFLAUGE_CITY_SUFFIX
#undef CAMOFLAUGE_JUNGLE_SUFFIX
#undef CAMOFLAUGE_DESERT_SUFFIX
#undef CAMOFLAUGE_SNOW_SUFFIX
