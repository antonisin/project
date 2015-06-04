@Air.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.DisciplinaryFineModel extends Entities.BaseModel
    urlRoot: Config.routePrefix + 'disciplinary'

    validation:

      points:
        required: true
        pattern: 'number'
        msg: "please, enter a valid point"

      lid:
        required: true
        pattern: 'number'
        msg: "please, enter a valid lid"

      reason:
        required: true
        msg: "please, select a valid reason"

    getType: ->
      return 'disciplinary'

  class Entities.DisciplinaryFineCollection extends Entities.BaseCollection
    model: Entities.DisciplinaryFineModel
    url: -> Config.routePrefix + 'disciplinary'

    initialize: ->
      new Backbone.MultiChooser(@)

    confirm: ->
      @.url = Config.routePrefix + 'disciplinary/confirm'
      @sync 'create', @

    reject: ->
      @.url = Config.routePrefix + 'disciplinary/reject'
      @sync 'create', @

    getType: ->
      return 'disciplinary'

  API =
    getChosenCollection: (data) ->
      new Entities.DisciplinaryFineCollection data

    getFines: (JSON) ->
      if JSON
        collection = new Entities.DisciplinaryFineCollection JSON
      else
        collection = new Entities.DisciplinaryFineCollection
        collection.fetch()

      collection

    getFine: (data) ->
      new Entities.DisciplinaryFineModel data

    getFilteredFines: (query) ->
      collection = new Entities.DisciplinaryFineCollection
      collection.url = Config.routePrefix + 'disciplinary/filter'
      collection.fetch
        data: query
      collection

    getCollection: (JSON) ->
      new Entities.DisciplinaryFineCollection JSON

  App.reqres.setHandler 'disciplinaryFine:entity', API.getFine
  App.reqres.setHandler 'disciplinary:fine:entities', API.getCollection

  App.reqres.setHandler 'disciplinary:fine:entities:chosen', API.getChosenCollection

  App.reqres.setHandler 'disciplinaryFine:filter:entities', API.getFilteredFines
