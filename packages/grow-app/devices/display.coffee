class Device.DisplayComponent extends UIComponent
  @register 'Device.DisplayComponent'

  onCreated: ->
    super

    @currentDeviceUuid = new ComputedField =>
      FlowRouter.getParam 'uuid'

    @autorun (computation) =>
      deviceUuid = @currentDeviceUuid()
      return unless deviceUuid

      @subscribe 'Device.one', deviceUuid

      @subscribe 'Data.points', deviceUuid

    @autorun (computation) =>
      return unless @subscriptionsReady()

      device = Device.documents.findOne
        uuid: @currentDeviceUuid()
      ,
        fields:
          title: 1

  onRendered: ->
    n = 40
    random = d3.random.normal(5, .2)
    # phdata = Data.find({},{'body.pH': 1})
    # console.log(random)
    
    data = d3.range(n).map(random)
    margin = 
      top: 20
      right: 20
      bottom: 20
      left: 40
    width = 960 - (margin.left) - (margin.right)
    height = 500 - (margin.top) - (margin.bottom)
    x = d3.scale.linear().domain([
      0
      n - 1
    ]).range([
      0
      width
    ])
    y = d3.scale.linear().domain([
      0
      14
    ]).range([
      height
      0
    ])
    line = d3.svg.line().x((d, i) ->
      x i
    ).y((d, i) ->
      y d
    )
    svg = d3.select('#graph').append('svg').attr('width', width + margin.left + margin.right).attr('height', height + margin.top + margin.bottom).append('g').attr('transform', 'translate(' + margin.left + ',' + margin.top + ')')
    svg.append('defs').append('clipPath').attr('id', 'clip').append('rect').attr('width', width).attr 'height', height
    svg.append('g').attr('class', 'x axis').attr('transform', 'translate(0,' + y(0) + ')').call d3.svg.axis().scale(x).orient('bottom')
    svg.append('g').attr('class', 'y axis').call d3.svg.axis().scale(y).orient('left')
    path = svg.append('g').attr('clip-path', 'url(#clip)').append('path').datum(data).attr('class', 'line').attr('d', line)

    tick = ->
      # push a new data point onto the back -- need to push from our stream
      data.push random()
      # redraw the line, and slide it to the left
      path.attr('d', line).attr('transform', null).transition().duration(500).ease('linear').attr('transform', 'translate(' + x(-1) + ',0)').each 'end', tick
      # pop the old data point off the front
      data.shift()
      return

    tick()

  events: ->
    super.concat
      'click .acid': @onAcid
      'click .base': @onBase

      'click .glyphicon-chevron-left': (event) =>
        currentValue = @$('#set-ph').val()
        currentValue = parseFloat(currentValue) - 0.1
        @$('#set-ph').val(currentValue)

      'click .glyphicon-chevron-right': (event) =>
        currentValue = @$('#set-ph').val()
        currentValue = parseFloat(currentValue) + 0.1
        @$('#set-ph').val(currentValue)

  onAcid: (event) ->
    event.preventDefault()

    Meteor.call 'Device.sendCommand', @currentDeviceUuid(), 'acid', 5, (error) ->
      console.log "Error", error if error

  onBase: (event) ->
    event.preventDefault()

    Meteor.call 'Device.sendCommand', @currentDeviceUuid(), 'base', 5, (error) ->
      console.log "Error", error if error

  device: ->
    Device.documents.findOne
      uuid: @currentDeviceUuid()

  datapoints: ->
    Data.documents.find
      'device._id': @device()?._id

  notFound: ->
    @subscriptionsReady() and not @device()

FlowRouter.route '/device/:uuid',
  name: 'Device.display'
  action: (params, queryParams) ->
    BlazeLayout.render 'MainLayoutComponent',
      main: 'Device.DisplayComponent'
