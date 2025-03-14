extends Area2D

@export var sfx_coin: AudioStream

func _ready() -> void:
	connect("body_entered", _on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body.name == "Player":
		load_sfx(sfx_coin)
		%sfx_player.play()
		queue_free()

func load_sfx(sfx_to_load):
	if %sfx_player.stream != sfx_to_load:
		%sfx_player.stop()
		%sfx_player.stream = sfx_to_load
