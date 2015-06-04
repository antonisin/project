@Air.module 'Admin', (Admin, App, Backbone, Marionette, $, _) ->

  class Admin.ListController extends App.Base.Controller
    _name: 'admin/list'

    initialize: (opts) ->
      menuItems = App.request 'admin:menu:entities'
      @layout = @getLayout()
      @listenTo @layout, 'show', =>
        @showMenu menuItems, opts.nav
        App.vent.trigger 'admin:navigate', opts.nav, @layout.list

      @listenTo App.vent, 'admin:item:load', =>
        @showTitle()
        @loading()

      @listenTo App.vent, 'admin:show:title', => @showTitle()

      @show @layout

    showMenu: (items, current) ->
      view = new Admin.MenuListView
        collection  : items
        active      : current

      @listenTo view, 'childview:click', (el, model) =>
        App.vent.trigger 'admin:navigate', model.get('url'), @layout.list

      @layout.menu.show view

    getLayout: ->
      new Admin.Layout

    showTitle: ->
      @layout.title.close()
      view = new Admin.TitleItemView
        title: @layout.menu.currentView.options.collection.where({'chosen':true})[0].get('name')

      @layout.title.show view
