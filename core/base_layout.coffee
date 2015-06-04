class Air.BaseLayout extends Backbone.Marionette.Layout
  @mixin 'ui_init', 'select2'

  onBeforeClose: ->
    @$el.find('.ttp').tooltip 'destroy'

  scrollTopAnimated: ->
    $('html, body').animate({scrollTop:0}, 220)
