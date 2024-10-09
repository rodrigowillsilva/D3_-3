extends Node3D

class_name Gun


@export var max_ammo: int
@export var fire_rate: float
@export var reload_time: float
@export var timers: Array[Timer]

@onready var ammo = max_ammo

func shoot() -> Enums.GunReturn:
	if ammo > 0:
		ammo -= 1
		print("Shooting")
		timers[Enums.TimerType.SHOOTCOOLDOWN].start(fire_rate)
		return Enums.GunReturn.SHOOT
	else:
		print("Out of ammo")
		return Enums.GunReturn.OUT_OF_AMMO

func reload() -> Enums.GunReturn:
	if ammo < max_ammo:
		ammo = max_ammo
		print("Reloading")
		timers[Enums.TimerType.RELOADCOOLDOWN].start(reload_time)
		return Enums.GunReturn.RELOAD
	
	return Enums.GunReturn.NULL
