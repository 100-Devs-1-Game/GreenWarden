extends CharacterBody2D
var stickDriftComp = 0.3
const keyMappings = {
	"up": [KEY_UP, KEY_W],
	"down": [KEY_DOWN, KEY_S],
	"left": [KEY_LEFT, KEY_A],
	"right": [KEY_RIGHT, KEY_D]
}

func _ready() -> void:
	for action in keyMappings.keys():
		if InputMap.has_action(action): continue
		InputMap.add_action(action, 0.2)
		for key in keyMappings[action]:
			var event = InputEventKey.new()
			event.physical_keycode = key
			InputMap.action_add_event(action, event)

func _process(delta: float) -> void:
	var wasd = Input.get_vector("left", "right", "up", "down")
	if Input.get_connected_joypads().size() > 0:
		if wasd.length() == 0: 
			wasd = Vector2(Input.get_joy_axis(0,0), Input.get_joy_axis(0,1))
		if wasd.length() < stickDriftComp: wasd = Vector2.ZERO
	$Sprite2D.region_rect = Rect2i(round(wasd * 11 + Vector2(11, 11)) * 32, Vector2(32, 32))
	position += wasd * scale * delta * 350
