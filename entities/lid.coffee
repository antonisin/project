@Air.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.LidModel extends Entities.BaseModel
    urlRoot     : Config.routePrefix + 'lid'
    defaults    :
      firstName: ''
      lastName: ''
      sex: null
      datetime: ''
      phone: ''
      email: ''
      extraPhones: ''
      extraEmails: ''
      deleted: ''
      user: ''
      createdFormatted: ''
      booking: ''
      bookingModel: {}
    contacts: Air.ContactsCollection

    validation:
      firstName:
        required: true
        rangeLength: [3, 20]
        msg: 'Please enter a valid first name'

      lastName:
        required: false
        rangeLength: [3, 20]
        msg: 'Please enter a valid last name'

      sex:
        required: true
        msg: 'Please enter a valid gender'

      phone:
        required: false
        pattern: /^\+?([0-9. -]{5,15})$/
        msg: 'Please enter a valid phone'

      email:
        required: false
        pattern: 'email'
        msg: 'Please enter a valid email'

    fetch: ->
      super
        success: =>
          @trigger 'ready'
          @trigger 'fetched'

  class Entities.LidCollection extends Entities.BaseCollection
    model   : Entities.LidModel
    url     : Config.routePrefix + 'lid'

    filter: (q) ->
      @fetch
        data: {q: q}

  API =
    getLids: ->
      user = App.request 'get:current:user'
      lids = new Entities.LidCollection
      lids.url = Config.routePrefix + "user/#{user.id}/lids"
      lids.fetch()
      lids

    getLidsFilter: (q) ->
      user = App.request 'get:current:user'
      lids = new Entities.LidCollection
      lids.url = Config.routePrefix + "lid/#{user.id}/filter"
      lids.fetch
        data: q
      lids

    getAdminLids: ->
      lids = new Entities.LidCollection
      lids.fetch()
      lids

    getLid: (id) ->
      if id
        lid = new Entities.LidModel {id: id}
        lid.fetch()
      else
        user = App.request 'get:current:user'
        lid = new Entities.LidModel
          user: user.id
      lid

  App.reqres.setHandler 'lid:entities', API.getLids
  App.reqres.setHandler 'lid:entities:filter', API.getLidsFilter
  App.reqres.setHandler 'admin:lid:entities', API.getAdminLids
  App.reqres.setHandler 'lid:entity', API.getLid