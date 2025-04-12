/datum/species/monkey
	name = SPECIES_MONKEY
	name_plural = "Monkeys"
	blurb = "Ook."

	icobase = 'icons/mob/human_races/monkeys/r_monkey.dmi'
	deform = 'icons/mob/human_races/monkeys/r_monkey.dmi'
	damage_overlays = 'icons/mob/human_races/masks/dam_monkey.dmi'
	damage_mask = 'icons/mob/human_races/masks/dam_mask_monkey.dmi'
	blood_mask = 'icons/mob/human_races/masks/blood_monkey.dmi'
	language = LANGUAGE_GALACTIC_COMMON
	default_language = LANGUAGE_MONKEY_HUMAN
	inherent_traits = list(
		TRAIT_HAS_REGENERATION,
		TRAIT_NO_SPECIES_EXAMINE,
		TRAIT_VENTCRAWLER_NUDE,
	)
	skinned_type = /obj/item/stack/sheet/animalhide/monkey
	greater_form = /datum/species/human
	no_equip = list(ITEM_SLOT_BELT, ITEM_SLOT_GLOVES)	//Риги и ЕВА тоже нельзя носить, но это размечено отдельно в одежде
	can_craft = FALSE
	is_monkeybasic = TRUE
	has_fine_manipulation = 0
	show_ssd = 0
	eyes = "blank_eyes"
	death_message = "изда%(ёт,ют)% тихий визг, пада%(ет,ют)% и переста%(ёт,ют)% двигаться..."

	scream_verb = "визж%(ит,ат)%"
	male_scream_sound = list('sound/goonstation/voice/monkey_scream.ogg')
	female_scream_sound = list('sound/goonstation/voice/monkey_scream.ogg')
	male_dying_gasp_sounds = list('sound/goonstation/voice/male_dying_gasp_1.ogg', 'sound/goonstation/voice/male_dying_gasp_2.ogg', 'sound/goonstation/voice/male_dying_gasp_3.ogg', 'sound/goonstation/voice/male_dying_gasp_4.ogg', 'sound/goonstation/voice/male_dying_gasp_5.ogg')
	female_dying_gasp_sounds = list('sound/goonstation/voice/female_dying_gasp_1.ogg', 'sound/goonstation/voice/female_dying_gasp_2.ogg', 'sound/goonstation/voice/female_dying_gasp_3.ogg', 'sound/goonstation/voice/female_dying_gasp_4.ogg', 'sound/goonstation/voice/female_dying_gasp_5.ogg')

	blood_species = "Human"
	tail = "chimptail"
	bodyflags = HAS_TAIL
	reagent_tag = PROCESS_ORG
	//Has standard darksight of 2.

	unarmed_type = /datum/unarmed_attack/bite

	total_health = 75
	brute_mod = 1.5
	burn_mod = 1.5

	meat_type = /obj/item/reagent_containers/food/snacks/meat/humanoid/monkey

	has_limbs = list(
		BODY_ZONE_CHEST = list("path" = /obj/item/organ/external/chest),
		BODY_ZONE_PRECISE_GROIN = list("path" = /obj/item/organ/external/groin),
		BODY_ZONE_HEAD = list("path" = /obj/item/organ/external/head),
		BODY_ZONE_L_ARM = list("path" = /obj/item/organ/external/arm),
		BODY_ZONE_R_ARM = list("path" = /obj/item/organ/external/arm/right),
		BODY_ZONE_L_LEG = list("path" = /obj/item/organ/external/leg),
		BODY_ZONE_R_LEG = list("path" = /obj/item/organ/external/leg/right),
		BODY_ZONE_PRECISE_L_HAND = list("path" = /obj/item/organ/external/hand),
		BODY_ZONE_PRECISE_R_HAND = list("path" = /obj/item/organ/external/hand/right),
		BODY_ZONE_PRECISE_L_FOOT = list("path" = /obj/item/organ/external/foot),
		BODY_ZONE_PRECISE_R_FOOT = list("path" = /obj/item/organ/external/foot/right),
		BODY_ZONE_TAIL = list("path" = /obj/item/organ/external/tail/monkey),
	)

/datum/species/monkey/get_random_name()
	return "[lowertext(name)] ([rand(100,999)])"


/datum/species/monkey/on_species_gain(mob/living/carbon/human/H)
	. = ..()
	H.real_name = "[lowertext(name)] ([rand(100,999)])"
	H.name = H.real_name
	H.meatleft = 5


/datum/species/monkey/on_species_loss(mob/living/carbon/human/H)
	. = ..()
	H.meatleft = initial(H.meatleft)


/datum/species/monkey/handle_dna(mob/living/carbon/human/H, remove)
	. = ..()
	H.force_gene_block(GLOB.monkeyblock, !remove)


/datum/species/monkey/can_understand(mob/other)
	return istype(other, /mob/living/simple_animal/hostile/gorilla)


/datum/species/monkey/tajaran
	name = SPECIES_FARWA
	name_plural = "Farwa"

	icobase = 'icons/mob/human_races/monkeys/r_farwa.dmi'
	deform = 'icons/mob/human_races/monkeys/r_farwa.dmi'

	greater_form = /datum/species/tajaran
	default_language = LANGUAGE_MONKEY_TAJARAN
	blood_species = "Tajaran"
	flesh_color = "#AFA59E"
	base_color = "#000000"
	tail = "farwatail"
	skinned_type = /obj/item/stack/sheet/animalhide/farwa
	reagent_tag = PROCESS_ORG

	has_organ = list(
		INTERNAL_ORGAN_HEART = /obj/item/organ/internal/heart/tajaran,
		INTERNAL_ORGAN_LUNGS = /obj/item/organ/internal/lungs/tajaran,
		INTERNAL_ORGAN_LIVER = /obj/item/organ/internal/liver/tajaran,
		INTERNAL_ORGAN_KIDNEYS = /obj/item/organ/internal/kidneys/tajaran,
		INTERNAL_ORGAN_BRAIN = /obj/item/organ/internal/brain/tajaran,
		INTERNAL_ORGAN_APPENDIX = /obj/item/organ/internal/appendix,
		INTERNAL_ORGAN_EYES = /obj/item/organ/internal/eyes/tajaran/farwa, //Tajara monkey-forms are uniquely colourblind and have excellent darksight, which is why they need a subtype of their greater-form's organ..
		INTERNAL_ORGAN_EARS = /obj/item/organ/internal/ears,
	)

	meat_type = /obj/item/reagent_containers/food/snacks/meat/humanoid/farwa

	has_limbs = list(
		BODY_ZONE_CHEST = list("path" = /obj/item/organ/external/chest),
		BODY_ZONE_PRECISE_GROIN = list("path" = /obj/item/organ/external/groin),
		BODY_ZONE_HEAD = list("path" = /obj/item/organ/external/head),
		BODY_ZONE_L_ARM = list("path" = /obj/item/organ/external/arm),
		BODY_ZONE_R_ARM = list("path" = /obj/item/organ/external/arm/right),
		BODY_ZONE_L_LEG = list("path" = /obj/item/organ/external/leg),
		BODY_ZONE_R_LEG = list("path" = /obj/item/organ/external/leg/right),
		BODY_ZONE_PRECISE_L_HAND = list("path" = /obj/item/organ/external/hand),
		BODY_ZONE_PRECISE_R_HAND = list("path" = /obj/item/organ/external/hand/right),
		BODY_ZONE_PRECISE_L_FOOT = list("path" = /obj/item/organ/external/foot),
		BODY_ZONE_PRECISE_R_FOOT = list("path" = /obj/item/organ/external/foot/right),
		BODY_ZONE_TAIL = list("path" = /obj/item/organ/external/tail/monkey/tajaran),
	)


/datum/species/monkey/tajaran/can_understand(mob/other)
	return
