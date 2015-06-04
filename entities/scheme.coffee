@Air.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.SchemeModel extends Entities.BaseModel
    urlRoot: Config.routePrefix + 'scheme'

    defaults:
      bonus: []

    validation:
      schemeName :
        required: true

  class Entities.SchemesCollection extends Entities.BaseCollection
    model : Entities.SchemeModel
    url: -> Config.routePrefix + 'scheme'

  API =
    getSchemes: ->
      collection = new Entities.SchemesCollection window.data['schemes']
      collection

    getScheme:(item) ->
      if item
        window.data['schemes'].filter (element)->
          if element.id == item then item = element

        new Entities.SchemeModel item

      else
        new Entities.SchemeModel

    getBonusModel: (JSON) ->
      new Entities.BonusModel JSON

  App.reqres.setHandler 'scheme:entity',   API.getScheme
  App.reqres.setHandler 'scheme:entities', API.getSchemes
