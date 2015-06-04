@Air.module 'Preference', (Preference, App, Backbone, Marionette, $, _) ->

  class Preference.Layout extends Air.BaseLayout
    template: 'preference/layout'
    regions:
      sidebar: '#sidebar'
      list: '#list'