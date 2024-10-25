extends Node

enum TimerType { SHOOTCOOLDOWN, RELOADCOOLDOWN, SKILLCOOLDOWN, AUTORELOAD, NULL }

enum GunShootReturn { SHOOT, OUT_OF_AMMO, CANT_SHOOT }

enum GunReloadReturn { RELOAD, CANT_RELOAD, RELOADING }

enum DamageType { BULLET, EXPLOSION, MELEE, AREA, ENEMY }
