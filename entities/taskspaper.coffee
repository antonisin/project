@Air.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->
  class Entities.TaskModel extends Entities.BaseModel
    urlRoot: Config.routePrefix + 'task'
    defaults:
      isHidden: 0
      isDone: 0

    validation:
      category:
        required: true

      message:
        required : true
        msg       : "Please, enter some text (not null)"
      date:
        required : true
        msg       : "Please, enter valid date"
      time:
        required : true
        msg       : "Please, enter a valid time"

  class Entities.TasksCollection extends Entities.BaseCollection
    model: Entities.TaskModel
    url  : -> Config.routePrefix + 'task'

  class Entities.TasksCommentModel extends Entities.BaseModel
    urlRoot: Config.routePrefix + 'task/comment'
    validation:
      message:
        required: true
        msg: 'Please, enter some text (not null)'

    defaults:
      message: ''

  class Entities.TasksCommentsCollection extends Entities.BaseCollection
    model: Entities.TasksCommentModel
    url: -> Config.routePrefix + 'task/all'

  API =
    getNewModel: (lidId) ->
      new Entities.TaskModel
        lid: lidId

    getCollection: (tasks) ->
      new Entities.TasksCollection tasks

    getCommentsCollection: (JSON) ->
      new Entities.TasksCommentsCollection JSON

    getNewCommentModel: (taskId) ->
      new Entities.TasksCommentModel
        taskId: taskId
        user: window.data.user.id

    getNewDoneCommentModel: (taskId) ->
      model = new Entities.TasksCommentModel
        taskId: taskId
        user: window.data.user.id
      model.url = Config.routePrefix + 'task/comment/done'
      model

  App.reqres.setHandler 'lid:task:paper:collection', API.getCollection
  App.reqres.setHandler 'lid:task:paper:new:model', API.getNewModel
  App.reqres.setHandler 'lid:task:paper:comment:collection', API.getCommentsCollection
  App.reqres.setHandler 'lid:task:paper:comment:new:model', API.getNewCommentModel
  App.reqres.setHandler 'lid:task:paper:comment:done:model', API.getNewDoneCommentModel
