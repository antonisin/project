@Air.module 'Utils', (Utils, App, Backbone, Marionette, $, _) ->

  class Utils.ErrorController extends App.Base.Controller
    _name: 'error'

    initialize: (opts) ->
      view = @getView opts.errors

      @show view

    getView: (errors) ->
      new Utils.ErrorView errors: errors

  class Utils.ErrorView extends App.BaseItemView
    template: 'utils/error'
    className: 'error-wrapper'

    events:
      'click #refresh'  : -> Backbone.history.loadUrl()

    initialize: (opts) ->
      { @errors } = opts

    onShow: ->
      @$("#errors").html @errors
      @$el.css 'top', ($("#content").height() - @$el.height()) / 2 - 50

  App.commands.setHandler 'show:error', (errors) ->
    new Utils.ErrorController
      region: App.content
      errors: errors