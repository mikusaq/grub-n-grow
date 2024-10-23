extends Control 

func update(slot: InvSlot):
	if slot and slot.item:
		$ItemDisplay.texture = slot.item.texture
		$ItemDisplay.visible = true
	else:
		$ItemDisplay.visible = false

func set_highlight_visibility(highlight_visible: bool):
	$Highlight.visible = highlight_visible
