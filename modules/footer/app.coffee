@Air.module "Footer", (Footer, App, Backbone, Marionette, $, _) ->
  @startWithParent = false

  API = 
    
    default: ->
      Footer.Default.Controller.view @getRegion()
      Footer.Default.Controller.currentYear()

    lid: ->
      Footer.Lid.Controller.view @getRegion()

    getRegion: ->
      App.footer

  App.vent.on 'footer:view:default', ->
    API.default()

  App.vent.on 'footer:view:lid', ->
    API.lid()