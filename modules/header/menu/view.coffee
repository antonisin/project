@Air.module "Header.Menu", (Menu, App, Backbone, Marionette, $, _) ->

  class Menu.MenuItemView extends Air.BaseItemView
    template    : 'header/menu/item'
    tagName     : 'li'
    className   : ->
      'dropdown' if @model.get('type') is 'drop-down'

    events:
      'click a' : -> @trigger 'item:click', @model

    initialize: ->
      @template = 'header/menu/dropdown' if @model.get('type') is 'drop-down'

      @listenTo @, 'item:disable', =>
        @$el.removeClass 'active'
        @$('.selected').hide()

      @listenTo @, 'item:enable', =>
        @$el.addClass 'active'
        @$('.selected').show()

  class Menu.MenuView extends Air.BaseCompositeView
    template          : 'header/menu/menu'
    itemView          : Menu.MenuItemView
    itemViewContainer : 'ul'

    initialize: ->
      @listenTo @, 'navigate', @navigate

    navigate: (itemName) ->
      @children.each (view) ->
        view.trigger 'item:disable'

      model = @collection.findWhere
        url: itemName
      @children.findByModel(model).trigger 'item:enable' if model
