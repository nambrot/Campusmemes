# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  container = $('.photos')
  container.masonry
    itemSelector: '.photo'
    isFitWidth: true
  # loadMoarPhotos()
page = 1
loadMoarPhotos = ->
  container = $('.photos')
  $.get location.href+'/photos.json', {page: page}, (response)->
    $.each response, (index, photo) ->
      image = new Image()
      image.onload = ->
        imagewrap = $('<div class="photo"></div>')
        imagewrap.append image
        container.append imagewrap
        container.masonry('reload')
      console.log(image.class)
      image.src = photo.fullurl

window.Photo = Backbone.Model.extend
  initialize: ->
    this.render()
  render: ->
    image = new Image()
    that = this
    image.onload = ->
      imagewrap = $('<a href="http://www.facebook.com/' +that.get('fbid') + '" class="photo" target="new"></a>')
      imagewrap.href = 'http://www.facebook.com/' + this.fbid
      imagewrap.append image
      that.collection.el.append imagewrap
      that.collection.trigger 'appended'
    image.src = this.attributes.fullurl  
  
window.Photos = Backbone.Collection.extend
  model: window.Photo
  initialize: (s,params)->
    this.loading = false
    this.page = 1
    this.sort = 'likes'
    this.range = 10000000000
    this.el = $('.photos')
    this.college = params.college.toLowerCase()
    this.bind 'appended', this.appended, this
    $('#rangepicker').delegate 'li button', 'click', _.bind(this.rangePicked, this)
    $('#sortpicker').delegate 'li button', 'click', _.bind(this.sortPicked, this)
    this.checkScroll()
  sortPicked: (evt) ->
    $('#sortpicker li button').removeClass 'selected'
    $(evt.target).addClass 'selected'
    this.sort = evt.target.dataset['sort']
    this.resetCollection()
  rangePicked: (evt) ->
    $('#rangepicker li button').removeClass 'selected'
    $(evt.target).addClass 'selected'
    this.range = evt.target.dataset['range']
    this.resetCollection()
  resetCollection: ->
    this.el.children().remove()
    this.reset []
    this.page = 1
    this.fetch()
  checkScroll: ->
    if !this.loading and $(window).scrollTop() + 2*$(window).height() >= this.el.height()
      this.fetch()
    setTimeout(_.bind(this.checkScroll, this), 500)
  fetch: ->
    this.loading = true
    options || (options = {});
    this.trigger("fetching");
    self = this;
    success = options.success;
    options.success = (resp) ->
      self.trigger("fetched");
      if success
        success(self, resp)
    Backbone.Collection.prototype.fetch.call(this, options)
  parse: (resp) -> 
    this.page++
    this.loading = false
    return resp
  appended: ->
    this.el.masonry('reload')
  url: ->
    '/colleges/' + this.college + '/photos'+ '?' + $.param({page: this.page, range: this.range, sort: this.sort})