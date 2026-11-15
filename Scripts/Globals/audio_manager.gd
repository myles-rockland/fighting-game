extends Node

var audio_players : Array[AudioStreamPlayer]

func play(stream : AudioStream):
	var player : AudioStreamPlayer = _get_available_audio_player()
	player.stream = stream
	player.play()
	
func _get_available_audio_player() -> AudioStreamPlayer:
	for player in audio_players:
		if not player.playing:
			return player
	
	return _create_new()
	
func _create_new() -> AudioStreamPlayer:
	var player : AudioStreamPlayer = AudioStreamPlayer.new()
	add_child(player)
	audio_players.append(player)
	return player
