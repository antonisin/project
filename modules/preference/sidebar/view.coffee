@Air.module 'Preference.Sidebar', (Sidebar, App, Backbone, Marionette, $, _) ->

  class Sidebar.ItemView extends App.BaseItemView
    template: 'preference/sidebar/item'
    tagName : 'li'

  class Sidebar.CollectionView extends App.BaseCollectionView
    itemView: Sidebar.ItemView
    tagName : 'ul'
    className: 'ver-inline-menu'

    onShow: ->
      @$el.find('[name="' + @options.menuItem + '"]').closest('li').addClass('active')
