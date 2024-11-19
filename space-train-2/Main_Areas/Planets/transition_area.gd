extends Area2D
@onready var trans_sound: AudioStreamPlayer = $TransSound

func play_trans_sound():
	trans_sound.play()
