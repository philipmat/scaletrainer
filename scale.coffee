((module)->
	NOTES = 
		'C' : 0
		'C#': 1
		'Db': 1
		'D' : 2
		'D#': 3
		'Eb': 3
		'E' : 4
		'F' : 5
		'F#': 6
		'Gb': 6
		'G' : 7
		'G#': 8
		'Ab': 8
		'A' : 9
		'A#':10
		'Bb':10
		'B' :11

	NOTES_BY_VAL = 
		0: ['C']
		1: ['C#', 'Db']
		2: ['D']
		3: ['D#', 'Eb']
		4: ['E']
		5: ['F']
		6: ['F#', 'Gb']
		7: ['G']
		8: ['G#', 'Ab']
		9: ['A']
		10: ['A#', 'Bb']
		11: ['B']

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
		'Guitar EADGBE':  # E2 - D6 (or E6 or C#6)
			range: [ 4, 2, 2, 6 ]
		'Piano (88 keys)': # A0 - C8
			range: [ 9, 0, 0, 8 ]
		# 7 string guitar BEADGBE B1 - D6
		# Bass EADG E1 - 

	TIME = 
		4: '4/4'
		3: '3/4'
		7: '7/8'


	# Random number between min and max, both inclusive
	random = (min, max) ->
		Math.floor(Math.random() * (max + 1 - min)) + min


	# Converts from bpm to milliseconds
	bpm_to_ms = (bpm) ->
		60 * 1000 / bpm


	# First element that matches
	first = (col, predicate, from_end = false) ->
		col = if from_end then col.reverse() else col
		for x in col
			if predicate(x)
				return x
		return undefined


	last = (col, predicate) ->
		first col, predicate, true


	# Produces the notes of the scale for a given key and mode:
	# scale('C', '2212221') => CDEFGAB
	# scale('C', 'Major/Ionian') => CDEFGAB
	scale = (key, mode) ->
		mode_keys = Object.keys MODES
		if mode not in mode_keys
			actual_mode = null
			for k,v of MODES
				if v == mode
					actual_mode = k
					break
			if not actual_mode
				return []
			mode = actual_mode

		prev_step = 0
		steps = mode.split('').map (tone) -> prev_step += parseInt(tone, 10)
		# console.log steps
		key_val = NOTES[key]
		notes = [{'note': key, value: NOTES[key]}]
		for step in steps
			val = step + key_val
			# console.log "#{step}: #{val}"
			numeric_note = val % 12
			nv = NOTES_BY_VAL[numeric_note]
			# todo: guard against duplicate notes, eg, A and A# being added.
			note = { note: nv[0], value: numeric_note }
			notes.push note
		notes.pop()
		return notes


	# Produces an instrument's range given a scale ({ note: 'A', value: 0 })
	# instrument_scale 'Guitar EADGBE', scale 'C', 'Major/Ionian'
	# instrument_scale INSTRUMENTS['Guitar EADGBE'], scale 'C', '2212221'
	# Output:
	# array of objects { note: 'F', value: 8, octave: 4 }
	instrument_scale = (instrument, scale) ->
		range = if instrument.hasOwnProperty 'range'
			instrument.range
		else
			INSTRUMENTS[instrument].range
		[first_note, first_octave, last_note, last_octave] = range

		# notes as an array
		scale_notes = scale.map (note) -> note.note
		all_notes = []

		start = first_note + first_octave * 12
		end = last_note + last_octave * 12
		for x in [start...end]
			note_val = x % 12
			notes_for_val = NOTES_BY_VAL[note_val]
			found = null
			for note in notes_for_val
				if note in scale_notes 
					found = note
					break

			if found
				all_notes.push { note: found, value: note_val, octave: ~~(x/12) }

		return all_notes


	# Given a random mode, a scale, a time, and and instrument it produces
	# a measure of random notes

	random_max = (instrument_scale, number_of_notes) ->
		range = instrument_scale.length - 1
		notes = []
		for x in [1..number_of_notes]
			rnd = random 0, range
			notes.push instrument_scale[rnd]

		return notes

	
	random_first = (instrument_scale, number_of_notes) ->
		range = instrument_scale.length - 1
		first = random 0, range - number_of_notes
		notes = []

		for x in [0...number_of_notes]
			notes.push instrument_scale[first + x]

		return notes


	random_one_octave = (instrument_scale, number_of_notes, notes_range = 8) ->
		range = instrument_scale.length - 1
		root_pos = random 0, range
		console.log "root = #{ root_pos } / #{ range }"
		[min, max] = [Math.max(root_pos - notes_range, 0), Math.min(root_pos + notes_range, range)]

		console.log "#{ min } - #{ max }"
		notes = [instrument_scale[root_pos]]
		for x in [2..number_of_notes]
			rnd = random min, max
			note = instrument_scale[rnd]
			console.log "#{ rnd }: ", note
			notes.push note

		return notes


	random_two_octaves = (instrument_scale, number_of_notes) ->
		return random_one_octave instrument_scale, number_of_notes, 16


	module?.scale = scale
	module?.bpm_to_ms = bpm_to_ms
	module?.instrument_scale = instrument_scale
	module?.INSTRUMENTS = INSTRUMENTS
	module?.random_notes = random_max
	module?.random_first = random_first
	module?.random_one_octave = random_one_octave
	module?.random_two_octaves = random_two_octaves
	module?.print_note = (n) ->
		n['note'] + n['octave']
	module?.print_note_html = (n) ->
		"<span class='octave-note'><span class='note'>#{ n['note'] }</span><span class='octave'>#{ n['octave'] }</span></span>"
		
)(exports ? this['scale'] = {})
