  @Air.module 'Booking.View.Multiway', (Multiway, App, Backbone, Marionette, $, _) ->

    class Multiway.ItemView extends Air.BaseItemView
      template: 'booking/view/multiway/item'

    class Multiway.CompositeView extends Air.BaseCompositeView
      itemView: Multiway.ItemView
      template: 'booking/view/multiway/layout'
      itemViewContainer   : '.items'

      initialize: ->
        @render()
