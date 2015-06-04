@Air.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.ClientModel extends Entities.BaseModel
    urlRoot     : Config.routePrefix + 'clients'
    defaults    :
      ip: ''
      referer: ''
      browser: ''
      keyword: ''
      promo: ''
      extra: ''
      datetime: ''

  class Entities.ClientCollection extends Entities.BaseCollection
    model: Entities.ClientModel
    url: -> Config.routePrefix + "clients"

  class Entities.ClientHit extends Entities.BaseModel
  class Entities.ClientHitsCollection extends Entities.BaseCollection
    
  API = 
    getClient: (data) ->
      new Entities.ClientModel data

    getClients: (data) ->
      collection = new Entities.ClientCollection data
      collection.fetch()

      collection

    getClientHits: (data) ->
      collection = new Entities.ClientHitsCollection
      collection.url = Config.routePrefix + "clients/#{data.id}/hits"
      collection.fetch()

      collection


  App.reqres.setHandler 'client:entities', API.getClients
  App.reqres.setHandler 'client:entity', API.getClient
  App.reqres.setHandler 'client:hits:entities', API.getClientHits