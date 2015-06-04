@Air.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.ExtraModel extends Entities.BaseModel
    urlRoot : Config.routePrefix + 'extra/lid/'
    defaults:
      extraFirstName  : ''
      extraLastName   : ''
      extraPhone      : ''
      extraEmail      : ''
      extraSex        : 1
      lidId           : ''
    
    validation:
      extraFirstName:
        required: true
        rangeLength: [3, 20]
        msg: 'Please enter a valid FirstName'

      extraLastName:
        required: true
        rangeLength: [3,20]
        msg: 'Please enter a valid LastName'

      extraPhone:
        pattern: /^\+?([0-9. -]{5,15})$/
        msg: 'Please enter a valid first Phone'
        required: (val, attr, input) ->
          @newValidate('Phone', @, input, val)

      extraEmail:
        pattern: 'email'
        msg: 'Please enter a valid last Email'
        required: (val, attr, input) ->
          @newValidate('Email', @, input, val)
          
    newValidate: (name, obj, input, val) ->
      if val
        for model in obj.collection.models
          if  model.get( 'extra' + name ) == val and model.get('id') != input.id  
            return  obj.errorValidation.push( {'name':'extra' + name, 'value':'true'} )
        
        for model in obj.lidModel.get( 'extra' + name + 's')
          if model.email == val 
            return  obj.errorValidation.push( {'name':'extra' + name, 'value':'true'} )
        
        if obj.lidModel.get( name.toLowerCase() ) == val  
          return  @errorValidation.push( {'name':'extra' + name, 'value':'true'} )

        if name == 'Email' and val
          pattern = /^([a-z0-9_\.-])+@[a-z0-9-]+\.([a-z]{2,4}\.)?[a-z]{2,4}$/i;
          if !pattern.test(val)
            return  @errorValidation.push( {'name':'extra' + name, 'value':'true'} )


  class Entities.ExtraEmailModel extends Entities.BaseModel
    urlRoot : Config.routePrefix + 'extra/email/'

    defaults:
      extraEmail : ''
      lidId      : ''

    validation:
      extraEmail:
        pattern: 'email'
        msg: 'Please enter a valid email'
        required: (val, attr, input) ->
          @emailValidation( @, input, val )

    emailValidation: (obj, input, val) ->
      if obj.collection.where({'extraEmail' : val}).length > 1
        return  obj.errorValidation.push( {'name': 'email', 'value':'true'} )
      
      for model in obj.lidModel.get( 'extraLids') 
        if model.extraEmail == val
          return  obj.errorValidation.push( {'name': 'email', 'value':'true'} )
      
      if obj.lidModel.get('email') == val
        return  @errorValidation.push( {'name' : 'email', 'value':'true'} )
        
  class Entities.ExtraPhoneModel extends Entities.BaseModel
    urlRoot : Config.routePrefix + 'extra/phone/'

    defaults:
      extraPhone : ''
      lidId      : ''

    validation:
      extraPhone:
        pattern: /^\+?([0-9. -]{5,15})$/
        msg: 'Please enter a valid email'
        required: (val, attr, input) ->
          @newValidate('Phone', @, input, val)

    newValidate: (name, obj, input, val) ->
      if obj.collection.where({'extraPhone' : val}).length > 1
        return  obj.errorValidation.push( {'name': name.toLowerCase(), 'value':'true'} )
      
      for model in obj.lidModel.get( 'extraLids') 
        if eval("model.extra" + name) == val  
          return  obj.errorValidation.push( {'name': name.toLowerCase(), 'value':'true'} )
      
      if obj.lidModel.get( name.toLowerCase() ) == val  
        return  @errorValidation.push( {'name':name.toLowerCase(), 'value':'true'} )

  class Entities.ExtraCollection extends Entities.BaseCollection
    url     : Config.routePrefix + 'extra/lid/'
    model   : Entities.ExtraModel
  
  class Entities.ExtraEmailsCollection extends Entities.BaseCollection
    url  : Config.routePrefix + 'extra/email/'
    model: Entities.ExtraEmailModel
  
  class Entities.ExtraPhonesCollection extends Entities.BaseCollection
    url  : Config.routePrefix + 'extra/phone/'
    model: Entities.ExtraPhoneModel
            
  API = 
    getLidsCollection:(collection) ->
      new Entities.ExtraCollection collection

    getEmailsCollection: (collection) ->
      new Entities.ExtraEmailsCollection collection

    getPhonesCollection: (collection) ->
     new Entities.ExtraPhonesCollection collection

    getLidModel: (lidId) ->
     new Entities.ExtraModel({lidId: lidId})

    getEmailModel: (lidId) ->
      new Entities.ExtraEmailModel ({lidId:lidId})

    getPhoneModel: (lidId) ->
      new Entities.ExtraPhoneModel ({lidId:lidId})

  App.reqres.setHandler 'extra:lid:collection'   , API.getLidsCollection
  App.reqres.setHandler 'extra:emails:collection', API.getEmailsCollection
  App.reqres.setHandler 'extra:phones:collection', API.getPhonesCollection

  App.reqres.setHandler 'extra:lid:model'  , API.getLidModel
  App.reqres.setHandler 'extra:email:model', API.getEmailModel
  App.reqres.setHandler 'extra:phone:model', API.getPhoneModel