@Air.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.SettingModel extends Entities.BaseModel
    urlRoot     : Config.routePrefix + 'settings'
    defaults    :
      name:               ''
      systemName:         ''
      value:              ''
      isSystem:           ''

    validation:
      name:
        required: true
        rangeLength: [2, 56]
        msg: 'Please enter a valid name'

      systemName:
        required: true
        rangeLength: [3, 10]
        msg: 'Please enter a valid system name'

      value:
        required: true
        rangeLength: [1, 10]
        msg: 'Please enter a valid value'

  class Entities.SettingCollection extends Entities.BaseCollection
    model: Entities.SettingModel
    url: -> Config.routePrefix + "settings"

  API =
    getSetting: (data) ->
      new Entities.SettingModel data

    getSettings: (data) ->
      collection = new Entities.SettingCollection data
      collection.fetch()

      collection

  App.reqres.setHandler 'setting:entities', API.getSettings
  App.reqres.setHandler 'setting:entity', API.getSetting