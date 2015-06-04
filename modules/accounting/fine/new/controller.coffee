@Air.module 'Accounting.Fine.New', (New, App, Backbone, Marionette, $, _) ->

  class New.Controller extends App.Base.Controller

    initialize: (opts) ->
      { @model, @agent, @type } = opts

      if @type is 'disciplinary'
        @model or= App.request 'disciplinaryFine:entity'
        @selectHelper = App.request 'admin:fine:reason:entities'
      else
        @model or= App.request 'saleFine:entity'
        @selectHelper = App.request 'admin:fine:status:entities'

      @view = @getView()

      @listenTo @view, 'new:fine:close', => @close()
      @listenTo @view, 'new:fine:save', => @save @type

      @show @view

    getView: ->
      if @type is 'instruction'
        view = new New.InstructionView
      else
        @model.set 'agent', @agent.get('id') if @agent
        view = new New.FormView
          model       : @model
          type        : @type
          selectHelper: @selectHelper
      view

    save: (type) ->
      if !@model.validate()
        @loading()
        @model.save @model.attributes,
          wait: true,
          success: =>
            @loading()
            App.execute 'notify:success', App.request('lang:get', 'fine:save:success')
            App.vent.trigger 'fine:model:added', @model
            @view.trigger 'new:fine:close'
            App.request 'new:fine:view', @region, @agent, null, type
      else
        App.execute 'notify:error', App.request('lang:get', 'fine:save:error')