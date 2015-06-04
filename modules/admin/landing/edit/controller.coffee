@Air.module 'Admin.Landings.Edit', (Edit, App, Backbone, Marionette, $, _) ->
  class   Edit.EditController extends App.Base.Controller
    name: 'admin/landings/edit'

    initialize: (opts) ->
      @region     = opts.region
      @model      = opts.model
      @layout     = @getLayout()
      @directions = App.request 'landing:directions:entitie'

      @listenTo @layout, 'show' , =>
        @showLanding()
        @showLandingItems()

      @show @layout, 
        loading:
          type: 'opacity'
          entities: [@model]

    getLayout: ->
      new Edit.Layout

    showLanding: ->
      view = new Edit.LandingView
        model     : @model
        directions: @directions

      @listenTo view ,'landing:item:add', (model) ->
        @collection.push App.request 'landing:item:new:entity' , model.id

      @layout.landing.show view

    showLandingItems: ->
      @collection = App.request 'landing:item:entitie', @model 
      view = new Edit.LandingItems
        collection: @collection
        itemViewOptions     : 
          landing : @model

      @listenTo view, 'childview:landing:item:delete', (el,model)=>
        App.execute 'show:confirm', App.request('lang:get', 'landing:delete:confirm',[model.id]), ->
          if model.id
            model.destroy
              wait:true
              success: =>
                App.execute 'notify:success', App.request('lang:get', 'landing:item:delete:success')
          else
            model.trigger 'destroy', model, model.collection
            App.execute 'notify:success', App.request('lang:get', 'landing:item:delete:success')

      @layout.landingItems.show view