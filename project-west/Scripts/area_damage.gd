extends RigidBody3D

@export var y_distance_to_explode: float = 0.0
@export var duration: float = 2.0
@export var damage_interval: float = 0.25

signal area_damage_start

func _ready() -> void:
	$Area3D/Timer.timeout.connect(func() -> void:
		_on_area_damage_timeout()
	)

	$Area3D/Timer2.timeout.connect(func() -> void:
		queue_free()	
	)

	


func _on_body_entered(_body: Node) -> void:
	#check if the this rigidbody is on the floor
	print(global_position.y)
	if global_position.y < y_distance_to_explode:
		start_area_damage()


func start_area_damage() -> void:
	#deactivate the rigidbody so the body stays in place
	freeze = true
	$CollisionShape3D.set_deferred("disabled",true)
	$Area3D.set_deferred("monitoring", true)
	$Area3D.set_deferred("monitorable", true)
	$Area3D/Timer.start(damage_interval)
	$Area3D/Timer2.start(duration)
	area_damage_start.emit()

 
func _on_area_damage_timeout() -> void:
	var bodies = $Area3D.get_overlapping_bodies()
	for body in bodies:
		print(body)
		if body.has_method("take_damage"):
			body.take_damage(Enums.DamageType.AREA, 1)
	
	$Area3D/Timer.start(damage_interval)
