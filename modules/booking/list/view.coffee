@Air.module 'Booking.List', (List, App, Backbone, Marionette, $, _) ->

  class List.EmptyView extends Air.BaseItemView
    template            : 'booking/list/empty'
    tagName             : 'tr'

  class List.ItemView extends Air.BaseItemView
    template            : 'booking/list/item'
    tagName             : 'tr'
    
    modelEvents:
      'change'   : 'render'

    events:
      'click td'        : 'view'
      'click #delete'   : 'delete' 

    templateHelpers: ->
      deletable: App.request('get:current:user').get('role') is 'admin'

    view: (e) ->
      @trigger 'item:click:before'
      @$(e.target).closest("tr").addClass "target"
      $("html, body").animate
        scrollTop: $("#booking").offset().top - 10
      , 1400
      # scrollTop: $("#booking").offset().top - $(".header").height() - 10
      @trigger 'item:click', @model

    updateStatus: ->
      @$el.removeClass @currentClass if @currentClass
      @currentClass = @model.get('statusModel').class

      @$el.addClass @currentClass

    initialize: (opts) ->
      @updateStatus() if opts?.model
      super()

    delete: (e) -> 
      e.stopImmediatePropagation()
      if @model.get('status') is 5
        App.execute 'notify:error', App.request('lang:get', 'booking:delete:error:hassale')
      else
        @trigger 'click:delete', @model

  class List.ListView extends Air.BaseCompositeView
    template            : 'booking/list/list'
    id                  : 'lidstable'
    tagName             : 'table style="font-size:12px;"'
    className           : 'table-condensed table table-bordered table-hover'
    itemView            : List.ItemView
    emptyView           : List.EmptyView
    itemViewContainer   : 'tbody' 

    itemEvents:
      'item:click:before' : -> $("tr").removeClass 'target'

    initialize: ->
      @listenTo @collection, 'destroy', @render
  
    onShow:->
      App.Utils.DT.initDT '#lidstable', 
        pageLength: 5
        order: [6, 'desc']
