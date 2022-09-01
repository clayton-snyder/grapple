extends Node2D

func _ready():
	self.visible = false
	if len($Area2D.get_overlapping_bodies()) > 0:
		self.visible = true

func _on_Area2D_body_entered(area):
	self.visible = true

func _on_Area2D_body_exited(area):
	self.visible = false
