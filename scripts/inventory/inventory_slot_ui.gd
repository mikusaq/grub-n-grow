extends Control 

func update(slot: InvSlot):
	if slot and slot.item:
		$ItemDisplay.texture = slot.item.texture
		$ItemDisplay.visible = true
	else:
		$ItemDisplay.visible = false
