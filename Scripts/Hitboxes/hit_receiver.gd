class_name HitReceiver
extends Area3D

var fighter : Fighter
@export var hit_state_name : String

func initialise(fighter : Fighter):
	self.fighter = fighter

func hit(damage : int):
	fighter.take_damage(self, damage)
