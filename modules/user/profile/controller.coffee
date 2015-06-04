@Air.module 'User.Profile', (Profile, App, Backbone, Marionette, $, _) ->
  class Profile.ProfileController extends App.Base.Controller
    _name: 'offer/view'

    initialize: (opts) ->
      @layout = @getLayout()
      opts.model or = App.request 'user:entity', opts.id
      thanks  = App.request 'userthanks:entities', opts.model.id

      @listenTo @layout, 'show', =>
        @detailsView opts.model
        @thanksView  thanks, opts.model

      @show @layout,
        loading:
          entities: [opts.model, thanks]

    detailsView: (model) ->
      @details = @getDetailsView model
      @listenTo App.vent, 'user:profile:dates:fetch',     => @layout.details.show @details
      @layout.details.show @details

    thanksView: (model, detail) ->
      view = @getThanksView model
      @listenTo App.vent, 'user:profile:thanks:fetch',  =>
        model.fetch  reset:true,  success: =>
          detail.fetch reset:true, success: =>
            @layout.thanks.show view
            @layout.details.show @details

      @layout.thanks.show view

    getDetailsView: (model) ->
      new Profile.DetailsView
        model   : model
        editable: parseInt(model.id) is App.request('get:current:user').id

    getThanksView: (model) ->
      new Profile.ThanksTableView
        collection: model

    getLayout: ->
      new Profile.Layout