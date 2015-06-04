@Air.module 'Admin.LandingDirections.List', (List, App, Backbone, Marionette, $, _) ->
  class List.ListItem extends Air.BaseItemView
    template: 'admin/landingDirections/item'
    tagName : 'tr'
    events:
      'click #delete'   : (e) -> 
        e.stopImmediatePropagation()
        @trigger 'click:delete', @model
      'click td'   : (e) -> 
        @trigger 'click:edit', @model

  class List.ListView extends Air.BaseCompositeView
    template              : 'admin/landingDirections/layout'
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