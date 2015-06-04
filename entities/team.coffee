@Air.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.TeamModel extends Entities.BaseModel
    urlRoot     : Config.routePrefix + 'team'
    defaults    :
      name: ''
      systemName: ''
      description: ''

    validation:
      name:
        required: true
        msg: "Please, enter a valid team name (not null)"
      systemName:
        required :true
        msg: "Please, enter a valid team system name (not null)"
      description:
        required: true
        msg: "Please, enter a valid description (not null)"

  class Entities.TeamCollection extends Entities.BaseCollection
    model: Entities.TeamModel
    url: -> Config.routePrefix + "team"

  API = 
    getTeam: (data) ->
      new Entities.TeamModel data

    getTeams: (data) ->
      collection = new Entities.TeamCollection data
      collection.fetch()

      collection

  App.reqres.setHandler 'team:entities', API.getTeams
  App.reqres.setHandler 'team:entity', API.getTeam
