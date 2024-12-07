shader_type canvas_item;

varying vec2 vertexPos;
uniform vec2 globalTilePos;
uniform float pixelArtSize = 32.;
uniform vec3 highlightColor = vec3(1.0, 0.0, 0.0);

void vertex() {
	vertexPos = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

void fragment() {
	float isWithinX = step(vertexPos.x, globalTilePos.x + pixelArtSize + (0.15 * globalTilePos.x / pixelArtSize)) * step(globalTilePos.x, vertexPos.x);
	float isWithinY = step(vertexPos.y, globalTilePos.y + pixelArtSize) * step(globalTilePos.y, vertexPos.y);
	float isWithin = isWithinX * isWithinY;

	COLOR = mix(COLOR, vec4(highlightColor, 1.0), .4 * isWithin);
}