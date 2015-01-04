# word

NOTES = 
	'A' : 0
	'A#': 1
	'Bb': 1
	'B' : 2
	'C' : 3
	'C#': 4
	'Db': 4
	'D' : 5
	'D#': 6
	'Eb': 6
	'E' : 7
	'F' : 8
	'F#': 9
	'Gb': 9
	'G' : 10
	'G#': 11
	'Ab': 11


MODES = 
	"2212221": 'Major/Ionian'
	"2122122": 'Natural minor/Aeolian'
	"22323"  : 'Pentatonic major'
	"32232"  : 'Pentatonic minor'
	"321132" : 'Blues'
	"2122131": 'Harmonic minor'
	"2122221": 'Melodic minor'
	"2122212": 'Dorian'
	"1222122": 'Phrygian'
	"2221221": 'Lydian'
	"2212212": 'Mixolydian'
	"1221222": 'Locrian'

INSTRUMENTS = 
	'Guitar EADGBE':  # E2 - D6 (or E6)
		range: [ 7, 2, 5, 6 ]
	'Piano (88 keys)': # A0 - C8
		range: [ 0, 0, 3, 8 ]


notes_for_value = (val) ->
	(name for name, v of NOTES when v == val)


# scale('A#', '2212221')
scale = (key, mode) ->
	prev_step = 0
	steps = mode.split('').map (tone) -> prev_step += parseInt(tone, 10)
	console.log steps
	key_val = NOTES[key]
	notes = [key]
	for step in steps
		val = step + key_val
		console.log "#{step}: #{val}"
		nv = notes_for_value(val % 12)
		# todo: guard against duplicate notes, eg, A and A# being added.
		notes.push nv[0]
	notes.pop()
	return notes


exports?.scale = scale

