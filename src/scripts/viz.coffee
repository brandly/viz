
w = window
requestFrame = w.requestAnimationFrame or w.mozRequestAnimationFrame or w.webkitRequestAnimationFrame or w.oRequestAnimationFrame
noop = ->

class Repeater
  request: null
  constructor: (fn) ->
    @setFunction fn

  setFunction: (fn) ->
    @fn = =>
      fn()
      @start()

  start: ->
    @request = requestFrame @fn

  stop: ->
    if @request
      w.cancelAnimationFrame @request
      @request = null

class Viz
  constructor: (@id, {@frequency, @time}) ->
    @element = document.getElementById @id
    unless @element
      throw "No element found with id \"#{id}\""

    audio = @element.getElementsByTagName 'audio'
    if audio.length
      @audio = audio[0]
    else
      throw "No <audio> element found inside ##{id}"

    canvas = @element.getElementsByTagName 'canvas'
    if canvas.length
      @canvas = canvas[0]
    else
      throw "No <canvas> element found inside ##{id}"

    @canvasContext = @canvas.getContext '2d'
    audioContext = new webkitAudioContext
    @analyser = audioContext.createAnalyser()

    # Wire the audio into the analyser
    source = audioContext.createMediaElementSource @audio
    source.connect @analyser
    @analyser.connect audioContext.destination

    @audio.addEventListener 'play', @start.bind(this), false

    boundStop = @stop.bind(this)
    @audio.addEventListener 'pause', boundStop, false
    @audio.addEventListener 'ended', boundStop, false

  repeater: new Repeater
  start: ->
    frequencyFrame = =>
      fbcArray = new Uint8Array @analyser.frequencyBinCount
      @analyser.getByteFrequencyData fbcArray
      @frequency(fbcArray, @canvasContext, @canvas)

    timeFrame = =>
      fbcArray = new Uint8Array @analyser.frequencyBinCount
      @analyser.getByteTimeDomainData fbcArray
      @time(fbcArray, @canvasContext, @canvas)

    unless @frequency
      frequencyFrame = noop
    unless @time
      timeFrame = noop

    @repeater.setFunction =>
      @canvas.width = @canvas.width
      frequencyFrame()
      timeFrame()

    @repeater.start()

  stop: ->
    @repeater.stop()

window.Viz = Viz
