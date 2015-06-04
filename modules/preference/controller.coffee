@Air.module 'Preference', (Preference, App, Backbone, Marionette, $, _) ->

  class Preference.Controller extends App.Base.Controller
    initialize: ->
      @layout = @getLayout()
      @categoryListeners()

      @trigger @options.type.toString()
      @show @layout

    getLayout: ->
      new Preference.Layout

    categoryListeners: ->
      @layout.on 'show', => @showMenu()
      @listenTo @, 'preferences', => @showTags()

      @listenTo App.vent, 'preference:tag:model:edit', (model) => @changeTag model
      @listenTo App.vent, 'preference:tag:model:add', => @changeTag App.request('preference:tag:model:new')

    showMenu: ->
      new Preference.Sidebar.Controller
        menuItem: @options.menuItem
        region: @layout.sidebar

    showTags:->
      new Preference.Tags.Controller
        region: @layout.list
        model : App.request 'get:current:user'

    changeTag: (model) ->
      new Preference.Tags.Change.Controller
        region: App.dialog
        model: model

