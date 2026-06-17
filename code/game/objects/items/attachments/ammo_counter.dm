/obj/item/attachment/ammo_counter
	name = "ammunition counter"
	desc = "A computerized ammunition tracker for use on high-tech firearms, repurposed from a broken E-40. Includes a small toggle for telling the user when ammo is depleted. Capable of mounting on a gun's scope rail; it however blocks the ironsights, which makes it slightly harder to aim when in the scope slot.\
	\nMany 'lower-tech' firearms do not include the nessary components to interface with it, so it's availbility is limited."
	icon_state = "ammo_counter"

	attach_features_flags = ATTACH_REMOVABLE_HAND|ATTACH_TOGGLE
	//consider making th is scope only if during testing
	slot = ATTACHMENT_SLOT_SCOPE
	pixel_shift_x = 1
	pixel_shift_y = 0
	size_mod = 0
	spread_mod = 2
	var/alarm_sound_path = 'sound/weapons/gun/general/empty_alarm.ogg' //yes this exists so i can varedit it

/obj/item/attachment/ammo_counter/apply_attachment(obj/item/gun/gun, mob/user)
	. = ..()
	if(istype(gun, /obj/item/gun/ballistic))
		var/obj/item/gun/ballistic/ammo_gun = gun
		if(!ammo_gun.ammo_counter)
			ammo_gun.ammo_counter = TRUE
			gun.empty_alarm_sound = alarm_sound_path
			var/datum/component/ammo_hud/counter/our_counter = gun.AddComponent(/datum/component/ammo_hud/counter)
			our_counter.wake_up()
			return TRUE
		to_chat(user, span_notice("[gun] already has an ammo counter installed!"))
		return FALSE

/obj/item/attachment/ammo_counter/remove_attachment(obj/item/gun/gun, mob/user)
	. = ..()
	if(istype(gun, /obj/item/gun/ballistic))
		var/obj/item/gun/ballistic/ammo_gun = gun
		if(ammo_gun.ammo_counter)
			ammo_gun.ammo_counter = FALSE
			gun.empty_alarm_sound = gun::empty_alarm_sound
			var/datum/component/ammo_hud/counter/our_counter = gun.GetComponent(/datum/component/ammo_hud/counter)
			our_counter.turn_off()
			qdel(our_counter)
			return TRUE

/obj/item/attachment/ammo_counter/toggle_attachment(obj/item/gun/gun, mob/user)
	. = ..()

	if(gun::empty_alarm)
		return
	gun.empty_alarm = !gun.empty_alarm
	gun.empty_alarm_vary = !gun.empty_alarm_vary


