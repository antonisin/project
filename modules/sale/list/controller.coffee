@Air.module 'Sale.List', (List, App, Backbone, Marionette, $, _) ->

  class List.Controller extends App.Base.Controller
    _name: 'sale/list'

    initialize: ->
      @collection = App.request 'sale:entities'
      window.sales = @collection
      @layout = @getLayout()

      @listenTo @layout, 'show', =>
        @showFilter()
        @showList()

      @show @layout,
        loading:
          entities: @collection

      App.vent.trigger 'footer:view:default'

    showFilter: ->
      view = @getFilterView()
      @listenTo view, 'submit', (d) =>
        @collection = App.request 'sale:entities:filter', d
        @show @getListView(),
          region: @layout.list
          loading:
            entities: @collection
            type    : 'opacity'

      @layout.filter.show view

    showList: ->
      view = @getListView @collection
      window.view = view
      @listenTo App.vent, 'destroy:list:view', ->
        @collection.fetch()
        @layout.list.close view
        @layout.list.show view
      @layout.list.show view

    getLayout: ->
      view = new List.Layout
      @listenTo @ , 'this:controller:toggle:search', => view.trigger 'view:toggle:search'
      view

    getListView: ->
      view = new List.ListTableView
        collection: @collection
      @listenTo view ,'toggle:search', -> @trigger 'this:controller:toggle:search'
      @listenToOnce view, 'childview:item:click', (el, model) => App.vent.trigger 'sale:list:item:click', model
      @listenTo view, 'childview:item:delete', @deleteItem
      view

    getFilterView: ->
      new List.ListFilterView
        classes: App.request 'booking:class:entities'
        statuses: App.request 'booking:status:entities'

    deleteItem: (el, model) =>
      if App.request('get:current:user').get('role') is 'admin'
        text = if model.get('deleteRequested') then App.request('lang:get', 'sale:delete:confirm:withrequest', ["#{model.get('deleteRequestUserModel').firstName} #{model.get('deleteRequestUserModel').lastName}", model.get('deletedRequestComment'), model.get('deleteRequested')]) else App.request('lang:get', 'sale:delete:confirm:withoutrequest')
        App.execute 'show:confirm', text, (=> @deleteItemSuccess model)
      else if model.get 'deleteRequested'
        App.execute 'notify:info', App.request('lang:get', 'sale:delete:request:sent')
      else
        App.execute 'show:prompt',
          title   : App.request 'lang:get', 'sale:delete:prompt:title'
          text    : App.request 'lang:get', 'sale:delete:prompt:text'
          success : (text) => @deleteItemSuccess model, text

    deleteItemSuccess: (model, message) ->
      model.destroy
        data        : {user: App.request('get:current:user').id, message: message}
        processData : true
        wait        : true
        error: =>
          App.execute 'notify:info', App.request('lang:get', 'sale:delete:wait:confirm')
          model.fetch()
          model.trigger 'disable:delete'
        success: =>
          App.execute 'notify:success', App.request('lang:get', 'sale:delete:success')
          App.vent.trigger 'destroy:list:view'

