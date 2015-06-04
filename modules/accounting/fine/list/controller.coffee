@Air.module 'Accounting.Fine.List', (List, App, Backbone, Marionette, $, _) ->

  class List.Controller extends App.Base.Controller

    initialize: (opts) ->
      { @id } = opts
      @fines  = App.request 'saleFine:entities', @id
      @layout = @getLayout()

      @listenTo @layout, 'show', ->
        @showFine()
        @filterRegion()
        @newRegion null, 'instruction'

      App.vent.on 'fine:model:added', (model) =>
        @fines.add model

      App.vent.on 'fine:model:removed', (model) =>
        @fines.remove model
        @updateCollection()

      App.vent.on 'filter:submit', (data, agentId, @type) =>
          @agent = App.request 'user:entity', agentId
          App.execute 'when:fetched', @agent, (=>
            if @type is 'disciplinary'
              @fines = App.request 'disciplinaryFine:filter:entities', data
            else
              @fines = App.request 'saleFine:filter:entities', data

            if agentId
              @newRegion null, @type
            else
              @agent = null
              @newRegion null, 'instruction'

            @showFine()
          ), (=>)

      @show @layout,
        loading:
          entities: @fines

    updateCollection: ->
      @fines.reset @fines.toJSON()

    getFineView: ->
      view = new List.CompositeView
        collection: @fines
        agent: @agent

      @listenTo view, 'childview:click:delete', (el, model) =>
        App.execute 'show:confirm', App.request('lang:get', 'fine:delete:confirm', [model.get('order')]), ->
          model.destroy
            success: =>
              App.execute 'notify:success', App.request('lang:get', 'fine:delete:success')
              App.vent.trigger ' fine:model:removed', model

      @listenTo view, 'childview:click:edit', (el, model) =>
        @newRegion model, @type

      view

    showFine: ->
      @layout.fine.show @getFineView()

    filterRegion: ->
      view = App.request 'filter:fine:view', @layout.filter

      @layout.filter.show

    newRegion: (model, type) ->
      view = App.request 'new:fine:view', @layout.new, @agent, model, type

      @layout.new.show

    getLayout: ->
      new List.Layout