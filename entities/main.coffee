@Air.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->
  class Entities.SliderModel extends Entities.BaseModel 
    urlRoot : Config.routePrefix + 'main/slider'
    defaults:
      id: ''
      url: ''
    validation:
      url:
        required: true
        msg     : 'Please select your local image' 

  class Entities.SliderCollection extends Entities.BaseCollection
    url  : Config.routePrefix + 'main/slider'
    model: Entities.SliderModel

  
  class Entities.TravelModel extends Entities.BaseModel 
    urlRoot : Config.routePrefix + 'main/travel'
    defaults:
      id: ''

  class Entities.TravelCollection extends Entities.BaseCollection
    url  : Config.routePrefix + 'main/travel'
    model: Entities.TravelModel

  class Entities.TestimonialModel extends Entities.BaseModel
    urlRoot : Config.routePrefix + 'main/testimonial'
    defaults:
      text: ''

    validation:
      name:
        required: true
        msg     : 'Please enter a valid name/ not null'
      text:
        required: true
        msg     : 'Please enter text/ not null'
      endLocation:
        required: true
        msg     : 'Please chouse a location'
      startLocation:
        required: true
        msg     : 'Please chouse a location'

  class Entities.TestimonialCollection extends Entities.BaseCollection
    url  : Config.routePrefix + 'main/testimonial'
    model: Entities.TestimonialModel

  API = 
    getSliderCollection :->
      collection = new Entities.SliderCollection
      collection.fetch()
      collection

    getTravelCollection :->
      collection = new Entities.TravelCollection
      collection.fetch()
      collection

    getTestimonialCollection: ->
        collection = new Entities.TestimonialCollection
        collection.fetch()
        collection

    addSliderModel : ->
      new Entities.SliderModel

    addTestimonialModel : ->
      new Entities.TestimonialModel

  App.reqres.setHandler 'admin:main:slider:collection' , API.getSliderCollection
  App.reqres.setHandler 'admin:main:slider:new:model' , API.addSliderModel

  App.reqres.setHandler 'admin:main:travel:collection' , API.getTravelCollection
  
  App.reqres.setHandler 'admin:main:testimonial:collection', API.getTestimonialCollection
  App.reqres.setHandler 'admin:main:testimonial:new:model' , API.addTestimonialModel
