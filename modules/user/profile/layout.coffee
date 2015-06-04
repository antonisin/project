@Air.module 'User.Profile', (Profile, App, Backbone, Marionette, $, _) ->

  class Profile.Layout extends Air.BaseLayout
    template  : 'user/profile/layout'
    regions   :
      details : '#details'
      thanks  : '#thanks_container'