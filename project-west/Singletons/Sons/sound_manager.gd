extends Node

var SoundCategories = []
var SoundsPackage = []
var FadeInSounds = []
var FadeOutSounds = []

func _ready():
	SoundCategories = get_children()


func _process(delta):
	if FadeInSounds.size() > 0:
		handle_fade_in(delta)
	if FadeOutSounds.size() > 0:
		handle_fade_out(delta)


func handle_fade_in(delta):
	# if FadeOutSounds.size() > 0:
	#	return
	
	if not FadeInSounds[0].playing:
		FadeInSounds[0].play()
	
	FadeInSounds[0].volume_db += float(delta) * 10
	
	var target_volume = 0
	if FadeInSounds[0].volume_db >= target_volume:
		FadeInSounds.pop_front()


func handle_fade_out(delta):
	FadeOutSounds[0].volume_db -= float(delta) * 10

	if FadeOutSounds[0].volume_db <= -70:
		FadeOutSounds[0].stop()
		FadeOutSounds.pop_front()


func category_finder(index : int, name : String, parallel : bool):
	match index:
		0:
			SoundsPackage = SoundCategories[0].get_children()
		1:
			SoundsPackage = SoundCategories[1].get_children()
		2:
			SoundsPackage = SoundCategories[2].get_children()
		3:
			SoundsPackage = SoundCategories[3].get_children()
	
	for audio in SoundsPackage:
		if audio is AudioStreamPlayer and audio.name == name:
			if parallel:
				audio.volume_db = 0
				audio.play()
			else:
				var target_audio = category_search_and_pick_by_name(index, name)
				if FadeInSounds.has(target_audio) or target_audio.playing:
					return
				target_audio.volume_db = -80
				FadeInSounds.append(target_audio)


func category_search(index):
	var SoundPlaying = SoundCategories[index].get_children()

	for audio in SoundPlaying:
		if audio is AudioStreamPlayer and (audio.playing or FadeInSounds.has(audio)):
			return true

	return false


func category_search_and_pick(index):
	var SoundPlaying = SoundCategories[index].get_children()

	for audio in SoundPlaying:
		if audio is AudioStreamPlayer and audio.playing:
			return audio

	return null


func category_search_and_pick_by_name(index, name):
	var SoundPlaying = SoundCategories[index].get_children()

	for audio in SoundPlaying:
		if audio is AudioStreamPlayer and audio.name == name:
			return audio

	return null


func category_stop(index):
	var SoundPlaying = SoundCategories[index].get_children()

	for audio in SoundPlaying:
		if audio is AudioStreamPlayer:
			if audio.playing:
				FadeOutSounds.append(audio)
			if FadeInSounds.has(audio):
				FadeInSounds.erase(audio)


func category_pause_stream(index):
	var SoundPlaying = SoundCategories[index].get_children()

	for audio in SoundPlaying:
		if audio is AudioStreamPlayer and audio.playing:
			audio.stream_paused = true


func category_unpause_stream(index):
	var SoundPlaying = SoundCategories[index].get_children()

	for audio in SoundPlaying:
		if audio is AudioStreamPlayer and audio.stream_paused:
			audio.stream_paused = false
