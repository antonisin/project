@Air.module 'Lid.List', (List, App, Backbone, Marionette, $, _) ->

  class List.Controller extends App.Base.Controller
    _name: 'lid/list'

    initialize: ->
      @collection = App.request 'lid:entities'
      @layout = @getLayout()

      @listenTo @layout, 'show', =>
       @showList()
       @showFilter()

      @show @layout,
        loading:
          entities: @collection

      App.vent.trigger 'footer:view:default'

    showList: ->
      view = @getListView @collection
      window.view = view
      @listenTo App.vent, 'destroy:list:view', ->
        @collection.fetch()
        @layout.list.close view
        @layout.list.show view

      @layout.list.show view

    showFilter: ->
      view = @getFilterView()
      @listenTo view, 'submit', (d) =>
        @collection = App.request 'lid:entities:filter', d
        @show @getListView(),
          region: @layout.list
          loading:
            entities: @collection
            type    : 'opacity'

      # @listenTo view, 'something:close', => view.$()
      @layout.filter.show view

    getLayout: ->
      view = new List.Layout
      @listenTo @ , 'this:controller:toggle:search', => view.trigger 'view:toggle:search'
      view

    getListView: ->
      view = new List.ListTableView
        collection: @collection
      @listenTo view ,'toggle:search', -> @trigger 'this:controller:toggle:search'

      @listenToOnce view, 'childview:item:click', (el, model) => App.vent.trigger 'lid:list:item:click', model
      @listenTo view, 'item:new', (opts) => App.vent.trigger 'lid:list:item:new'
      @listenTo view, 'childview:click:delete', (el, model) ->
        App.execute 'show:confirm', App.request('lang:get', 'lid:delete:confirm', [model.id]),
          (=> model.destroy
            success: =>
              App.execute 'notify:success', App.request('lang:get', 'lid:delete:success')
              App.vent.trigger 'destroy:list:view'
          )
      view

    getFilterView: ->
      new List.ListFilterView
        classes: App.request 'booking:class:entities'
        statuses: App.request 'booking:status:entities'
