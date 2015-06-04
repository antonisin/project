@Air.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.PassangerModel extends Entities.BaseModel
    urlRoot     : Config.routePrefix + 'passanger'
    defaults:
      firstName: ''
      lastName:  ''
      birthday:  ''
      net:       ''
      fee:       ''
      sex:       '0'
      passportNumber: ''
      passportExpiration: ''
      country: ''

    validation:
      firstName:
        required: true
        rangeLength: [3, 20]
        msg: 'Please enter a valid first name'

      lastName:
        required: true
        rangeLength: [4, 20]
        msg: 'Please enter a valid last name'

      passportNumber:
        required: true
        pattern: /^\+?([0-9. -]{5,15})$/
        msg: 'Please enter a valid phone'

      passportExpiration:
        required: true
        pattern: /^\+?([0-9. -]{5,15})$/
        msg: 'Please enter a valid phone'
      
  class Entities.PassangerCollection extends Entities.BaseCollection
    model: Entities.PassangerModel
    url: -> Config.routePrefix + "/passangers"

  API = 
    getPassanger: (data) ->
      new Entities.PassangerModel data

    getPassangers: ->
      new Entities.PassangerCollection

  App.reqres.setHandler 'passanger:entities', API.getPassangers
  App.reqres.setHandler 'passanger:entity', API.getPassanger
