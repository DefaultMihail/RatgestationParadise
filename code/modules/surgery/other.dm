//Procedures in this file: Inernal wound patching, Implant removal.
//////////////////////////////////////////////////////////////////
//					INTERNAL WOUND PATCHING						//
//////////////////////////////////////////////////////////////////

/datum/surgery/infection
	name = "External Infection Treatment"
	steps = list(/datum/surgery_step/generic/cut_open, /datum/surgery_step/generic/cauterize)
	possible_locs = list(
		BODY_ZONE_CHEST,
		BODY_ZONE_HEAD,
		BODY_ZONE_L_ARM,
		BODY_ZONE_PRECISE_L_HAND,
		BODY_ZONE_R_ARM,
		BODY_ZONE_PRECISE_R_HAND,
		BODY_ZONE_R_LEG,
		BODY_ZONE_PRECISE_R_FOOT,
		BODY_ZONE_L_LEG,
		BODY_ZONE_PRECISE_L_FOOT,
		BODY_ZONE_PRECISE_GROIN,
		BODY_ZONE_TAIL,
		BODY_ZONE_WING,
	)

/datum/surgery/bleeding
	name = "Internal Bleeding"
	steps = list(
		/datum/surgery_step/generic/cut_open,
		/datum/surgery_step/generic/clamp_bleeders,
		/datum/surgery_step/generic/retract_skin,
		/datum/surgery_step/proxy/open_organ,
		/datum/surgery_step/generic/cauterize
	)
	possible_locs = list(
		BODY_ZONE_L_ARM,
		BODY_ZONE_PRECISE_L_HAND,
		BODY_ZONE_R_ARM,
		BODY_ZONE_PRECISE_R_HAND,
		BODY_ZONE_R_LEG,
		BODY_ZONE_PRECISE_R_FOOT,
		BODY_ZONE_L_LEG,
		BODY_ZONE_PRECISE_L_FOOT,
		BODY_ZONE_TAIL,
		BODY_ZONE_WING,
	)
	restricted_speciestypes = list(/datum/species/plasmaman)

/datum/surgery/bleeding/special
	name = "Internal Bleeding"
	steps = list(
		/datum/surgery_step/generic/cut_open,
		/datum/surgery_step/generic/clamp_bleeders,
		/datum/surgery_step/generic/retract_skin,
		/datum/surgery_step/proxy/open_organ,
		/datum/surgery_step/generic/cauterize
	)
	possible_locs = list(
		BODY_ZONE_CHEST,
		BODY_ZONE_HEAD,
		BODY_ZONE_PRECISE_GROIN,
	)

/datum/surgery/bleeding/plasmaman
	name = "Plasmaman Internal Bleeding"
	steps = list(
		/datum/surgery_step/generic/cut_open,
		/datum/surgery_step/generic/clamp_bleeders,
		/datum/surgery_step/generic/retract_skin,
		/datum/surgery_step/proxy/open_organ/plasma,
		/datum/surgery_step/generic/cauterize
	)
	possible_locs = list(
		BODY_ZONE_CHEST,
		BODY_ZONE_HEAD,
		BODY_ZONE_L_ARM,
		BODY_ZONE_PRECISE_L_HAND,
		BODY_ZONE_R_ARM,
		BODY_ZONE_PRECISE_R_HAND,
		BODY_ZONE_R_LEG,
		BODY_ZONE_PRECISE_R_FOOT,
		BODY_ZONE_L_LEG,
		BODY_ZONE_PRECISE_L_FOOT,
		BODY_ZONE_PRECISE_GROIN,
		BODY_ZONE_TAIL,
		BODY_ZONE_WING,
	)
	target_speciestypes = list(/datum/species/plasmaman)
	restricted_speciestypes = null

/datum/surgery/debridement
	name = "Debridement"
	steps = list(
		/datum/surgery_step/generic/cut_open,
		/datum/surgery_step/generic/clamp_bleeders,
		/datum/surgery_step/generic/retract_skin,
		/datum/surgery_step/proxy/open_organ,
		/datum/surgery_step/fix_dead_tissue,
		/datum/surgery_step/treat_necrosis,
		/datum/surgery_step/generic/cauterize
	)
	possible_locs = list(
		BODY_ZONE_CHEST,
		BODY_ZONE_HEAD,
		BODY_ZONE_L_ARM,
		BODY_ZONE_PRECISE_L_HAND,
		BODY_ZONE_R_ARM,
		BODY_ZONE_PRECISE_R_HAND,
		BODY_ZONE_R_LEG,
		BODY_ZONE_PRECISE_R_FOOT,
		BODY_ZONE_L_LEG,
		BODY_ZONE_PRECISE_L_FOOT,
		BODY_ZONE_PRECISE_GROIN,
		BODY_ZONE_TAIL,
		BODY_ZONE_WING,
	)
	requires_organic_bodypart = TRUE

/datum/surgery/bleeding/can_start(mob/user, mob/living/carbon/target)
	. = ..()
	if(!.)
		return FALSE
	var/obj/item/organ/external/affected = target.get_organ(user.zone_selected)
	if(affected.has_internal_bleeding())
		return TRUE
	return FALSE


/datum/surgery/debridement/can_start(mob/user, mob/living/carbon/target)
	. = ..()
	if(!.)
		return FALSE
	var/obj/item/organ/external/affected = target.get_organ(user.zone_selected)
	if(!affected.is_dead())
		return FALSE
	return TRUE


/datum/surgery_step/fix_vein
	name = "mend internal bleeding"
	begin_sound = 'sound/surgery/fixovein1.ogg'
	end_sound = 'sound/surgery/hemostat1.ogg'
	fail_sound = 'sound/effects/meatslap.ogg'
	allowed_tools = list(
		TOOL_FIXOVEIN = 100,
		/obj/item/stack/cable_coil = 90,
		/obj/item/stack/sheet/sinew = 90
	)
	can_infect = TRUE
	blood_level = SURGERY_BLOODSPREAD_HANDS

	time = 3.2 SECONDS

/datum/surgery_step/fix_vein/begin_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, datum/surgery/surgery)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(!affected.has_internal_bleeding())
		to_chat(user, span_notice("The veins in [affected] seem to be in perfect shape!"))
		return SURGERY_BEGINSTEP_SKIP

	user.visible_message(
		"[user] starts patching the damaged vein in [target]'s [affected.name] with \the [tool].",
		"You start patching the damaged vein in [target]'s [affected.name] with \the [tool].",
		chat_message_type = MESSAGE_TYPE_COMBAT
	)
	target.custom_pain("The pain in your [affected.name] is unbearable!")
	return ..()


/datum/surgery_step/fix_vein/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, datum/surgery/surgery)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		span_notice("[user] has patched the damaged vein in [target]'s [affected.name] with \the [tool]."),
		span_notice("You have patched the damaged vein in [target]'s [affected.name] with \the [tool]."),
		chat_message_type = MESSAGE_TYPE_COMBAT
	)

	affected.stop_internal_bleeding()
	if(ishuman(user) && prob(40))
		var/mob/living/carbon/human/U = user
		U.bloody_hands(target, 0)

	return SURGERY_STEP_CONTINUE

/datum/surgery_step/fix_vein/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, datum/surgery/surgery)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		span_warning("[user]'s hand slips, smearing [tool] in the incision in [target]'s [affected.name]!"),
		span_warning("Your hand slips, smearing [tool] in the incision in [target]'s [affected.name]!"),
		chat_message_type = MESSAGE_TYPE_COMBAT
	)
	target.apply_damage(5, def_zone = affected)
	return SURGERY_STEP_RETRY

/datum/surgery_step/fix_dead_tissue		//Debridement
	name = "remove dead tissue"
	begin_sound = 'sound/surgery/scalpel1.ogg'
	end_sound = 'sound/surgery/scalpel2.ogg'
	fail_sound = 'sound/effects/meatslap.ogg'
	allowed_tools = list(
		TOOL_SCALPEL = 100,
		/obj/item/kitchen/knife = 90,
		/obj/item/shard = 60
	)

	can_infect = TRUE
	blood_level = SURGERY_BLOODSPREAD_HANDS

	time = 1.6 SECONDS

/datum/surgery_step/fix_dead_tissue/begin_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, datum/surgery/surgery)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		"[user] starts cutting away necrotic tissue in [target]'s [affected.name] with \the [tool].",
		"You start cutting away necrotic tissue in [target]'s [affected.name] with \the [tool].",
		chat_message_type = MESSAGE_TYPE_COMBAT
	)
	target.custom_pain("The pain in [affected.name] is unbearable!")
	return ..()

/datum/surgery_step/fix_dead_tissue/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, datum/surgery/surgery)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		span_notice("[user] has cut away necrotic tissue in [target]'s [affected.name] with \the [tool]."),
		span_notice("You have cut away necrotic tissue in [target]'s [affected.name] with \the [tool]."),
		chat_message_type = MESSAGE_TYPE_COMBAT
	)
	affected.open = ORGAN_ORGANIC_OPEN

	return SURGERY_STEP_CONTINUE

/datum/surgery_step/fix_dead_tissue/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, datum/surgery/surgery)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		span_warning("[user]'s hand slips, slicing an artery inside [target]'s [affected.name] with \the [tool]!"),
		span_warning("Your hand slips, slicing an artery inside [target]'s [affected.name] with \the [tool]!"),
		chat_message_type = MESSAGE_TYPE_COMBAT
	)
	target.apply_damage(20, def_zone = affected)
	return SURGERY_STEP_RETRY

/datum/surgery_step/treat_necrosis
	name = "treat necrosis"
	allowed_tools = list(
		/obj/item/reagent_containers/dropper = 100,
		/obj/item/reagent_containers/glass/bottle = 90,
		/obj/item/reagent_containers/food/drinks/drinkingglass = 85,
		/obj/item/reagent_containers/food/drinks/bottle = 80,
		/obj/item/reagent_containers/glass/beaker = 75,
		/obj/item/reagent_containers/spray = 60,
		/obj/item/reagent_containers/glass/bucket = 50
	)

	can_infect = FALSE
	blood_level = SURGERY_BLOODSPREAD_NONE

	time = 2.4 SECONDS


/datum/surgery_step/treat_necrosis/tool_check(mob/user, obj/item/tool)
	. = ..()
	if(!.)
		return FALSE
	var/obj/item/reagent_containers/container = tool
	if(!container.reagents.has_reagent("mitocholide"))
		user.visible_message(
			"[user] looks at \the [tool] and ponders.",
			"You are not sure if \the [tool] contains the mitocholide necessary to treat the necrosis.",
			chat_message_type = MESSAGE_TYPE_COMBAT
			)
		return FALSE

/datum/surgery_step/treat_necrosis/begin_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, datum/surgery/surgery)

	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	if(!(affected.is_dead()))
		to_chat(user, span_warning("The [affected] seems to already be in fine condition!"))
		return SURGERY_BEGINSTEP_SKIP

	user.visible_message(
		"[user] starts applying medication to the affected tissue in [target]'s [affected.name] with \the [tool].",
		"You start applying medication to the affected tissue in [target]'s [affected.name] with \the [tool].",
		chat_message_type = MESSAGE_TYPE_COMBAT
	)
	target.custom_pain("Something in your [affected.name] is causing you a lot of pain!")
	return ..()

/datum/surgery_step/treat_necrosis/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, datum/surgery/surgery)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	var/obj/item/reagent_containers/container = tool
	var/mitocholide = FALSE

	if(container.reagents.has_reagent("mitocholide"))
		mitocholide = TRUE

	var/trans = container.reagents.trans_to(target, container.amount_per_transfer_from_this)
	if(trans > 0)
		container.reagents.reaction(target, REAGENT_INGEST)	//technically it's contact, but the reagents are being applied to internal tissue

		if(mitocholide)
			affected.unnecrotize()

		user.visible_message(
			span_notice("[user] applies [trans] units of the solution to affected tissue in [target]'s [affected.name]"),
			span_notice("You apply [trans] units of the solution to affected tissue in [target]'s [affected.name] with \the [tool]."),
			chat_message_type = MESSAGE_TYPE_COMBAT
		)

	return SURGERY_STEP_CONTINUE

/datum/surgery_step/treat_necrosis/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, datum/surgery/surgery)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	if(!istype(tool, /obj/item/reagent_containers))
		return SURGERY_STEP_INCOMPLETE

	var/obj/item/reagent_containers/container = tool

	var/trans = container.reagents.trans_to(target, container.amount_per_transfer_from_this)
	container.reagents.reaction(target, REAGENT_INGEST)	//technically it's contact, but the reagents are being applied to internal tissue

	user.visible_message(
		span_warning("[user]'s hand slips, applying [trans] units of the solution to the wrong place in [target]'s [affected.name] with the [tool]!"),
		span_warning("Your hand slips, applying [trans] units of the solution to the wrong place in [target]'s [affected.name] with the [tool]!"),
		chat_message_type = MESSAGE_TYPE_COMBAT
	)

	//no damage or anything, just wastes medicine
	return SURGERY_STEP_RETRY