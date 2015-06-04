@Air.module "Header.User", (User, App, Backbone, Marionette, $, _) ->

  class User.DropdownItemView extends Air.BaseItemView
    template    : 'header/dropdown/item'
    tagName     : 'li class="clearfix with-hover" style="border-bottom:1px solid #f4f4f4 !important; "'

    events:
      'click .closeTask' : 'closeTask'

    onRender: ->
      @initComponents()

    initComponents: ->
      @updateUI()

    closeTask: ->
      @$el.toggle "blind", =>
          @trigger 'close:task', @
        ,600

  class User.DropdownEmptyView extends Air.BaseItemView
    template          : 'header/dropdown/empty'
    tagName           : 'li class="clearfix with-hover" style="border-bottom:1px solid #f4f4f4 !important; "'

  class User.DropdownListView extends Air.BaseCompositeView
    template              : 'header/dropdown/list'
    itemView              : User.DropdownItemView
    emptyView             : User.DropdownEmptyView
    itemViewContainer     : '#dropdown'
    el                    : '#dropdown-menu'

    events:
      'click #tips' : 'toggleTips'

    onRender:->
      @changeCount()

    changeCount: ->
      if @collection.length < 10
        @$el.find(".badge").html("0" + @collection.length)
      else
        @$el.find(".badge").html(@collection.length)

    toggleTips: ->
      @$el.toggleClass('open', 200)

    initialize: ->
      @listenTo @collection, 'remove', ->
        @changeCount()

      @listenTo @, 'add:empty:task', ->
        @appendView(new User.DropdownEmptyView())
