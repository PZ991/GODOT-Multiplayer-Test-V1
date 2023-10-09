extends CharacterBody2D
@onready var camera_2d = $Camera2D

var speed=300
var edelta=0

@onready var s2 = $Sprite2D2
@onready var s1 = $Sprite2D


func _ready():
	set_multiplayer_authority(name.to_int())
	camera_2d.enabled=is_multiplayer_authority()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	edelta=delta
	if is_multiplayer_authority():
		if Input.is_action_pressed("ui_left"):
			position.x-=delta*speed
		if Input.is_action_pressed("ui_up"):
			position.y-=delta*speed
		if Input.is_action_pressed("ui_down"):
			position.y+=delta*speed
		if Input.is_action_pressed("ui_right"):
			position.x+=delta*speed
		
		if Input.is_action_just_released("ui_accept"):
			rpc("changemat",name)
			s1.visible= not s1.visible
			s2.visible= not s2.visible
	pass
	
@rpc("any_peer","unreliable","call_local") func Updatepos(id,pos):
	if !is_multiplayer_authority():
		if name==id:
			position=lerp(position,pos,edelta*15)

@rpc("any_peer","call_local") func changemat(id):
	if not is_multiplayer_authority():
		s1.visible= not s1.visible
		s2.visible= not s2.visible

func _on_timer_timeout():
	if is_multiplayer_authority():
		rpc("Updatepos",name,position)
	pass # Replace with function body.
