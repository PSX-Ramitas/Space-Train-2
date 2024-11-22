extends Area2D
@onready var trans_sound: AudioStreamPlayer = $TransSound
@onready var buzzer: AudioStreamPlayer = $Buzzer

func play_trans_sound():
	trans_sound.play()
	
func play_buzzer_sound():
	buzzer.play()
