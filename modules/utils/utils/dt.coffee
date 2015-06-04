@Air.module 'Utils', (Utils, App, Backbone, Marionette, $, _) ->

  class Utils.DT extends App.Base.Controller
    
    @initDT: (table, opts = {}) ->
      _.defaults opts, 
        dom           : "<'row'<'col-md-6 col-sm-12'l><'col-md-6 col-sm-12'f>r>t<'row'<'col-md-7 col-sm-12'i><'col-md-5 col-sm-12'p>>"
        orderClasses  : false
        order         : [
            [0, 'asc']
        ],
        lengthMenu    : [
            [5, 15, 20, -1],
            [5, 15, 20, "All"]
        ],
        pageLength    : 20        
        language      : {url: "/bundles/fwmetronic/plugins/data-tables/lang/#{App.lang}.json"}
        initComplete  : => true

      oTable = $(table).DataTable opts
        
      $(table).closest('.dataTables_wrapper').find('.dataTables_length select').select2()