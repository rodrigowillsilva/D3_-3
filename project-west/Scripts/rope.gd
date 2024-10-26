extends Node3D

class_name Rope

const GRAVITY = Vector3(0, -9.8, 0)

var points: Array
@export var initial_position: Vector3
@export var target_position: Vector3
@export var segment_length: float = 1.0
@export var meshI: MeshInstance3D
@onready var mesh: ImmediateMesh = meshI.mesh

var rest_length: float
var num_points: int

func _ready():
	points = []
	rest_length = initial_position.distance_to(target_position)
	num_points = int(rest_length / segment_length) + 1
	
	for i in range(num_points):
			var t = float(i) / (num_points - 1)
			var pos = initial_position.lerp(target_position, t)
			var rp = RopePoint.new(pos)
			points.append(rp)

func update_points(dt: float):
	for point in points:
			point.apply_force(GRAVITY)
			point.update(dt)

	for i in range(num_points - 1):
			var p1 = points[i]
			var p2 = points[i + 1]
			var delta = p2.position - p1.position
			var distance = delta.length()
			var difference = (distance - segment_length) / distance
			var offset = delta * 0.5 * difference
			p1.position += offset
			p2.position -= offset

func render_rope():
	mesh.clear()
	mesh.begin(Mesh.PRIMITIVE_LINES)
	for i in range(num_points - 1):
			mesh.add_vertex(points[i].position)
			mesh.add_vertex(points[i + 1].position)
	mesh.end()

class RopePoint:
	var position: Vector3
	var previous_position: Vector3
	var acceleration: Vector3 = Vector3.ZERO

	func _init(pos: Vector3):
			position = pos
			previous_position = pos

	func apply_force(force: Vector3):
			acceleration += force

	func update(dt: float):
			var temp = position
			position += (position - previous_position) + acceleration * dt * dt
			previous_position = temp
			acceleration = Vector3.ZERO
