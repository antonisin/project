@Air.module 'User.Profile', (Profile, App, Backbone, Marionette, $, _) ->

  class Profile.ThanksListItemView extends Air.BaseItemView
    template    : 'user/profile/item'
    tagName     : 'tr'
    popover     : HAML['_dashboard/race/popover']
    title       : HAML['_dashboard/race/title']
    attributes  :
      'data-container'  : 'body'
      'data-toggle'     : "popover"
    events      :   
      'shown.bs.popover': -> $(".popover #close").on 'click', => @$el.popover 'hide' 
      
    onShow: ->
      @$el.attr 'data-content', @popover @model.attributes.user_id
      @$el.attr 'data-title', @title @model.attributes.user_id
      @$el.popover
        html: true
        
    onClose: ->
      @$el.popover 'destroy'

  class Profile.ThanksListEmptyView extends Air.BaseItemView
    template          : "user/profile/empty"
    tagName           : "tr"
  
  class Profile.ThanksTableView extends Air.BaseCompositeView
    template              : 'user/profile/list'
    itemView              : Profile.ThanksListItemView
    emptyView             : Profile.ThanksListEmptyView
    itemViewContainer     : 'tbody'
    className             : 'user_table table table-hover thankstable table-interactive'
    tagName               : 'table'