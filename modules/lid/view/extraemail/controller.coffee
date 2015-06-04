@Air.module 'Lid.View', (View, App, Backbone, Marionette, $, _) -> 

	class View.ExtraEmailsController extends App.Base.Controller
    initialize: ->
      @showView()
      
      @listenTo @, 'refresh:this:view'         , => @showView()
      @listenTo @, 'extra:add:email:controller', => @addModel()

    showView:->
      if @model.id
        @collection  = App.request 'extra:emails:collection' , @model.get('extraEmails')
        @show @getView()
    
    addModel: ->
      if @collection.where({'email': ''}).length == 0
        model = App.request 'extra:email:model' , @model.id
        @collection.push model

    getView: ->
      new View.ExtraEmailAll
        collection: @collection
        itemViewOptions: 
          lidModel : @model