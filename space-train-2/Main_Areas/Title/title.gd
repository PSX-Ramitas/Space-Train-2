extends Control

@onready var start: Button = $Start
@onready var quit: Button = $Quit
@onready var options: Button = $Options
@onready var settings: Control = $Settings
@onready var button_press: AudioStreamPlayer = $"../Sounds/ButtonPress"
@onready var back_button_press: AudioStreamPlayer = $"../Sounds/BackButtonPress"
@onready var transition_anim: TransitionScreen = $"../CanvasLayer/TransitionAnim"
@onready var planet: AnimatedSprite2D = $"../Sprites/Planet"
@onready var bg_planets: Sprite2D = $"../Sprites/BGPlanets"
@onready var title: Label = $"../Label"


func _on_start_pressed() -> void:
	button_press.play()
	transition_anim.play_transition("FadeOut")
	await transition_anim.anim_finished
	get_tree().change_scene_to_file("res://Main_Areas/Spaceship/Scenes/spaceship.tscn")

func _on_options_pressed() -> void:
	button_press.play()
	start.visible = false
	options.visible = false
	quit.visible = false
	settings.visible = true
	planet.visible = false
	bg_planets.visible = false
	title.visible = false
	
func _on_quit_pressed() -> void:
	back_button_press.play()
	transition_anim.play_transition("FadeOut")
	await transition_anim.anim_finished
	get_tree().quit()

func _on_settings_back_button() -> void:
	button_press.play()
	start.visible = true
	options.visible = true
	quit.visible = true
	settings.visible = false
	planet.visible = true
	bg_planets.visible = true
	title.visible = true
