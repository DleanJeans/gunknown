extends Spatial

onready var agent = get_parent()

func _physics_process(delta):
	if Input.is_action_just_pressed('left_click'):
		agent.shoot()
	
	_process_movement(delta)
	_rotate_gun()

func _rotate_gun():
	var camera = get_viewport().get_camera()
	var screen_position = camera.unproject_position(global_transform.origin)
	var mouse_position = get_viewport().get_mouse_position()
	var angle = mouse_position.angle_to_point(screen_position)
	
	agent.rotation.y = -angle
	
	var ray_origin = camera.project_ray_origin(mouse_position) - Vector3(0, agent.translation.y, 0)
	var ray_normal = camera.project_ray_normal(mouse_position)
	var ray_to = ray_origin + ray_normal * 100
	var space_state = get_world().direct_space_state
	var hit = space_state.intersect_ray(ray_origin, ray_to, [], 1) # GROUND == 1
	
	if not hit.empty():
		var hit_position = Vector2(hit.position.x, hit.position.z)
		var position2d = Vector2(global_transform.origin.x, global_transform.origin.z)
		angle = hit_position.angle_to_point(position2d)
		agent.rotation.y = -angle

func _process_movement(delta):
	var velocity2d = Vector2(agent.velocity.x, agent.velocity.z)
	
	var speed_delta = agent.speed * delta
	
	if Input.is_action_pressed('ui_left'):
		velocity2d.x += -speed_delta
	if Input.is_action_pressed('ui_right'):
		velocity2d.x += speed_delta
	if Input.is_action_pressed('ui_up'):
		velocity2d.y += -speed_delta
	if Input.is_action_pressed('ui_down'):
		velocity2d.y += speed_delta
	velocity2d = velocity2d.clamped(agent.speed)
	
	agent.velocity = Vector3(velocity2d.x, 0, velocity2d.y)