@Air.module 'Admin.Landings.List', (List, App, Backbone, Marionette, $, _) ->
  class List.ListItem extends Air.BaseItemView
    template: 'admin/landing/list/item'
    tagName : 'tr'
    events:
      'click #edit'   : (e) -> 
        e.stopImmediatePropagation()
        @trigger 'click:edit', @model

      'click #delete'   : (e) -> 
        e.stopImmediatePropagation()
        @trigger 'click:delete', @model

      'click td'   : (e) -> 
        @trigger 'click:edit', @model

      'click #active' : (e) ->
         e.stopImmediatePropagation()
         @$('#active').toggleClass 'green red'
         @$('#active').find('i').toggleClass 'fa-check fa-times'
         @updatePublic()

    updatePublic: ->
      if @model.get('isPublic') is 0 then @model.set('isPublic', 1) else @model.set('isPublic', 0)
      @model.save()

  class List.ListView extends Air.BaseCompositeView
    template              : 'admin/landing/list/layout'
    itemView              : List.ListItem
    itemViewContainer     : 'tbody'
    triggers:
      'click #add'        : 'item:add'  

    initialize: ->
      @listenTo @, 'refresh', @render

    onDomRefresh: ->
      @initDT()

    initDT: ->
      App.Utils.DT.initDT '#lidstable', 
        sort: [0, 'asc']
        initComplete: (=> @$("#add").prependTo @$("#lidstable_wrapper .row:first .col-md-6:last"))