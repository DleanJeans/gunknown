extends Spatial
class_name Pushback

export var duration = 0.1
export var force = 50

onready var agent = get_parent()

var bullet_rotation:Vector3
var velocity = Vector3(force, 0, 0)

func _init(bullet):
	bullet_rotation = bullet.rotation

func _ready():
	var timer = Timer.new()
	add_child(timer)
	timer.start(duration)
	yield(timer, 'timeout')
	queue_free()

func _physics_process(delta):
	agent.velocity += velocity.rotated(Vector3.UP, bullet_rotation.y) * delta