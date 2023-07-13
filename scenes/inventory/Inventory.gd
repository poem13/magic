extends Node2D

const SlotClass = preload("res://scenes/inventory/Slot.gd")
onready var inventory_slots = $GridContainer
onready var eqip_slots = $EquipSlots.get_children()


# Called when the node enters the scene tree for the first time.
func _ready():
	var slots = inventory_slots.get_children()
	for i in range(slots.size()):
		slots[i].connect("gui_input", self, "slot_gui_input", [slots[i]]) #connects mouse input to slot gui input
		slots[i].slot_index = i
		slots[i].slotType= SlotClass.SlotType.INVENTORY
		
	for i in range(eqip_slots.size()):	
		eqip_slots[i].connect("gui_input", self, "slot_gui_input", [eqip_slots[i]]) #connects mouse input to slot gui input
		eqip_slots[i].slot_index = i		
	eqip_slots[0].slotType = SlotClass.SlotType.SHIRT
	eqip_slots[1].slotType = SlotClass.SlotType.PANTS
	eqip_slots[2].slotType = SlotClass.SlotType.SHOES
	
	initialize_inventory()
	initialize_equips()


func slot_gui_input(event: InputEvent, slot: SlotClass):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && event.pressed: # Has left click occured?
			if find_parent("Main").holding_item != null:
				if !slot.item: # If the slot is empty, place it into the slot
					left_click_empty_slot(slot)
				else: # swap with item in the slot
					# different item so swap
					if find_parent("Main").holding_item.item_name != slot.item.item_name:
						left_click_different_item(event, slot)
					else: #same item so MERGE!
						left_click_same_item(slot)
			elif slot.item: #if we clicked and AREN'T holding item but slot has item, pick it up
				left_click_not_holding(slot)

func _input(event):
	if(find_parent("Main").holding_item):
		find_parent("Main").holding_item.global_position = get_global_mouse_position()
		
func able_to_put_into_slot(slot: SlotClass):
	var holding_item = find_parent("Main").holding_item
	if holding_item == null:
		return true
	var holding_item_category = JsonData.item_data[holding_item.item_name]["ItemCategory"]
	
	if slot.slotType == SlotClass.SlotType.SHIRT:
		return holding_item_category == "Shirt"
	elif slot.slotType == SlotClass.SlotType.PANTS:
		return holding_item_category == "Pants"
	elif slot.slotType == SlotClass.SlotType.SHOES:
		return holding_item_category == "Shoes"
	return true		
		
func initialize_inventory():
	var slots = inventory_slots.get_children()
	for i in range(slots.size()):
		if PlayerInventory.inventory.has(i):
			slots[i].initialize_item(PlayerInventory.inventory[i][0], PlayerInventory.inventory[i][1])
			
func initialize_equips():
	for i in range(eqip_slots.size()):
		if PlayerInventory.equips.has(i):
			eqip_slots[i].initialize_item(PlayerInventory.equips[i][0], PlayerInventory.equips[i][1])			
			
func left_click_empty_slot(slot: SlotClass):
	if able_to_put_into_slot(slot):
		PlayerInventory.add_item_to_empty_slot(find_parent("Main").holding_item, slot)
		slot.putIntoSlot(find_parent("Main").holding_item)
		find_parent("Main").holding_item = null	

func left_click_different_item(event: InputEvent, slot: SlotClass):
	if able_to_put_into_slot(slot):
		PlayerInventory.remove_item(slot)
		PlayerInventory.add_item_to_empty_slot(find_parent("Main").holding_item, slot)
		var temp_item = slot.item
		slot.pickFromSlot()
		temp_item.global_position = event.global_position
		slot.putIntoSlot(find_parent("Main").holding_item)
		find_parent("Main").holding_item = temp_item	
	
func left_click_same_item(slot: SlotClass):
	if able_to_put_into_slot(slot):
		var stack_size = int(JsonData.item_data[slot.item.item_name]["StackSize"])
		var able_to_add = stack_size - slot.item.item_quantity
		if able_to_add >= find_parent("Main").holding_item.item_quantity:
			PlayerInventory.add_item_quantity(slot,find_parent("Main").holding_item.item_quantity)
			slot.item.add_item_quantity(find_parent("Main").holding_item.item_quantity)
			find_parent("Main").holding_item.queue_free()
			find_parent("Main").holding_item = null
		else:
			PlayerInventory.add_item_quantity(slot, able_to_add)
			slot.item.add_item_quantity(able_to_add)
			find_parent("Main").holding_item.decrease_item_quantity(able_to_add)
		
func left_click_not_holding(slot: SlotClass):
	PlayerInventory.remove_item(slot)
	find_parent("Main").holding_item = slot.item
	slot.pickFromSlot()
	find_parent("Main").holding_item.global_position = get_global_mouse_position()			
