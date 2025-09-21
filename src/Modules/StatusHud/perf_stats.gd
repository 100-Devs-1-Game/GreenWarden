extends RichTextLabel

# TODO: Add signal for toggling the performance stats display

@onready var label: RichTextLabel = $"."

var fps_samples: Array = []
var sample_window: int = 60 * 60  # 60 seconds at 60 FPS
var poll_interval: float = 0.25
var peak_fps: float = 0.0
var poll_timer: float = 0.0


func _ready() -> void:
	if not OS.is_debug_build():
		return
	_enable_vsync(true)


func _physics_process(delta: float) -> void:
	var fps: float = Engine.get_frames_per_second()
	fps_samples.append(fps)

	if fps > peak_fps:
		peak_fps = fps

	poll_timer += delta
	if poll_timer >= poll_interval:
		poll_timer = 0.0
		_update_performance_stats()


func _enable_vsync(value: bool = false) -> void:
	if value:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)


func _is_3d_project() -> bool:
	if get_viewport().get_camera_3d():
		return true
	elif get_viewport().get_camera_2d():
		return false
	else:
		return get_tree().current_scene is Node3D


func _update_performance_stats() -> void:
	var fps: float = Engine.get_frames_per_second()
	var frame_time: float = max(1000.0 / fps, 0.0)  # in milliseconds
	var memory_usage: float = max(float(OS.get_static_memory_usage()) / 1024.0 / 1024.0, 0.0)  # in MB

	if fps_samples.size() > sample_window:
		fps_samples.pop_front()

	var total_fps: int = fps_samples.reduce(func(a: int, b: int) -> int: return a + b, 0)
	var avg_fps: float = (total_fps / float(fps_samples.size())) if fps_samples.size() > 0 else 0.0

	var sorted_samples: Array = fps_samples.duplicate()
	sorted_samples.sort()

	var index_1pct: int = clamp(int(sorted_samples.size() * 0.01), 0, sorted_samples.size() - 1)
	var one_pct_low: float = sorted_samples[index_1pct] if sorted_samples.size() > 0 else 0.0

	if _is_3d_project():
		var tris: int = get_viewport().get_render_info(
			Viewport.RENDER_INFO_TYPE_VISIBLE, Viewport.RENDER_INFO_PRIMITIVES_IN_FRAME
		)
		var calls: int = get_viewport().get_render_info(
			Viewport.RENDER_INFO_TYPE_VISIBLE, Viewport.RENDER_INFO_DRAW_CALLS_IN_FRAME
		)
		var objects: int = get_viewport().get_render_info(
			Viewport.RENDER_INFO_TYPE_VISIBLE, Viewport.RENDER_INFO_OBJECTS_IN_FRAME
		)

		var contents: String = str([
			"FPS: %.0f" % fps,
			"|Peak FPS: %.0f" % peak_fps,
			"|Avg FPS: %.1f" % avg_fps,
			"|1%% Low: %.0f" % one_pct_low,
			"|Frame Time: %.2f ms" % frame_time,
			"|Tris: %d" % tris,
			"|Objects: %d" % objects,
			"|Draw Calls: %d" % calls,
			"|Mem: %.1f MB" % memory_usage,
		]).replace_chars("[\",]", 8203).replace("|", "\n")
		text = contents
	
	else:
		var contents: String = str([
			"FPS: %.0f" % fps,
			"|Peak FPS: %.0f" % peak_fps,
			"|Avg FPS: %.1f" % avg_fps,
			"|1%% Low: %.0f" % one_pct_low,
			"|Frame Time: %.2f ms" % frame_time,
			"|Mem: %.1f MB" % memory_usage,
		]).replace_chars("[\",]", 8203).replace("|", "\n")
		text = contents
