@Air.module 'Utils', (Utils, App, Backbone, Marionette, $, _) ->

  class Utils.Logger extends App.Base.Controller
    startTime: undefined
    env: 'prod'

    initialize: (opts) ->
      { @env } = opts
      @startTime = Date.now()

    info: (text) ->
      return if @env is 'prod'
      console.info "#{(Date.now() - @startTime) / 1000} | #{text}"

  App.commands.setHandler 'logger:start', (env) =>
    @logger = new Utils.Logger env: env

  App.commands.setHandler 'logger:info', (text, state = '') =>
    @logger.info text, state 