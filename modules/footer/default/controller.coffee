@Air.module "Footer.Default", (Default, App, Backbone, Marionette, $, _) ->

  Default.Controller = 
    view: (region) ->
      view = @getView()
      region.show view

    getView: ->
      new Default.View

    currentYear:->
      year = new Date()
      year = year.getFullYear()
      $('#copyright').html(year + " &copy; FusionWorks")
