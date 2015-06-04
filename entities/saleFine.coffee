@Air.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.FineModel extends Entities.BaseModel
    urlRoot: Config.routePrefix + 'fine'

    validation:
      day:
        required: true

      status:
        required: true

      pnr:
        required: true

      value:
        required: true
        pattern: 'number'

    getType: ->
      return 'sale'

  class Entities.FineCollection extends Entities.BaseCollection
    model: Entities.FineModel
    url: -> Config.routePrefix + 'fine'

    initialize: ->
      new Backbone.MultiChooser(@)

    confirm: ->
      @.url = Config.routePrefix + 'fine/confirm'
      @sync 'create', @

    reject: ->
      @.url = Config.routePrefix + 'fine/reject'
      @sync 'create', @

    getType: ->
      return 'sale'

  API =
    getChosenCollection: (data) ->
      new Entities.FineCollection data

    getFines: (JSON) ->
      if JSON
        collection = new Entities.FineCollection JSON
      else
        collection = new Entities.FineCollection
        collection.fetch()

      collection

    getFine: (data) ->
      new Entities.FineModel data

    getFilteredFines: (query) ->
      collection = new Entities.FineCollection
      collection.url = Config.routePrefix + 'fine/filter'
      collection.fetch
        data: query
      collection

  App.reqres.setHandler 'saleFine:entities', API.getFines
  App.reqres.setHandler 'sale:fine:entities:chosen', API.getChosenCollection

  App.reqres.setHandler 'saleFine:entity', API.getFine
  App.reqres.setHandler 'saleFine:filter:entities', API.getFilteredFines
