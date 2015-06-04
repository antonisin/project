do (Backbone) ->
  _sync = Backbone.sync
  window.requests = []

  Backbone.sync = (method, entity, options = {}) ->

    options.complete = API.complete

    sync = _sync(method, entity, options)
    window.requests.push sync

    if !entity._fetch and method is "read"
      entity._fetch = sync
    sync

  API = 
    complete: (xhr) ->
      window.requests = _.reject window.requests, (el)-> el is xhr