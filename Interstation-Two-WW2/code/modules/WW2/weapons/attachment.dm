
/*
TODO:
Optimize this code as much as possible
Add Sounds
Replace snowflaked icon manipulation with proper icon mask manipulation
See if we can move obj/item/device attachments into obj/item/attachment (zoom code keeps me from doing this for now)
Add more attachments
Add attached bayonet sprite

Current Defines (_defines/attachment.dm)

#define CHECK_IRONSIGHTS 1
#define CHECK_SCOPE 2
#define CHECK_STOCK 3
#define CHECK_BARREL 4
#define CHECK_UNDER 5

#define ATTACH_IRONSIGHTS 1
#define ATTACH_SCOPE 2
#define ATTACH_STOCK 3
#define ATTACH_BARREL 4
#define ATTACH_UNDER 5
*/

/obj/item/attachment
  var/attachable = TRUE
  var/attachment_type //Use the 'ATTACH_' defines above (should only use one for this)
  var/A_attached = FALSE //Is attached

/obj/item/attachment/proc/attached(mob/user, obj/item/weapon/gun/G)
  A_attached = TRUE

/obj/item/attachment/proc/removed(mob/user, obj/item/weapon/gun/G)
  dropped(user)
  A_attached = FALSE
  loc = get_turf(src)

/obj/item/weapon/gun
  var/list/attachments = list()
  var/attachment_slots = null //Use the 'ATTACH_' defines above; can ise in combination Ex. ATTACH_SCOPE|ATTACH_BARREL

/obj/item/weapon/gun/examine(mob/user)
  ..()
  if(attachments.len)
    for(var/obj/item/attachment/A in attachments)
      user << "<span class='notice'>It has [A] attached.</span>"

/obj/item/weapon/gun/dropped(mob/user)
  if(attachments.len)
    for(var/obj/item/attachment/A in attachments)
      A.dropped(user)

/obj/item/weapon/gun/pickup(mob/user)
  if(attachments.len)
    for(var/obj/item/attachment/A in attachments)
      A.pickup(user)

/obj/item/weapon/gun/verb/field_strip()
  set name = "Field Strip"
  set desc = "Removes any attachments."
  set category = "Weapons"

  var/mob/living/carbon/human/user = usr

  for(var/obj/item/attachment/A in attachments)
    if(!istype(A, /obj/item/attachment/scope/iron_sights))//Seph here's your ugly hack
      remove_attachment(A, user)

//Use this under /New() of weapons if they spawn with attachments
/obj/item/weapon/gun/proc/spawn_add_attachment(obj/item/attachment/A)
  A.A_attached = TRUE
  attachment_slots -= A.attachment_type
  attachments += A
  actions += A.actions
  if(istype(loc, /mob/living/carbon/human))
    var/mob/living/carbon/human/H = loc
    update_attachment_actions(H)

/obj/item/weapon/gun/proc/add_attachment(obj/item/attachment/A, mob/user)
  if(do_after(user, 15, user))
    attachments += A
    user.unEquip(A)
    A.loc = src
    actions += A.actions
    verbs += A.verbs
    update_attachment_actions(user)
    attachment_slots -= A.attachment_type
    A.attached(user, src)

    //This should only be temporary until more attachment icons are made, then we switch to adding/removing icon masks
    if(istype(A, /obj/item/attachment/scope/adjustable/sniper_scope))
      if(istype(src, /obj/item/weapon/gun/projectile/boltaction))
        var/obj/item/weapon/gun/projectile/boltaction/W = src
        W.update_icon(1)

    user << "You attach [A] to the [src]."
    return 0

/obj/item/weapon/gun/proc/update_attachment_actions(mob/user)
  for(var/datum/action/action in actions)
    action.Grant(user)

/obj/item/weapon/gun/proc/remove_attachment(obj/item/attachment/A, mob/user)
  if(do_after(user, 15, user))
    attachments -= A
    actions -= A.actions
    verbs -= A.verbs
    attachment_slots += A.attachment_type
    A.removed(user, src)

    //This should only be temporary until more attachment icons are made, then we switch to adding/removing icon masks
    if(istype(A, /obj/item/attachment/scope/adjustable/sniper_scope))
      icon_state = initial(icon_state)
      item_state = initial(item_state)
      if(istype(src, /obj/item/weapon/gun/projectile/boltaction))
        var/obj/item/weapon/gun/projectile/boltaction/W = src
        if(W.bolt_open)
          W.icon_state = addtext(W.icon_state, "_open")

    user << "You remove [A] from the [src]."

/obj/item/weapon/gun/proc/try_attach(obj/item/attachment/A, mob/user)
  if(!A || !user)
    return
  if(user.get_inactive_hand() != src)
    user << "You must be holding the [src] to add attachments."
    return
  attach_A(A, user)

//Do not use this; use try_attach instead
/obj/item/weapon/gun/proc/attach_A(obj/item/attachment/A, mob/user)
  switch(A.attachment_type)
    if(ATTACH_IRONSIGHTS)
      if(attachment_slots & CHECK_IRONSIGHTS)
        add_attachment(A, user)
      else
        user << "You already have iron sights."
    if(ATTACH_SCOPE)
      if(attachment_slots & CHECK_SCOPE)
        add_attachment(A, user)
      else
        user << "You fumble around with the attachment."
    if(ATTACH_STOCK)
      if(attachment_slots & CHECK_STOCK)
        add_attachment(A, user)
      else
        user << "You fumble around with the attachment."
    if(ATTACH_BARREL)
      if(attachment_slots & CHECK_BARREL)
        add_attachment(A, user)
      else
        user << "You fumble around with the attachment."
    if(ATTACH_UNDER)
      if(attachment_slots & CHECK_UNDER)
        add_attachment(A, user)
      else
        user << "You fumble around with the attachment."
    else
      user << "[A] cannot be attached to the [src]."

//ATTACHMENTS

//Scope code is found in code/modules/WW2/weapons/zoom.dm

//This is reserved for bayonet charging
/*
/datum/action/toggle_scope
	name = "Bayonet Charge"
	check_flags = AB_CHECK_ALIVE|AB_CHECK_RESTRAINED|AB_CHECK_STUNNED|AB_CHECK_LYING
	button_icon_state = ""
	var/obj/item/attachment/bayonet = null

/obj/item/attachment/bayonet/proc/build_bayonet()
	amelee = new()
	amelee.bayonet = src
	actions += amelee

/datum/action/bayonet/IsAvailable()
	. = ..()

/datum/action/bayonet/Trigger()
	..()

/datum/action/bayonet/Remove(mob/living/L)
	..()

/obj/item/attachment/bayonet/New()
	..()
	build_bayonet()

/obj/item/attachment/bayonet/pickup(mob/user)
	..()
	if(amelee)
		amelee.Grant(user)

/obj/item/attachment/bayonet/dropped(mob/user)
	..()
	if(amelee)
		amelee.Remove(user)
*/
/obj/item/attachment/bayonet
	name = "bayonet"
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "bayonet"
	item_state = "knife"
	flags = CONDUCT
	sharp = 1
	edge = 1
	force = WEAPON_FORCE_DANGEROUS/1.5
	attack_verb = list("slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	attachment_type = ATTACH_BARREL
	var/attack_sound = 'sound/weapons/slice.ogg'
	//var/datum/action/bayonet/amelee

/obj/item/attachment/bayonet/attached(mob/user, obj/item/weapon/gun/G)
  ..()
  G.bayonet = src

/obj/item/attachment/bayonet/removed(mob/user, obj/item/weapon/gun/G)
  ..()
  G.bayonet = null

/obj/item/attachment/scope/iron_sights
	name = "iron sights"
	attachment_type = ATTACH_IRONSIGHTS
	zoom_amt = 4

/obj/item/attachment/scope/adjustable/sniper_scope
	name = "sniper scope"
	icon_state = "kar_scope"
	desc = "You can attach this to rifles... or use them as binoculars."
	max_zoom = 8

/obj/item/attachment/scope/removed(mob/user, obj/item/weapon/gun/G)
  ..()
  G.accuracy = initial(G.accuracy)
  G.recoil = initial(G.recoil)
