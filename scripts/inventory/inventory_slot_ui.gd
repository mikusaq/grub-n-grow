extends Control 

func update(slot: InvSlot):
	if slot and slot.item:
		$ItemDisplay.texture = slot.item.texture
		$ItemDisplay.visible = true
		if slot.item.stackable:
			$ItemAmount.text = str(slot.amount)
	else:
		$ItemDisplay.visible = false
		$ItemAmount.text = ""

func set_highlight_visibility(highlight_visible: bool):
	$Highlight.visible = highlight_visible
