extends GridContainer

onready var start_input: LineEdit = $StartBPM
onready var end_input: LineEdit = $EndBPM
onready var length_input: LineEdit = $Length
onready var player: AudioStreamPlayer = $AudioStreamPlayer
onready var timer: Timer = $Timer
onready var time_elapsed_label: Label = $TimeElapsedLabel

var keep_speeding_up = true

var active := false
var first_tick_duration := 0.0
var elapsed_time := 0.0
var next_tick_duration := 0.0
var next_tick_time := 0.0
var slope := 0.0

func _process(delta):
	if not active:
		return
	elapsed_time += delta
	time_elapsed_label.text = "%d s" % elapsed_time 
	if elapsed_time > next_tick_time:
		player.play()
		next_tick_time += first_tick_duration - (slope * elapsed_time)
		print(active, " ", elapsed_time, " ", first_tick_duration - (slope * elapsed_time), " ", next_tick_time)

func bpm_text_to_sec(bpm):
	return 60 / float(bpm)

func seconds_text_to_sec(seconds):
	return float(seconds)

func start_metronome():
	first_tick_duration = bpm_text_to_sec(start_input.text)
	var last_tick_duration = bpm_text_to_sec(end_input.text)
	var full_duration = seconds_text_to_sec(length_input.text)

	active = true
	elapsed_time = 0.0
	next_tick_time = 0.0
	slope = (first_tick_duration - last_tick_duration) / full_duration
	print("dkfjdkfjk", first_tick_duration, " ", last_tick_duration, " ", full_duration)
	print("Start", start_input.text, " ", end_input.text, " ", length_input.text, " ", slope)

func stop_metronome():
	active = false
	time_elapsed_label.text = "0 s"
	print("Stop")

func _on_StartButton_toggled(button_pressed):
	if button_pressed:
		start_metronome()
		$StartButton.text = "Stop"
	else:
		stop_metronome()
		$StartButton.text = "Start"
