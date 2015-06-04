@Air.module 'Admin.Main.List', (List, App, Backbone, Marionette, $, _) ->
  class List.ListController extends App.Base.Controller
    name: 'admin/main/list'

    initialize: ->
      @layout = @getLayout()
      testimonials =  App.request 'admin:main:testimonial:collection'

      @layout.on 'show', =>
        @getSlider()
        @getTravel()
        @getTestimonial testimonials

      App.vent.trigger 'admin:item:load'
      App.execute "when:fetched",testimonials, (=> 
        @show @layout, 
          loading:
            entities: [testimonials]
        App.vent.trigger 'admin:item:load'
      ), (=>)

    getLayout: ->
      new List.Layout

    getSlider: ->
      collection = App.request 'admin:main:slider:collection'

      view = new List.Slider
        collection: collection

      @layout.slider.show view

      @listenTo view,  'childview:slider:model:destroy', (opts) ->
        App.execute 'show:confirm', App.request('lang:get', 'main:slider:delete:confirm', [opts.model.id]), ->
          App.execute 'notify:success', App.request('lang:get', 'slider:delete:success')
          opts.model.destroy
            wait:true

      @listenTo view, 'admin:main:slider:add', ->
        App.vent.trigger 'admin:main:slider:new:model'

      @listenTo App.vent, 'admin:main:slider:fetch', (model) =>
        collection.fetch()

      @listenTo App.vent , 'admin:slider:fetch', ->
        collection.fetch()

      view

    getTravel: ->
      collection = App.request 'admin:main:travel:collection'

      view = new List.Travel
        collection: collection
      
      @layout.travel.show view
      
      @listenTo view, 'admin:travel:sortable', (array)-> @sortableTravel array, collection

      view

    getTestimonial:(collection) ->
      view = new List.Testimonial
        collection: collection

      @layout.testimonial.show view

      App.execute "when:fetched", collection, (=>
        @layout.testimonial.show view 
      ), (=>)

      @listenTo view, 'admin:main:testimonial:add', -> 
        App.vent.trigger 'admin:main:testimonial:new:model'

      @listenTo view, 'childview:testimonial:edit:model', (model) -> 
        App.vent.trigger 'admin:main:testimonial:edit', model

      @listenTo view , 'childview:testimonial:delete:model' , (opts) -> 
        App.execute 'show:confirm', App.request('lang:get', 'main:testimonial:delete:confirm', [opts.model.id]), ->
          App.execute 'notify:success', App.request('lang:get', 'testimonial:delete:success')
          opts.model.destroy
            wait:true
            success: =>
              App.vent.trigger 'admin:main:testimonial:sync'

      @listenTo App.vent, 'admin:main:testimonial:sync',  ->
        collection.fetch
          success: => view.trigger 'refresh'

      view
      
    sortableTravel : (array, models) ->
      array.each (index, element) -> 
        models.where({'id': parseInt(element.getAttribute('data')) })[0].set('order', index + 1)
       
      models.forEach (model, index) ->
        model.save()
