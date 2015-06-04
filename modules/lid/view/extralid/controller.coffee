@Air.module 'Lid.View', (View, App, Backbone, Marionette, $, _) ->

  class View.ExtraLidController extends App.Base.Controller
    initialize: ->
      @showView()

      @listenTo @, 'refresh:this:view'       , => @showView()
      @listenTo @, 'extra:lid:add:controller', => @addModel()

    showView: ->
      if @model.id
        @collection =  App.request 'extra:lid:collection' , @model.get('extraLids')
        @show @getView()
      
    addModel: ->
      if @collection.where({'extraFirstName' : '', 'extraLastName':''}).length == 0
        @collection.push App.request('extra:lid:model', @model.id)

    getView: ->
      new View.ExtraLidAllView
        collection: @collection
        itemViewOptions: 
          lidModel : @model