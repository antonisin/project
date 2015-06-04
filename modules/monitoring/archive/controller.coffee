@Air.module 'Monitoring.Archive', (Archive, App, Backbone, Marionette, $, _) ->

  class Archive.Controller extends App.Base.Controller
    name: 'monitoring/archive'

    initialize: (opts)->
      collection = App.request 'monitoring:archive:entitie', opts.sipId
      tags = App.request 'monitoring:subcategories:collection:all'

      view = @getView collection, tags

      @show view,
		    loading:
	        entities: [collection, tags]

    getView: (collection, tags) ->
      view = new Archive.CompositeView
        collection: collection
        itemViewOptions:
          tags : tags

      @listenTo view, 'childview:monitoring:archive:click:comment', (view, model) ->
        App.vent.trigger 'monitoring:archive:comment', model

      @listenTo view, 'childview:monitoring:archive:click:tag', (view, model) ->
        App.vent.trigger 'monitoring:archive:tag', model

      @listenTo App.vent, 'monitoring:comment:sync', ->
        collection.fetch
          success: => view.trigger 'refresh'

      @listenTo App.vent, 'monitoring:tag:sync', ->
        collection.fetch
          success: => view.trigger 'refresh'

      view
