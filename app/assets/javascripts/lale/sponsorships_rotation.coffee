class Lale.SponsorshipsRotation

  slideDisplayTimeInSeconds: 10 #(3 * 60)

  constructor: (slides_selector) ->
    this.slides           = $(slides_selector)
    this.slides.currentNr = 1 # the first slide is already set visible with CSS
    setInterval(this.animate, 1000)

  # changing slides is implemented independently of page reloads on purpose
  # every n seconds a new slide will be shown, no matter how long the page has already been visible. 
  # this should give even display time to each slide, no matter if/how often the page is reloaded
  # for best results the slide divs are rendered into the HTML in random order.
  animate: =>
    if this.shouldShowNextSlide()
      nextSlide = $(this.slides[this.getNextSlideNr()])
      this.slides.fadeOut('slow')
      nextSlide.fadeIn('slow')
      this.slides.currentNr += 1

  shouldShowNextSlide: -> 
    unixTimeInSeconds = parseInt(Date.now() / 1000)
    secondsSinceLastChange = unixTimeInSeconds % this.slideDisplayTimeInSeconds
    secondsSinceLastChange == 0

  getNextSlideNr: ->
    (this.slides.currentNr % this.slides.length - 1) + 1

