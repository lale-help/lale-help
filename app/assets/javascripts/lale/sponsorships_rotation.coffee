class Lale.SponsorshipsRotation

  slideDisplayTimeInSeconds: 10 #(3 * 60)

  constructor: (slides_selector) ->
    this.slidesSelector = slides_selector
    this.currentSlideNr = 1 # the first slide is already set visible with CSS
    this.totalSlides    = $(this.slidesSelector).length
    setInterval(this.animate, 1000)

  # changing slides is implemented independently of page reloads on purpose
  # every n seconds a new slide will be shown, no matter how long the page has already been visible. 
  # this should give even display time to each slide, no matter if/how often the page is reloaded
  animate: =>
    if this.shouldShowNextSlide()
      console.log("showing next slide ...")
      slideNr = this.getNextSlideNr()
      this.showSlide(slideNr, 'slow')
      this.currentSlideNr = slideNr

  refresh: ->
    console.log("refresh")
    console.log("currentSlideNr", this.currentSlideNr)
    this.showSlide(this.currentSlideNr, "fast")

  showSlide: (slideNr, animationSpeed) ->
    allSlides = $(this.slidesSelector)
    nextSlide = $(allSlides[slideNr])
    allSlides.fadeOut(animationSpeed)
    nextSlide.fadeIn(animationSpeed)

  shouldShowNextSlide: -> 
    unixTimeInSeconds = parseInt(Date.now() / 1000)
    secondsSinceLastChange = unixTimeInSeconds % this.slideDisplayTimeInSeconds
    console.log(secondsSinceLastChange)
    secondsSinceLastChange == 0

  getNextSlideNr: ->
    (this.currentSlideNr % this.totalSlides - 1) + 1

