@Air.module 'Admin.Users.List', (List, App, Backbone, Marionette, $, _) ->

  class List.ListItemView extends Air.BaseCompositeView
    template  : 'admin/users/item'
    tagName   : 'tr'

    events:
      'click td:not(.priority-limit)'  : ->
         @trigger 'click:edit', @model

      'click #edit'   : (e) -> 
        e.stopImmediatePropagation()
        @trigger 'click:edit', @model

      'click #view'   : (e) -> 
        e.stopImmediatePropagation()
        @trigger 'click:view', @model
      
      'click #delete'   : (e) -> 
        e.stopImmediatePropagation()
        @trigger 'click:delete', @model

      'click #active'  : (e) ->
        e.stopImmediatePropagation()
        @$('#active').toggleClass 'green red'
        @$('#active').find('i').toggleClass 'fa-check fa-times'
        @update()

      'click .statistic': (e) ->
        e.stopImmediatePropagation()
        @$('span.statistic').addClass 'updating'
        @$('[name="priority"]').inputFilter 'number'
        @$('[name="userLimit"]').inputFilter 'number'

      'blur .priority-limit': ->
        @updateStatstic()

    updateStatstic: ->
      userLimit =  @$('input[name="userLimit"]').val()
      priority =  @$('input[name="priority"]').val()
      @trigger 'statistic:model:update', @model, priority, userLimit

    update: ->
      if @model.get('active') is false then @model.set('active', true) else @model.set('active', false)
      @model.save()

  class List.ListEmptyView extends Air.BaseItemView
    template          : "admin/users/empty"
    tagName           : "tr"

  class List.ListView extends Air.BaseCompositeView
    template              : 'admin/users/list'
    itemView              : List.ListItemView
    emptyView             : List.ListEmptyView
    itemViewContainer     : 'tbody'

    triggers:
      'click #add'        : 'item:add'

    initialize: (model) ->
      @listenTo @, 'refresh', @render
      
    onDomRefresh:->
      @initDT()

    initDT: ->
      App.Utils.DT.initDT '#lidstable', 
        sort: [0, 'asc']
        initComplete: (=> @$("#add").prependTo @$("#lidstable_wrapper .row:first .col-md-6:last"))
        