((win, ko) ->

	scale = win.scale
	
	model = 
		instruments: (x for x of scale.INSTRUMENTS)
		instrument: ko.observable()
		modes: ({ key: k, value: v } for k,v of scale.MODES)
		mode: ko.observable()
		keys: (x for x of scale.NOTES)
		key: ko.observable()
		measures: [1,2,3,4]
		measure: ko.observable()
		times: ['4/4']
		time: ko.observable()
		bpms: ({key: x * 10, value: "#{ x * 10} bpm" for x in [3..15])
		bpm: ko.observable()
		random_modes: [ 
			{ name: 'random_first', desc: 'Random first, afterwards sequential' }
			{ name: 'random_one_octave', desc: 'Random, dense (within an 8ve)' }
			{ name: 'random_two_octaves', desc: 'Random, sparser (within two 8ve}' }
			{ name: 'random_notes', desc: 'All random' }
		random_mode: ko.observable()
		go: ->
			keys = ['mode', 'key', 'measure', 'time', 'bpm', 'random_mode']
			dict = ""
			for k in keys
				dict = "#{ dict }&#{ k }" + urlencode(model[k]())	
			window.location = "scale.html?#{ dict }"

	ko.applyBindings(model)
)(this, ko)
