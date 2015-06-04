@Air.module 'Admin', (Admin, App, Backbone, Marionette, $, _) ->
  class Admin.Layout extends Air.BaseLayout
    template: 'admin/layout'
    regions:
      menu: '#menu'
      list: '#list'
      title: '#adminTitle'

    onShow: ->
      @scrollTopAnimated()

  class Admin.MenuItemView extends Air.BaseItemView
    template: 'admin/menuitem'
    tagName: 'li'

    events:
      'click a': 'click'

    modelEvents:
      'change:chosen' : 'choose'

    initialize: ->
      @choose(@, true) if @model.get('chosen')

    choose: (model, state) ->
      if state then @$el.addClass 'active' else @$el.removeClass 'active'

    click: (e) ->
      if @model.get 'type' then return false else @scrollTopAnimated()
      e.preventDefault()
      @model.choose()
      @trigger 'click', @model

  class Admin.MenuListView extends Air.BaseCollectionView
    tagName: 'ul'
    className: 'ver-inline-menu'
    itemView: Admin.MenuItemView

    initialize: (opts) ->
      opts.collection.findWhere(url: opts.active).choose()
      window.menu = @

  class Admin.TitleItemView extends Air.BaseItemView
    template: 'admin/title'
    templateHelpers : ->
      title : @options.title
