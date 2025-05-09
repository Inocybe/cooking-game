class_name MusicManager extends Node


@export var song_players: Array[AudioStreamPlayer]

@export var town_default_songs: Dictionary[int, int] = {}

@export var max_increased_speed: float = 2.5
@export var speed_increase_time: float = 20

# ints mean index in song_players, expect -1 is NoMusic
var playlist_order: Array[int] = []


func _ready() -> void:
	set_music_speed(1)
	generate_playlist_order()
	start_default_song()
	play_next()


func _process(_delta: float) -> void:
	var time_remaining: float = Global.game_manager.time_remaining
	if time_remaining > speed_increase_time:
		return
	var time_remaining_frac: float = time_remaining / speed_increase_time
	var speed: float = (max_increased_speed
		- time_remaining_frac * (max_increased_speed - 1))
	set_music_speed(speed)


func set_music_speed(speed: float) -> void:
	Global.music_pitch_shift.pitch_scale = 1 / speed
	for player in song_players:
		player.pitch_scale = speed


func generate_playlist_order() -> void:
	playlist_order.assign(range(-1, len(song_players)))
	playlist_order.shuffle()


func start_default_song() -> void:
	if town_default_songs.has(Global.town.town_int):
		var default_song: int  = town_default_songs[Global.town.town_int]
		var swap_idx: int = playlist_order.find(default_song)
		playlist_order[swap_idx] = playlist_order[-1]
		playlist_order[-1] = default_song


func song_ended() -> void:
	play_next()


func play_next() -> void:
	if len(playlist_order) == 0:
		generate_playlist_order()
	var song: int = playlist_order.pop_back()
	if song == -1:
		$NoMusicTimer.start()
	else:
		song_players[song].play()


func stop_music() -> void:
	$NoMusicTimer.stop()
	for player: AudioStreamPlayer in song_players:
		player.stop()
