#define CAMOFLAUGE_CITY 0
#define CAMOFLAUGE_JUNGLE 1
#define CAMOFLAUGE_DESERT 2
#define CAMOFLAUGE_SNOW 3

/obj/item/stack/camoflauge
	name = "urban camoflauge"
	desc = "Now you see me, now you don't. Apply to fatigues, armor, or helmets for best results."
	icon = 'icons/obj/camoflauge.dmi'
	var/camo_type = CAMOFLAUGE_CITY
	max_amount = 10

/obj/item/stack/camoflauge/ten
	amount = 10

/obj/item/stack/camoflauge/jungle
	name = "jungle camoflauge"
	camo_type = CAMOFLAUGE_JUNGLE

/obj/item/stack/camoflauge/jungle/ten
	amount = 10

/obj/item/stack/camoflauge/desert
	name = "desert camoflauge"
	camo_type = CAMOFLAUGE_DESERT

/obj/item/stack/camoflauge/desert/ten
	amount = 10

/obj/item/stack/camoflauge/snow
	name = "snow camoflauge"
	camo_type = CAMOFLAUGE_SNOW

/obj/item/stack/camoflauge/snow/ten
	amount = 10

#undef CAMOFLAUGE_CITY
#undef CAMOFLAUGE_JUNGLE
#undef CAMOFLAUGE_DESERT
#undef CAMOFLAUGE_SNOW
