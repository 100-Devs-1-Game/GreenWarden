extends RichTextLabel

# add signal for toggle here

@onready var label := $"."
var fps_samples := []
var sample_window := 60 * 60  # 60 seconds at 60 FPS
var poll_interval := 0.25
var poll_timer := 0
var peak_fps := 0

func is_3d_project() -> bool:
	if get_viewport().get_camera_3d(): 
		return true
	elif get_viewport().get_camera_2d(): 
		return false
	else: 
		return true if get_tree().current_scene is Node3D else false


func _ready() -> void:
	if !OS.is_debug_build(): 
		queue_free()
		return
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)

func _physics_process(delta: float) -> void:
	var fps = Engine.get_frames_per_second()
	fps_samples.append(fps)
	if fps > peak_fps:
		peak_fps = fps
	
	poll_timer += delta
	if poll_timer >= poll_interval:
		poll_timer = 0.0
		update_performance_stats()

func update_performance_stats():
	var fps = Engine.get_frames_per_second()
	var frame_time = max(1000.0 / fps, 0)  # in milliseconds
	var memory_usage = max(OS.get_static_memory_usage() / 1024 / 1024, 0)  # in MB
	if fps_samples.size() > sample_window: fps_samples.pop_front()
	var total_fps = fps_samples.reduce(func(a, b): return a + b, 0)
	var avg_fps = total_fps / fps_samples.size() if fps_samples.size() > 0 else 0
	var sorted_samples = fps_samples.duplicate(); sorted_samples.sort()
	var index_1pct = clamp(int(sorted_samples.size() * 0.01), 0, sorted_samples.size() - 1)
	var one_pct_low = sorted_samples[index_1pct] if sorted_samples.size() > 0 else 0

	if is_3d_project():
		var tris := get_viewport().get_render_info(Viewport.RENDER_INFO_TYPE_VISIBLE, Viewport.RENDER_INFO_PRIMITIVES_IN_FRAME)
		var calls := get_viewport().get_render_info(Viewport.RENDER_INFO_TYPE_VISIBLE, Viewport.RENDER_INFO_DRAW_CALLS_IN_FRAME)
		var objects := get_viewport().get_render_info(Viewport.RENDER_INFO_TYPE_VISIBLE, Viewport.RENDER_INFO_OBJECTS_IN_FRAME)
		text = "FPS: %.1f\nPeak FPS: %.1f\nAvg FPS: %.1f\n1%% Low: %.1f\nFrame Time: %.2f ms\nTris: %d\nObjects: %d\nDraw Calls: %d\nMem: %.1f MB" % [
			fps, peak_fps, avg_fps, one_pct_low, frame_time, tris, objects, calls, memory_usage
		]
	else:
		text = "FPS: %.1f\nPeak FPS: %.1f\nAvg FPS: %.1f\n1%% Low: %.1f\nFrame Time: %.2f ms\nMem: %.1f MB" % [
			fps, peak_fps, avg_fps, one_pct_low, frame_time, memory_usage
		]
