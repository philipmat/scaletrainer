((win, ko) ->

	scale = win.scale
	
	model = 
		instruments: (x for x of scale.INSTRUMENTS)
		instrument: ko.observable()
		modes: ({ key: k, name: v } for k,v of scale.MODES)
		mode: ko.observable()
		keys: (x for x of scale.NOTES)
		key: ko.observable()
		measures: [1,2,3,4]
		measure: ko.observable()
		times: ['4/4', '3/4', '2/4', '6/8']
		time: ko.observable()
		bpms: ({key: x, name: "#{ x } bpm"} for x in [30..150] by 10)
		bpm: ko.observable()
		random_modes: [ 
			{ name: 'random_first', desc: 'Random first, afterwards sequential' }
			{ name: 'random_one_octave', desc: 'Random, dense (within an 8ve)' }
			{ name: 'random_two_octaves', desc: 'Random, sparser (within two 8ve}' }
			{ name: 'random_notes', desc: 'All random' }
		]
		randomness: ko.observable()
		autoadvance: ko.observable true
		go: ->
			keys = (k for k of model when ko.isObservable model[k])
			console.log keys
			dict = ""
			for k in keys
				dict = "#{ dict }&#{ k }=" + encodeURI(model[k]())	
			window.location = "scale.html?#{ dict }"
			

	model.clear = ->
			window.localStorage?.removeItem 'scaletrainer.values'
			for k, v of model
				if ko.isObservable model[k]
					model[k](null)

	prev = window.localStorage?.getItem 'scaletrainer.values'
	if prev
		prevObject = JSON.parse prev
		for k, v of prevObject 
			model[k]?(v)
	ko.applyBindings(model)
)(this, ko)
