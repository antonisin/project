@Air.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->
  class Entities.SubscriberModel extends Entities.BaseModel 
    urlRoot : Config.routePrefix + 'subscribers'
    defaults:
      email   : ''
      datetime: ''
      
    validation:
      email:
        required: true
        pattern : 'email'
        msg     : "Enter a valid email"


  class Entities.SubscribersCollection extends Entities.BaseCollection
    url  : Config.routePrefix + 'subscribers'
    model: Entities.SubscriberModel

  API = 
    getSubscribersCollection :->
      collection = new Entities.SubscribersCollection
      collection.fetch()
      collection

    getNewModel: ->
      new Entities.SubscriberModel


  App.reqres.setHandler 'subscriber:entities'     , API.getSubscribersCollection
  App.reqres.setHandler 'subscriber:entity'       , API.getSubscriber
  App.reqres.setHandler 'subscriber:new:entity'   , API.getNewModel
