@Air.module 'Utils', (Utils, App, Backbone, Marionette, $, _) ->

  class Utils.ConfirmController extends App.Base.Controller

    initialize: (opts) ->
      view = @getView opts.text
      @listenTo view, 'dialog:click:yes', (-> _.defer opts.callback)
      @show view

    getView: (text) ->
      new Utils.ConfirmView
        text: text

  class Utils.ConfirmView extends Air.BaseItemView
    template: false
    dialog:
      title: 'Подтверждение'
      buttons: 
        save: false
        close: false
        yes: true
        no: true

    initialize: (opts) ->
      { @text } = opts
      @$el.html @text

  App.commands.setHandler 'show:confirm', (text, callback) ->
    new Utils.ConfirmController
      region    : App.dialog
      text      : text
      callback  : callback

