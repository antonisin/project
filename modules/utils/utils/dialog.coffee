@Air.module "Routers", (Routers, App, Backbone, Marionette, $, _) ->

  class Marionette.Region.Dialog extends Marionette.Region
    template: HAML['_utils/dialog']
    defaultButtons:
      {save: true, close: true, yes: false, no: false}

    constructor: ->
      _.extend @, Backbone.Events

    onShow: (view) ->
      @listenTo view, 'set:title', (title) -> @$el.find('.modal-title').html title
      @listenTo view, 'close', (title) ->  @close()
      @listenTo view, 'modal:hidden', (view) ->
        @currentView.close()
      @$el.modal()
      @$el.on 'shown.bs.modal', => @onModalShown()
      @$el.on 'hidden.bs.modal', => @currentView.trigger 'modal:hidden' if @currentView

      @listenTo App.vent, 'dialog:position:update', @updatePosition
      @listenTo App.vent, 'dialog:position:update:animate', @updatePositionAnimate
      @listenTo view, 'dialog:button:show', @showButton
      @listenTo view, 'dialog:button:hide', @hideButton
      @listenTo App.vent, 'menu:choose', @close

    onClose: ->
      $("#dialog").modal 'hide'
      $("#dialogLarge").modal 'hide'

    onModalShown: ->
      @currentView.trigger 'modal:shown'
      if @$el.find(".modal-body input").length > 0
        @$el.find(".modal-body input:first").focus()
      else
        @$el.find(".modal-footer button:first").focus()

    open: (view) ->
      options = @getOptions _.result(view, 'dialog')
      @$el.empty().html(@template(options)).find('.modal-body').append view.el

      for name, button of options.buttons
        @$el.find("##{name}").on 'click', ((e) =>
          el = if e.target.tagName is 'BUTTON' then $(e.target) else $(e.target).closest 'button'
          id =  el.attr 'id'

          view.trigger "dialog:click:#{id}") if button

    showButton: (button) ->
      switch button
        when 'save'
          $button = $("<button id='save' class='btn btn-primary' type='button'>OK</button>").click => @currentView.trigger('dialog:click:save')
          @$el.find(".modal-footer").prepend $button
        when 'close'
          $button = $("<button id='close' class='btn btn-default' type='button' data-dismiss='modal'>Закрыть</button>").click => @currentView.trigger('dialog:click:close')
          @$el.find(".modal-footer").prepend $button

    hideButton: (button) ->
      @$el.find(".modal-footer ##{button}").remove()

    getOptions: (opts = {}) ->
      _.defaults opts,
        title: ''
        buttons: _.defaults opts.buttons ? {}, @defaultButtons

    updatePosition: ->
      $('#dialog.modal.in, #dialogLarge.modal.in').trigger('modal-position')

    updatePositionAnimate: ->
      $('#dialog.modal.in, #dialogLarge.modal.in').trigger('modal-position:animate')