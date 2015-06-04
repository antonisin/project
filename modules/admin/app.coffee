@Air.module 'Admin', (Admin, App, Backbone, Marionette, $, _) ->

	class Admin.Router extends App.Routers.BaseRouter
		menuItem  : 'admin'
		role      : ['admin']
		appRoutes :
			'admin' : 'list'

	API = 
		list: (action = 'users') ->
			new Admin.ListController
				nav: action
				region: App.content
			App.vent.trigger 'footer:view:default'
			
	App.addInitializer ->
		new Admin.Router 
			controller: API

	App.commands.setHandler 'admin:list', (action) ->
		API.list action

