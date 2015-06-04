@Air.module "Footer.Default", (Default, App, Backbone, Marionette, $, _) ->
  class Default.View extends Air.BaseItemView
    template: 'footer/default/view'
    className : 'footer'

    events:
      'click #go-top'  :  'goTop'

    goTop:->
      $('body').animate({scrollTop: 0 }, 400)


