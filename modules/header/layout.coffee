@Air.module "Header", (Header, App, Backbone, Marionette, $, _) ->

  class Header.Layout extends Air.BaseLayout
    template: 'header/layout'

    regions:
      menu    : '#menu' 
      user    : '#user-menu'

    initialize: ->
      @listenTo @, 'loading:show', @showLoading
      @listenTo @, 'loading:hide', @hideLoading

    showLoading: ->
      $("<div>").addClass('menu-loader').prependTo @$(".header")

    hideLoading: ->
      @$('.menu-loader').remove()