extends CharacterBody2D
var movement_ratio: Vector2 = Vector2(1, 0.5625) #isometric
var stick_drift_comp: float = 0.3

const KEY_MAPPINGS: Dictionary = {
	"up": [KEY_UP, KEY_W],
	"down": [KEY_DOWN, KEY_S],
	"left": [KEY_LEFT, KEY_A],
	"right": [KEY_RIGHT, KEY_D],
}

func _ready() -> void:
	for action: String in KEY_MAPPINGS.keys():
		if InputMap.has_action(action): 
			continue
		InputMap.add_action(action, 0.2)
		
		for key: int in KEY_MAPPINGS[action]:
			var event: InputEvent = InputEventKey.new()
			event.set("physical_keycode", key)
			InputMap.action_add_event(action, event)


func _process(delta: float) -> void:
	var wasd: Vector2 = Input.get_vector("left", "right", "up", "down")
	
	if Input.get_connected_joypads().size() > 0:
		if wasd.length() == 0: 
			wasd = Vector2(Input.get_joy_axis(0,JOY_AXIS_LEFT_X), Input.get_joy_axis(0,JOY_AXIS_LEFT_Y))
			
		if wasd.length() < stick_drift_comp: 
			wasd = Vector2.ZERO
			
	$Sprite2D.set("region_rect",
			Rect2i(Vector2i((wasd * Vector2(11, 11) + Vector2(11, 11)) * Vector2(32, 32)), Vector2(32, 32))
	)
	
	position += wasd * movement_ratio * scale * delta * 350 
