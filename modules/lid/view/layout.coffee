@Air.module 'Lid.View', (View, App, Backbone, Marionette, $, _) ->

  class View.Layout extends Air.BaseLayout
    template: 'lid/layout'
    className: 'form_wrap gray_wrap'
    regions:
      lid    : '#lid'
      booking: '#booking'

      tasksBar  : '#tasksBar'
      tasksPaper: '#tasksPaper'
      salesPaper: '#salesPaper'

      bookingsList: '#bookings'
      history     : '#history'