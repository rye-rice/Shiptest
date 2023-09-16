/obj/projectile/bullet
	name = "bullet"
	icon_state = "gauss"
	damage = 60
	speed = 0.4
	damage_type = BRUTE
	nodamage = FALSE
	flag = "bullet"
	sharpness = SHARP_POINTY
	impact_effect_type = /obj/effect/temp_visual/impact_effect
	shrapnel_type = /obj/item/shrapnel/bullet
	embedding = list(embed_chance=15, fall_chance=2, jostle_chance=0, ignore_throwspeed_threshold=TRUE, pain_stam_pct=0.5, pain_mult=3, rip_time=10)
	wound_falloff_tile = -2
	embed_falloff_tile = -5
	wound_bonus = -20
	hitsound = "bullet_hit"
	hitsound_non_living = "bullet_impact"
	ricochet_sound = "bullet_bounce"
	impact_effect_type = /obj/effect/temp_visual/impact_effect
	ricochets_max = 5 //should be enough to scare the shit out of someone
	ricochet_chance = 30
	ricochet_decay_damage = 0.5 //shouldnt being reliable, but deadly enough to be careful if you accidentally hit an ally

/obj/projectile/bullet/smite
	name = "divine retribution"
	damage = 10
