@Air.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.MultiwayModel extends Entities.BaseModel
  class Entities.MultiwayCollection extends Entities.BaseCollection
    model : Entities.MultiwayModel

  API =
    getMultiwayCollection: (JSON) ->
      new Entities.MultiwayCollection JSON

  App.reqres.setHandler 'multiway:entities',   API.getMultiwayCollection
