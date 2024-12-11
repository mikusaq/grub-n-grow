extends TextureRect

const UNTICK_TEXTURE_RECT: Rect2 = Rect2(45, 62, 5, 5)
const TICK_TEXTURE_RECT: Rect2 = Rect2(45, 70, 5, 5)


func tick():
	$TickBox.texture.region = TICK_TEXTURE_RECT


func untick():
	$TickBox.texture.region = UNTICK_TEXTURE_RECT
