@Air.module 'Utils', (Utils, App, Backbone, Marionette, $, _) ->

  class Utils.PromptController extends App.Base.Controller

    initialize: (opts) ->
      view = @getView opts.text, opts.title
      @show view

      @listenTo view, 'save', (text) =>
        opts.success text
        view.trigger 'close'

    getView: (text, title) ->
      new Utils.PromptView
        text  : text
        title : title

  class Utils.PromptView extends Air.BaseItemView
    template: 'utils/prompt'
    dialog:
      title: 'Подтверждение'
      buttons: 
        save: true
        close: true
        yes: false
        no: false

    initialize: (opts) ->
      { @text, @title } = opts

      @listenTo @, 'dialog:click:save', =>
        @$(".form-group").removeClass 'has-error'
        text = @$("[name='text']").val()

        if text
          @trigger 'save', text
        else
          @$(".form-group").addClass 'has-error'

    onShow: ->
      @$("#text").html @text
      @trigger 'set:title', @title

  App.commands.setHandler 'show:prompt', (opts) ->
    new Utils.PromptController
      region    : App.dialog
      text      : opts.text
      title     : opts.title
      success   : opts.success

