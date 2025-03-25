/datum/ritual
	/// Linked object
	var/obj/ritual_object
	/// Name of our ritual
	var/name
	/// Description of our ritual. Later be used in tgui
	var/description
	/// Our fluff tgui name for dyes
	var/fluff_tgui_dye = "краска не нужна."
	/// If ritual requires more than one invoker
	var/extra_invokers = 0
	/// If invoker species isn't in allowed - he won't do ritual.
	var/list/allowed_species
	/// If invoker special role isn't in allowed - he won't do ritual.
	var/list/allowed_special_role
	/// Required to ritual invoke things are located here
	var/list/required_things
	/// We search for humans in that radius
	var/finding_range = DEFAULT_RITUAL_RANGE_FIND
	/// Amount of maximum ritual uses.
	var/charges = -1
	/// Cooldown for one ritual
	COOLDOWN_DECLARE(ritual_cooldown)
	/// Our cooldown after we casted ritual.
	var/cooldown_after_cast = DEFAULT_RITUAL_COOLDOWN
	/// If our ritual failed on proceed - we'll try to cause disaster.
	var/disaster_prob = DEFAULT_RITUAL_DISASTER_PROB
	/// A chance of failing our ritual.
	var/fail_chance = DEFAULT_RITUAL_FAIL_PROB
	/// After successful ritual we'll destroy used things.
	var/ritual_should_del_things = TRUE
	/// After failed ritual proceed - we'll delete items.
	var/ritual_should_del_things_on_fail = FALSE
	/// If defined - do_after will be added to your ritual
	var/cast_time
	/// Generic list of ritual sounds
	var/start_sounds = list(
		'sound/rituals/ritual_start1.ogg',
		'sound/rituals/ritual_start2.ogg',
		'sound/rituals/ritual_start3.ogg',
	)
	/// Generic list of success sounds
	var/success_sounds = list(
		'sound/rituals/ritual_success1.ogg',
		'sound/rituals/ritual_success2.ogg',
	)
	/// Generic list of fail sounds
	var/fail_sounds = list(
		'sound/rituals/ritual_fail1.ogg',
		'sound/rituals/ritual_fail2.ogg',
	)

/datum/ritual/Destroy(force)
	ritual_object = null
	LAZYNULL(required_things)
	return ..()

/datum/ritual/proc/get_ui_params()
	var/list/params = list()
	params["Необходимо участников:"] = extra_invokers + 1
	if(cast_time)
		params["Время выполнения:"] = "[round(cast_time/ (1 SECONDS))]c"
	params["Доступно использований:"] = charges == -1 ? "Не ограничено" : charges
	params["Время ожидания между ритуалами:"] = "[round(cooldown_after_cast/ (1 SECONDS))]c"
	params["Шанс катастрофы:"] =  "[disaster_prob]%"
	params["Шанс провала:"] = "[fail_chance]%"
	params["Удаление предметов:"] = ritual_should_del_things? "Да" : (ritual_should_del_things_on_fail)? "При провале" : "Нет"
	return params


/datum/ritual/proc/get_ui_things()
	var/list/things = list()
	for(var/atom/item as anything in required_things)
		things[item.name] = required_things[item]
	return things

/datum/ritual/proc/is_valid_invoker(mob/living/carbon/human/human)
	if(!istype(human))
		return FALSE

	if(LAZYLEN(allowed_species) && !is_type_in_list(human.dna.species, allowed_species))
		return FALSE

	if(LAZYLEN(allowed_special_role) && !LAZYIN(allowed_special_role, human.mind?.special_role))
		return FALSE

	return TRUE

/datum/ritual/proc/handle_ritual_object(stage, silent = FALSE)
	switch(stage)
		if(RITUAL_STARTED)
			var/chosen_sound = start_sounds
			if(islist(start_sounds) && length(start_sounds))
				chosen_sound = pick(start_sounds)
			playsound(ritual_object.loc, chosen_sound, 50, TRUE)
		if(RITUAL_ENDED)
			var/chosen_sound = success_sounds
			if(islist(success_sounds) && length(success_sounds))
				chosen_sound = pick(success_sounds)
			playsound(ritual_object.loc, chosen_sound, 50, TRUE)
		if(RITUAL_FAILED)
			var/chosen_sound = fail_sounds
			if(islist(fail_sounds) && length(fail_sounds))
				chosen_sound = pick(fail_sounds)
			playsound(ritual_object.loc, chosen_sound, 50, TRUE)

/datum/ritual/proc/del_things(list/used_things)
	return

/datum/ritual/proc/check_invokers(mob/living/carbon/human/invoker, list/invokers)
	return TRUE

/datum/ritual/proc/check_contents(mob/living/carbon/human/invoker, list/used_things)
	return TRUE

/datum/ritual/proc/do_ritual(mob/living/carbon/human/invoker, list/invokers, list/used_things) // Do ritual stuff.
	return RITUAL_SUCCESSFUL

/datum/ritual/proc/disaster(mob/living/carbon/human/invoker, list/invokers, list/used_things)
	return
