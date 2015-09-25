class CirclesMap
  constructor: (@center, @circles) ->
    console.log(this)

  add_feature: (features, circle) ->
    feature = new ol.Feature
      geometry: new ol.geom.Point(@point(circle.location.longitude, circle.location.latitude))
      circle: circle

    features.push feature


  render: (div) ->
    features = []
    for circle in @circles
      @add_feature(features, circle)

    vectorSource = new ol.source.Vector features: features
    vectorLayer  = new ol.layer.Vector source: vectorSource
    rasterLayer  = new ol.layer.Tile
          source: new ol.source.OSM

    map = new ol.Map
      layers: [ rasterLayer, vectorLayer ]
      target: div
      view: new ol.View
        center: @point(@center.longitude, @center.latitude)
        zoom: 14

    for circle in @circles
      @add_marker(map, circle.location)

    # element = document.getElementById('popup')
    #
    # popup = new ol.Overlay
    #   element: element
    #   positioning: 'bottom-center'
    #   stopEvent: false
    #
    # map.addOverlay popup

    map.on 'click', (evt) ->
      feature = map.forEachFeatureAtPixel evt.pixel, (feature, layer) ->
        feature

      if feature
        circle = feature.get('circle')
        console.log circle
        $("#circle_id").val(circle.id)


    map.on 'pointermove', (e) ->
      if e.dragging
        return
      pixel = map.getEventPixel(e.originalEvent)
      hit = map.hasFeatureAtPixel(pixel)
      document.getElementById(map.getTarget()).style.cursor = if hit then 'pointer' else ''






  point: (long, lat) ->
    ol.proj.transform([long, lat], "EPSG:4326", "EPSG:3857")

  add_marker: (map, location) ->
    element = document.createElement("div");
    element.id = "marker-#{location.id}"
    element.className = 'map-marker'
    document.body.appendChild(element)

    marker = new ol.Overlay
      position: @point(location.longitude, location.latitude),
      positioning: 'center-center',
      element: element,
      stopEvent: false

    map.addOverlay(marker);


window.CirclesMap = CirclesMap