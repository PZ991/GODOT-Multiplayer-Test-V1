extends Node2D

var peer = ENetMultiplayerPeer.new()
@export var playerscene:PackedScene
@onready var camera_2d = $Camera2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_host_pressed():
	peer.create_server(123)
	multiplayer.multiplayer_peer=peer
	multiplayer.peer_connected.connect(addplayer)
	addplayer()
	camera_2d.enabled=false
	pass # Replace with function body.


func _on_join_pressed():
	peer.create_client("192.168.0.101",123)
	multiplayer.multiplayer_peer=peer
	camera_2d.enabled=false
	pass # Replace with function body.

func exitgame(id):
	multiplayer.peer.disconnect.connect(deleteplayer)
	_del_player(id)

func addplayer(id=1):
	var player =playerscene.instantiate()
	player.name=str(id)
	call_deferred("add_child",player)

func deleteplayer(id):
	rpc("_del_player",id)
	
@rpc("any_peer","call_local") func _del_player(id):
		get_node(str(id)).queue_free()


