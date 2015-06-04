@Air.module 'Lid.View', (View, App, Backbone, Marionette, $, _) -> 

  class View.ExtraPhonesController extends App.Base.Controller
    initialize: ->
      @listenTo @, 'refresh:this:view'         , => @showView()
      @listenTo @, 'extra:add:phone:controller', => @addModel()
      @showView()

    addModel: ->
      if @collection.where({'phone': ''}).length == 0
        model = App.request 'extra:phone:model' , @model.id
        @collection.add model

    showView: ->
      if @model.id
        @collection = App.request 'extra:phones:collection', @model.get('extraPhones')
        @show @getView()
        
    getView: ->
      new View.ExtraPhoneAll
        collection: @collection
        itemViewOptions: 
          lidModel : @model