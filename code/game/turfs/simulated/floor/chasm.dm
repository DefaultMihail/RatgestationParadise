/turf/simulated/floor/chasm
	name = "chasm"
	desc = "Watch your step."
	baseturf = /turf/simulated/floor/chasm
	smooth = SMOOTH_BITMASK
	icon = 'icons/turf/floors/Chasms.dmi'
	icon_state = "smooth"
	base_icon_state = "Chasms"
	canSmoothWith = SMOOTH_GROUP_TURF_CHASM
	smoothing_groups = SMOOTH_GROUP_TURF_CHASM
	density = TRUE //This will prevent hostile mobs from pathing into chasms, while the canpass override will still let it function like an open turf
	layer = PLATING_LAYER
	intact = FALSE
	explosion_vertical_block = 0
	footstep = null
	barefootstep = null
	clawfootstep = null
	heavyfootstep = null


/turf/simulated/floor/chasm/Initialize(mapload)
	. = ..()
	apply_components(mapload)


/// Handles adding the chasm component to the turf (So stuff falls into it!)
/turf/simulated/floor/chasm/proc/apply_components(mapload)
	AddComponent(/datum/component/chasm, GET_TURF_BELOW(src), mapload)


/// Lets people walk into chasms.
/turf/simulated/floor/chasm/CanAllowThrough(atom/movable/mover, border_dir)
	. = ..()
	return TRUE


/turf/simulated/floor/chasm/proc/set_target(turf/target)
	var/datum/component/chasm/chasm_component = GetComponent(/datum/component/chasm)
	chasm_component.target_turf = target


/turf/simulated/floor/chasm/proc/drop(atom/movable/AM)
	var/datum/component/chasm/chasm_component = GetComponent(/datum/component/chasm)
	chasm_component.drop(AM)


/turf/simulated/floor/chasm/get_smooth_underlay_icon(mutable_appearance/underlay_appearance, turf/asking_turf, adjacency_dir)
	underlay_appearance.icon = 'icons/turf/floors.dmi'
	underlay_appearance.icon_state = "basalt"
	return TRUE


/turf/simulated/floor/chasm/is_safe()
	if(HAS_TRAIT(src, TRAIT_CHASM_STOPPED) && ..())
		return TRUE
	return FALSE


/turf/simulated/floor/chasm/can_have_cabling()
	if(locate(/obj/structure/lattice/catwalk/fireproof, src))
		return TRUE
	return FALSE


/turf/simulated/floor/chasm/attackby(obj/item/I, mob/user, params)
	. = ..()

	if(ATTACK_CHAIN_CANCEL_CHECK(.))
		return .

	if(istype(I, /obj/item/stack/fireproof_rods))
		var/obj/item/stack/fireproof_rods/rods = I
		if(locate(/obj/structure/lattice/catwalk/fireproof, src))
			to_chat(user, span_warning("Здесь уже есть мостик!"))
			return .
		var/obj/structure/lattice/fireproof/lattice = locate() in src
		if(!lattice)
			if(!rods.use(1))
				to_chat(user, span_warning("Вам нужен один огнеупорный стержень для постройки решётки!"))
				return .
			to_chat(user, span_notice("Вы установили прочную решётку."))
			playsound(src, 'sound/weapons/genhit.ogg', 50, TRUE)
			new /obj/structure/lattice/fireproof(src)
			return .|ATTACK_CHAIN_SUCCESS
		if(!rods.use(2))
			to_chat(user, span_warning("Вам нужно два огнеупорных стержня для постройки мостика!"))
			return .
		qdel(lattice)
		playsound(src, 'sound/weapons/genhit.ogg', 50, TRUE)
		to_chat(user, span_notice("Вы установили огнеупорный мостик."))
		new /obj/structure/lattice/catwalk/fireproof(src)
		return .|ATTACK_CHAIN_SUCCESS

/turf/simulated/floor/chasm/ex_act()
	return


/turf/simulated/floor/chasm/acid_act(acidpwr, acid_volume)
	return


/turf/simulated/floor/chasm/singularity_act()
	return


/turf/simulated/floor/chasm/singularity_pull(S, current_size)
	return


/turf/simulated/floor/chasm/crowbar_act()
	return


/turf/simulated/floor/chasm/make_plating()
	return


/turf/simulated/floor/chasm/remove_plating()
	return


/turf/simulated/floor/chasm/rcd_act()
	return RCD_NO_ACT


/turf/simulated/floor/chasm/MakeSlippery(wet_setting = TURF_WET_WATER, min_wet_time = 0, wet_time_to_add = 0, max_wet_time = MAXIMUM_WET_TIME, permanent = FALSE, should_display_overlay = TRUE)
	return


/turf/simulated/floor/chasm/MakeDry(wet_setting = TURF_WET_WATER, immediate = FALSE, amount = INFINITY)
	return


// Subtypes

/turf/simulated/floor/chasm/straight_down


/turf/simulated/floor/chasm/straight_down/apply_components(mapload)
	AddComponent(/datum/component/chasm, null, mapload)	//Don't pass anything for below_turf.


/turf/simulated/floor/chasm/straight_down/lava_land_surface
	oxygen = 14
	nitrogen = 23
	temperature = 300
	planetary_atmos = TRUE
	baseturf = /turf/simulated/floor/chasm/straight_down/lava_land_surface //Chasms should not turn into lava
	light_range = 2
	light_power = 0.75
	light_color = LIGHT_COLOR_LAVA //let's just say you're falling into lava, that makes sense right


/turf/simulated/floor/chasm/straight_down/lava_land_surface/normal_air
	oxygen = MOLES_O2STANDARD
	nitrogen = MOLES_N2STANDARD
	temperature = T20C

