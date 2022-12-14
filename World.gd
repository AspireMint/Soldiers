extends Spatial

var move_to: Vector3 = Vector3.ZERO
var speed = 10


func _process(delta):
	var pos = $Soldiers.transform.origin
	var dist = move_to.distance_to(pos)
	
	if dist == 0:
		return
	
	var walk_dir = pos.direction_to(move_to)
	var step = walk_dir * delta * speed
	var step_length = step.distance_to(Vector3.ZERO)
	
	if dist < step_length:
		$Soldiers.transform.origin = move_to
	else:
		$Soldiers.transform.origin += step
	
	var look_dir = -$Soldiers.transform.basis.z
	var angle = look_dir.angle_to(move_to)
	if angle > 0:
		$Soldiers.look_at(move_to, Vector3.UP)


func _input(event: InputEvent):
	var mouse_event = event as InputEventMouseButton
	if not mouse_event:
		return
	
	if mouse_event.pressed and mouse_event.button_index == BUTTON_LEFT:
		var space_state = get_world().get_direct_space_state()
		var from = $Camera.project_ray_origin(mouse_event.position)
		var dir = $Camera.project_ray_normal(mouse_event.position)
		var to = dir * 1000
		
		var result = space_state.intersect_ray(from, to)
		if not result.has("position"):
			return
		move_to = result.position
