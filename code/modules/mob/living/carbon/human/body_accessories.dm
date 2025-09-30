
GLOBAL_LIST_INIT(body_accessory_by_name, list("None" = null))
GLOBAL_LIST_INIT(body_accessory_by_species, list())

/proc/initialize_body_accessory_by_species()
	for(var/B in GLOB.body_accessory_by_name)
		var/datum/body_accessory/accessory = GLOB.body_accessory_by_name[B]
		if(!istype(accessory))	continue

		for(var/species in accessory.allowed_species)
			if(!GLOB.body_accessory_by_species["[species]"])
				GLOB.body_accessory_by_species["[species]"] = list()
			GLOB.body_accessory_by_species["[species]"]["[accessory.name]"] = accessory

	if(GLOB.body_accessory_by_species.len)
		return TRUE
	return FALSE

/proc/__init_body_accessory(ba_path)
	if(ispath(ba_path))
		var/_added_counter = 0

		for(var/A in subtypesof(ba_path))
			var/datum/body_accessory/B = new A
			if(istype(B))
				GLOB.body_accessory_by_name[B.name] += B
				++_added_counter

		if(_added_counter)
			return TRUE
	return FALSE

/datum/body_accessory
	var/name = "default"

	var/icon = null
	var/icon_state = ""

	var/animated_icon = null
	var/animated_icon_state = ""

	var/blend_mode = null

	var/pixel_x_offset = 0
	var/pixel_y_offset = 0

	var/list/allowed_species = list()
	/// If true, adds an underlay (in addition to the regular overlay!) to the character sprite, with the state "[icon_state]_BEHIND".
	var/has_behind = FALSE

/datum/body_accessory/proc/try_restrictions(mob/living/carbon/human/H)
	return (H.dna.species.name in allowed_species)

/datum/body_accessory/proc/get_animated_icon() //return animated if it has it, return static if it does not.
	if(animated_icon)
		return animated_icon

	else	return icon

/datum/body_accessory/proc/get_animated_icon_state()
	if(animated_icon_state)
		return animated_icon_state

	else	return icon_state


//Bodies
/datum/body_accessory/body
	blend_mode = ICON_MULTIPLY

//Tails
/datum/body_accessory/tail
	icon = 'icons/mob/clothing/body_accessory.dmi'
	animated_icon = 'icons/mob/clothing/body_accessory.dmi'
	blend_mode = ICON_ADD
	icon_state = "null"
	animated_icon_state = "null"

/datum/body_accessory/tail/try_restrictions(mob/living/carbon/human/H)
	if(H.wear_suit && (H.wear_suit.flags_inv & HIDETAIL))
		return FALSE
	return ..()

//Tajaran
/datum/body_accessory/tail/leopard_tail
	name = "Leopard Tail"
	icon_state = "leopard"
	animated_icon_state = "leopard_a"
	allowed_species = list(SPECIES_TAJARAN)

/datum/body_accessory/tail/tiny //Pretty ambiguous as to what species it belongs to, tail could've been injured or docked.
	name = "Tiny Tail"
	icon_state = "tiny"
	animated_icon_state = "tiny_a"
	allowed_species = list(SPECIES_TAJARAN)

/datum/body_accessory/tail/short //Same as above.
	name = "Short Tail"
	icon_state = "short"
	animated_icon_state = "short_a"
	allowed_species = list(SPECIES_TAJARAN)