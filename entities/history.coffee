@Air.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.HistoryCommentModel extends Entities.BaseModel
    urlRoot: Config.routePrefix + 'lid/history/comments/'

  class Entities.HistoryCommentCollection extends Entities.BaseCollection
    model: Entities.HistoryCommentModel
    url: -> Config.routePrefix + 'lid/comments/'

  class Entities.HistoryModel extends Entities.BaseModel
    urlRoot: Config.routePrefix + 'lid/history/'

  class Entities.HistoryCollection extends Entities.BaseCollection
    model : Entities.HistoryModel
    url: -> Config.routePrefix + 'lid/history/'

  class Entities.HistoryTypeModel extends Entities.BaseModel
    urlRoot: Config.routePrefix + 'lid/history'

  class Entities.HistoryTypeCollection extends Entities.BaseCollection
    model : Entities.HistoryTypeModel

  API =
    getCollectionHistory: (id) ->
      history = new Entities.HistoryCollection
      history.url = Config.routePrefix + 'lid/history/' + id
      history.fetch()
      history

    getModelHistory: (id) ->
      modelHistory = new Entities.HistoryModel
      modelHistory.url = Config.routePrefix + 'lid/history/' + id
      modelHistory

    getHistoryType: (id) ->
      historyType = new Entities.HistoryTypeModel [], id: id
      historyType

    getComments: (id, data) ->
      comments = new Entities.HistoryCommentCollection data
      comments.historyId = id
      comments

    getComment: (data) ->
      new Entities.HistoryCommentModel data

  App.reqres.setHandler 'history:entities', API.getCollectionHistory
  App.reqres.setHandler 'history:entity', API.getModelHistory
  App.reqres.setHandler 'history:type', API.getHistoryType
  App.reqres.setHandler 'history:comments', API.getComments
  App.reqres.setHandler 'history:comment', API.getComment