@Air.module 'Admin.Monitoring.ChangeCategory', (ChangeCategory, App, Backbone, Marionette, $, _) ->
  class ChangeCategory.LayoutCategory extends Air.BaseLayout
    template: 'admin/monitoring/category/change/layout'
    regions:
      category     : '#category'
      subcategories: '#subcategories'
