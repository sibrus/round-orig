window.App =
  idleTimeout: 60000
  pollInterval: 7000
  start: ->
    log.setLevel log.levels.DEBUG
    @csrf_token = ($ 'meta[name="csrf-token"]').attr('content')
    @$spinner   = ($ '#app-spinner')
    @setupAjax()

    ($ '#queue-link').on 'click', => page '/queue'
    ($ '#search-link').on 'click', => page '/search'
    ($ '#browse-link').on 'click', => page '/browse'
    ($ document).on 'click', => @touched()

    @artists = new Backbone.Collection
    @artists.comparator = 'sort_name'
    @artists.add window.artists

    @genres = new Backbone.Collection
    @genres.comparator = 'name'
    @genres.add window.genres

    @subViews =
      idle: new @IdleView el: ($ '#idle')
      browse: new @BrowseView el: ($ '#browse')
      queue: new @QueueView
        el: ($ '#queue')
        type: 'track'
        heading: 'Play Queue'
        emptyMessage: 'Play Queue is Empty!'
      tim: new @TimView el: ($ '#tim')

    _.each @subViews, (view) -> view.render()

    setInterval =>
      $.get "/player/status?now=#{Date.now()}", (response) =>
        nowPlaying = if response.now_playing? then new Backbone.Model(response.now_playing) else null
        @playerStatus =
          nowPlaying: nowPlaying
          queue: new Backbone.Collection response.queue
        @trigger 'player status update'
    , @pollInterval

    @lastTouchAt = Date.now()
    setTimeout =>
      setInterval =>
        @checkLastTouch()
      , 2000
    , 300

    page()

  show: (viewToShow) ->
    @touched()
    _.each @subViews, (view, key) ->
      if key == viewToShow then view.show() else view.hide()

  browse: (type, id) ->
    @subViews.browse.reset type, id
    @show 'browse'

  touched: ->
    @lastTouchAt = Date.now()

  checkLastTouch: ->
    return if @subViews.idle.shown
    if Date.now() - @lastTouchAt > @idleTimeout
      page '/idle'

  setupAjax: ->
    spinnerTimeout = null

    ($ document).on 'ajaxSend', (event, xhr) =>
      if spinnerTimeout
        clearTimeout spinnerTimeout
        spinnerTimeout = null

      @$spinner.removeClass('icon-usd').addClass('icon-spin icon-spinner')
      xhr.setRequestHeader 'X-CSRF-Token', @csrf_token
      xhr.setRequestHeader 'Accept', 'application/json'
      xhr.cache = false

    ($ document).on 'ajaxError', (args...) =>
      log.debug "request error", args...

    ($ document).on 'ajaxComplete', =>
      spinnerTimeout = setTimeout =>
        @$spinner.removeClass('icon-spin icon-spinner').addClass('icon-usd')
      , 500


_.extend App, Backbone.Events
