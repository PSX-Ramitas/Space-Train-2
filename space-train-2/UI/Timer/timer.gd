extends Panel

var time: float = 0.0
var minutes: int = 0
var seconds: int = 0
var msec: int = 0
var timer_started: bool

signal timed_out

func set_timer(timeVal: float) -> void:
	time = timeVal
	msec = fmod(time, 1.0) * 100.0
	seconds = fmod(time, 60.0)
	minutes = fmod(time, 3600.0) / 60.0
	$HBoxContainer/Minutes.text = "%02d: " % minutes
	$HBoxContainer/Seconds.text = "%02d. " % seconds
	$HBoxContainer/Milliseconds.text = "%03d" % msec

func start_timer() -> void:
	timer_started = true

func _ready() -> void:
	clamp(time, 0, 999999999999)
	timer_started = false

func _process(delta: float) -> void:
	if timer_started:
		time -= delta
		msec = fmod(time, 1.0) * 100.0
		seconds = fmod(time, 60.0)
		minutes = fmod(time, 3600.0) / 60.0
		$HBoxContainer/Minutes.text = "%02d: " % minutes
		$HBoxContainer/Seconds.text = "%02d. " % seconds
		$HBoxContainer/Milliseconds.text = "%03d" % msec
		if time <= 0.0:
			stop_timer()
			timed_out.emit()

func stop_timer() -> void:
	set_process(false)
