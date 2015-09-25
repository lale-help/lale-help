window.CirclesMap = class CirclesMap
  constructor: (@input, @target) ->
    @input.on 'input', @render



  render: () =>
    if (@input.val() == "")
      return
    @target.addClass('map')

    @fetch_data @input.val(), (data) =>
      circles = data.circles
      center = data.center
      console.log(circles)
      console.log center

      map = @get_map()

      # remove markers
      if @overlays
        for overlay in @overlays
          map.removeOverlay(overlay)
          @remove_marker(overlay)
      @overlays = []

      # add markers
      for circle in circles
        marker = @create_marker(circle)
        @overlays.push marker
        map.addOverlay(marker);

      if circles.length > 0
        @select_circle(data: circles[0])

      # re-center
      map.getView().setCenter(@point(center.longitude, center.latitude))
      map.on 'click', (evt) ->
        $(".circle-marker").removeClass('open')

  get_map: =>
    if(@map)
      return @map
    else
      @map = new ol.Map
        layers: [ new ol.layer.Tile(source: new ol.source.OSM) ]
        target: @target[0]
        view: new ol.View
          zoom: 14

  fetch_data: (query, handler) ->
    $.ajax(
      url: "/circles.json",
      data: { location: query }
    ).done(handler)

  point: (long, lat) ->
    ol.proj.transform([long, lat], "EPSG:4326", "EPSG:3857")

  create_marker: (circle) =>
    location = circle.location
    template = HandlebarsTemplates['register/circle_marker'](circle)
    element = $(template)
    $(document.body).append(element)
    $(element).on 'click', circle, @select_circle

    new ol.Overlay
      position: @point(location.longitude, location.latitude),
      positioning: 'center-center',
      element: element,
      stopEvent: false

  remove_marker: (overlay) ->
    el = $(overlay.getElement())
    el.off()
    el.removeClass('open')

  select_circle: (event) ->
    $("input#circle_id").val(event.data.id)
    $("#circle-marker-#{event.data.id}").addClass('open')


