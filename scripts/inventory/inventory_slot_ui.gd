extends Control

var hover_enabled: bool
@export var index: int
@export var key_display: String = ""

@onready var inv: PlayerInv = preload("res://resources/inventory/player_inventory.tres")


func _ready() -> void:
	$KeyDescription.text = key_display


func update(slot: InvSlot):
	if slot and slot.item:
		$ItemDisplay.texture = slot.item.texture
		$ItemDisplay.visible = true
		if slot.item.stackable:
			$ItemAmount.text = str(slot.amount)
		hover_enabled = slot.item.enable_hover
		if hover_enabled:
			$HoverDescription/ItemName.text = slot.item.name
			$HoverDescription/ItemDescription.text = slot.item.description
	else:
		$ItemDisplay.visible = false
		$ItemAmount.text = ""
		hover_enabled = false

func set_highlight_visibility(highlight_visible: bool):
	$Highlight.visible = highlight_visible


func _on_set_active_button_mouse_entered() -> void:
	if hover_enabled:
		$HoverDescription.visible = true


func _on_set_active_button_mouse_exited() -> void:
	$HoverDescription.visible = false


func _on_set_active_button_pressed() -> void:
	inv.active_slot = index
