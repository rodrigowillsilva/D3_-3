extends Node3D

class_name Gun

signal shoot_signal
signal reload_signal
signal skill_signal
signal on_equip_signal
signal on_unequip_signal

@export var max_ammo: int
@export var fire_rate: float
@export var reload_time: float
@export var skill_cooldown: float
@export var auto_reload_time: float
@export var timers: Array[Timer]
@export var muzzle_flash: CPUParticles3D

@onready var ammo = max_ammo
@onready var anim_sprite: AnimatedSprite3D = $AnimatedSprite3D

var can_shoot: bool = true
var can_skill: bool = true


func _ready() -> void:
	timers[Enums.TimerType.RELOADCOOLDOWN].timeout.connect(func() -> void:
		ammo = max_ammo
	)

	timers[Enums.TimerType.SHOOTCOOLDOWN].timeout.connect(func() -> void:
		can_shoot = true
	)

	timers[Enums.TimerType.SKILLCOOLDOWN].timeout.connect(func() -> void:
		can_skill = true
	)

	timers[Enums.TimerType.AUTORELOAD].timeout.connect(func() -> void:
		ammo = max_ammo
	)


func shoot() -> Enums.GunShootReturn:
	if not can_shoot: return Enums.GunShootReturn.CANT_SHOOT
	if timers[Enums.TimerType.SHOOTCOOLDOWN].time_left != 0: return Enums.GunShootReturn.CANT_SHOOT
	if ammo <= 0: return Enums.GunShootReturn.OUT_OF_AMMO
	timers[Enums.TimerType.RELOADCOOLDOWN].stop()
	timers[Enums.TimerType.SHOOTCOOLDOWN].start(fire_rate)
	ammo -= 1
	shoot_signal.emit()
	can_shoot = false
	return Enums.GunShootReturn.SHOOT



func reload() -> Enums.GunReloadReturn:
	if not can_shoot: return Enums.GunReloadReturn.CANT_RELOAD
	if ammo == max_ammo: return Enums.GunReloadReturn.CANT_RELOAD
	if timers[Enums.TimerType.RELOADCOOLDOWN].time_left != 0: return Enums.GunReloadReturn.RELOADING
	
	timers[Enums.TimerType.RELOADCOOLDOWN].start(reload_time)
	reload_signal.emit()

	return Enums.GunReloadReturn.RELOAD

func skill() -> void:
	pass
	

func on_equip() -> void:
	timers[Enums.TimerType.AUTORELOAD].stop()
	can_shoot = false
	pass
	# on_equip_signal.emit()

func on_unequip() -> void:
	timers[Enums.TimerType.RELOADCOOLDOWN].stop()
	timers[Enums.TimerType.AUTORELOAD].start(auto_reload_time)
	pass
	# on_unequip_signal.emit()
