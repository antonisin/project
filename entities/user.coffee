@Air.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.UserModel extends Entities.BaseModel
    urlRoot: Config.routePrefix + 'user'
    defaults:
      firstName         : ''
      lastName          : ''
      email             : ''
      birthdayFormatted : '01/01/1980'
      picture           : ''
      about             : ''
      role              : 'agent'
      phone             : ''
      addPhone          : ''
      priority          : 0
      userLimit         : 0

    validation:
      firstName:
        required: true
        rangeLength: [3, 20]
        msg: 'Please enter a valid first name'

      lastName:
        required: true
        rangeLength: [3, 20]
        msg: 'Please enter a valid last name'

      email:  
        required: true
        pattern: 'email'
        msg: 'Please enter a valid email'

      picture:
        required: false
        msg: 'Please enter a valid picture'

      birthdayFormatted:
        required: true
        msg: 'Please enter a valid date'

      about:
        required: false
        msg: 'Please enter a valid about'


  class Entities.AdminUserModel extends Entities.BaseModel
    urlRoot: Config.routePrefix + 'user'
    defaults:
      firstName         : ''
      lastName          : ''
      email             : ''
      birthdayFormatted : '01/01/1980'
      picture           : ''
      about             : ''
      phone             : ''
      addPhone          : ''
      # role_id: ''
      password          : ''

    validation:
      firstName:
        required: true
        rangeLength: [3, 20]
        msg: 'Please enter a valid first name'

      lastName:
        required: true
        rangeLength: [3, 20]
        msg: 'Please enter a valid last name'

      email:  
        required: true
        pattern: 'email'
        msg: 'Please enter a valid email'

      picture:
        required: false
        msg: 'Please enter a valid picture'

      birthdayFormatted:
        required: true
        msg: 'Please enter a valid date'

      about:
        required: false
        msg: 'Please enter a valid about'
        
      password:
        required: false
        rangeLength: [3, 20]
        msg: 'Please enter a valid password'

      priority:
         required: false
         msg: 'Please enter only integers'

      limit:
         required: false
         msg: 'Please enter only integers'

  class Entities.AdminUserCollection extends Entities.BaseCollection
    model   : Entities.AdminUserModel
    url     : Config.routePrefix + 'user'

  class Entities.UserThanksModel extends Entities.BaseModel
    validation:
      text:
        required: true
        msg: 'Please enter a valid message'

  class Entities.UserThanksCollection extends Entities.BaseCollection
    model: Entities.UserThanksModel
    url: -> Config.routePrefix + "user/#{@user}/thanks"
    initialize: (id)->
      @user = id.id

  class Entities.UserCollection extends Entities.BaseCollection
    model   : Entities.UserModel
    url     : Config.routePrefix + 'user'

  class Entities.UserCounterModel extends Entities.BaseModel
    urlRoot: Config.routePrefix + 'user/#{user}/race'

  class Entities.RolesModel extends Entities.BaseModel

  class Entities.RolesCollection extends Entities.BaseCollection
    model: Entities.RolesModel

  API = 
    getUserItem: (id) ->
      user = new Entities.UserModel
        id: id
      user.fetch() if id
      user

    setCurrentUser: (data) ->
      new Entities.UserModel data

    getUserThanks: (id) ->
      thanks = new Entities.UserThanksCollection {id: id}
      thanks.fetch()
      thanks

    getThankyouModel: (curent_user) ->
      thank = new Entities.UserThanksModel {user_id: curent_user.reference_id , reference_id: curent_user.curent_user, text : ''}
      thank

    getUserRaceItems: (user) ->
      users = new Entities.UserCollection

      users.fetch()
      users

    getUserItems: () ->
      users = new Entities.UserCollection
      users.fetch()
      users
    getAdminUserItems:->
      users = new Entities.AdminUserCollection
      users.fetch()
      users
    getUserCounter:(id)->
      counter = new Entities.UserCounterModel
      counter.url = Config.routePrefix + "settings/#{id}/counter"
      counter.fetch()
      counter

    getRoles:->
      new Entities.RolesCollection window.data['getroles']
      
  App.reqres.setHandler 'user:entity', API.getUserItem
  App.reqres.setHandler 'set:current:user', API.setCurrentUser
  App.reqres.setHandler 'user:entities:race', API.getUserRaceItems
  App.reqres.setHandler 'user:entities', API.getUserItems

  App.reqres.setHandler 'admin:user:entities', API.getAdminUserItems

  App.reqres.setHandler 'userthanks:entities', API.getUserThanks
  App.reqres.setHandler 'thankyou:entiti', API.getThankyouModel 

  App.reqres.setHandler 'get:user:counter', API.getUserCounter 

  App.reqres.setHandler 'get:roles', API.getRoles