@Air.module 'Header.User', (User, App, Backbone, Marionette, $, _) ->

  class User.DropdownController extends App.Base.Controller
    initialize:  ->
      @collection = App.request 'notification:entities', @model.get('id')

      view = @getView()
      @fetchCollection()

      @listenTo @collection, 'sync', => view.render()

    fetchCollection: ->
      @interval = setInterval =>
        @collection.fetch({reset: true, silent: true})
      ,60000

    getView: ->
      view = new User.DropdownListView
        collection: @collection

      @listenTo view , 'childview:close:task', (view) ->
        @sendXHR 'notification/hide/' + view.model.id
        @collection.remove view.model
        if @collection.isEmpty()
          view.trigger 'add:empty:task'

      view
