@Air.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  App.commands.setHandler "when:fetched", (entities, success, fail) ->
    xhrs = _.chain([entities]).flatten().pluck("_fetch").value()

    $.when(xhrs...).then (->success()), (->fail())

  class Entities.BaseModel extends Backbone.Model
    _isBusy: false

    initialize: (attributes, options = {}) ->
      super
      @bind 'error', @defaultErrorHandler
      @init and @init(attributes, options)

    save: ->
      @_isBusy = true
      @listenToOnce @, 'sync', =>
        @_isBusy = false

      super

    isBusy: ->
      @_isBusy

    fetch: (opts = {}) ->

      opts.error = _.bind API.fetchError, @
      super opts

    defaultErrorHandler: (model, error) ->
      if error.status == 401 || error.status == 403 || error.status == 500
        API.fetchError error

    API =
      fetchError: (response) ->
        _.each window.requests, (xhr) ->
          xhr.abort()
        window.requests = []

        App.vent.trigger 'fetch:error', $.parseJSON(response.responseText)?.errors

  class Entities.BaseCollection extends Backbone.Collection

    initialize: (attributes, options = {}) ->
      @bind 'error', @defaultErrorHandler
      @init and @init(attributes, options)

    defaultErrorHandler: (model, error) ->
      if error.status == 401 || error.status == 403 || error.status == 500
        API.fetchError error

    API =
      fetchError: (response) ->
        _.each window.requests, (xhr) ->
          xhr.abort()
        window.requests = []

        App.vent.trigger 'fetch:error', response.responseText

  App.vent.on 'fetch:error', (errors) ->
    App.execute 'show:error', errors