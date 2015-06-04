@Air.module 'User.Dashboard.Statistics', (Statistics, App, Backbone, Marionette, $, _) ->

  class Statistics.StatisticsView extends Air.BaseItemView
    template: 'dashboard/statistics'
    className: 'portlet box blue tabbable'

    events:
      'click .nav [href=#week]'  : 'showWeek'
      'click .nav [href=#month]' : 'showMonth'
      'click .nav [href=#year]'  : 'showYear'

    chartOptions:
      series:
        lines:
          show: true
          lineWidth: 2
          fill: true
          fillColor:
            colors: [
              {
                opacity: 0.05
              }, {
                opacity: 0.01
              }
            ]
        points:
          show: true
          radius: 3
          lineWidth: 1
        shadowSize: 2
      grid:
        hoverable: true
        clickable: true
        tickColor: "#eee"
        borderColor: "#eee"
        borderWidth: 1
      colors: ["#d12610", "#37b7f3", "#52e136"]
      xaxis:
        ticks: 11
        tickDecimals: 0
        tickColor: "#eee"
      yaxis:
        ticks: 11
        tickDecimals: 0
        tickColor: "#eee"
        min: 1
      legend:
        container: ".stat_legend"
        noColumns: 2

    onShow: ->
      @initYearChart()
      @showInfo 'месяц'

    showWeek: ->
      @$(".tab-pane").hide()
      @$(".tab-content #week").show()
      @initWeekChart()
      @showInfo()

    showMonth: ->
      @$(".tab-pane").hide()
      @$(".tab-content #month").show()
      @initMonthChart()
      @showInfo()

    showYear: ->
      @$(".tab-pane").hide()
      @$(".tab-content #year").show()
      @initYearChart()
      @showInfo 'месяц'

    initYearChart: ->
      data  = @getData @model.get('graphs').year
      opts = @chartOptions

      $.plot $("#chart-year"), data, opts

    initMonthChart: ->
      data  = @getData @model.get('graphs').month
      opts = @chartOptions

      $.plot $("#chart-month"), data, opts

    initWeekChart: ->
      data  = @getData @model.get('graphs').week
      opts = @chartOptions

      $.plot $("#chart-week"), data, opts

    showInfo: (title = 'день') ->
      previousPoint = null

      @$(".chart").bind 'plothover', (event, pos, item) =>
        $("#x").text(pos.x.toFixed(2));
        $("#y").text(pos.y.toFixed(2));

        if (item)
          if (previousPoint != item.dataIndex)
            previousPoint = item.dataIndex
            $("#tooltip").remove()

            x = parseInt(item.datapoint[0].toFixed(2))
            y = parseInt(item.datapoint[1].toFixed(2))

            info = item.series.label + " за " + x + " " + title +  " = " + y

            @showTooltip item.pageX, item.pageY, info
        else
          $("#tooltip").remove()
          previousPoint = null

    showTooltip: (x, y, contents) ->
      $('<div id="tooltip">' + contents + '</div>').css({
        position: 'absolute',
        display: 'none',
        top: y + 5,
        left: x + 15,
        border: '1px solid #333',
        padding: '4px',
        color: '#fff',
        'border-radius': '3px',
        'background-color': '#333',
        opacity: 0.80
      }).appendTo("body").fadeIn(100)

    getData: (data)->
      [
        {
          data: data.sales
          label: "Продажи"
          lines:
            lineWidth: 1
          shadowSize: 0

        }, {
          data: data.incomes
          label: "Доход"
          lines:
            lineWidth: 1
          shadowSize: 0
        }
      ]

    randValue: ->
      (Math.floor(Math.random() * (1 + 40 - 20))) + 20

    generateData: (limit) ->
      data1: [
        [1, @randValue()],
        [2, @randValue()],
        [3, 2 + @randValue()],
        [4, 3 + @randValue()],
        [5, 5 + @randValue()],
        [6, 10 + @randValue()],
        [7, 15 + @randValue()],
        [8, 20 + @randValue()],
        [9, 25 + @randValue()],
        [10, 30 + @randValue()],
        [11, 35 + @randValue()],
        [12, 25 + @randValue()],
        [13, 15 + @randValue()],
        [14, 20 + @randValue()],
        [15, 45 + @randValue()],
        [16, 50 + @randValue()],
        [17, 65 + @randValue()],
        [18, 70 + @randValue()],
        [19, 85 + @randValue()],
        [20, 80 + @randValue()],
        [21, 75 + @randValue()],
        [22, 80 + @randValue()],
        [23, 75 + @randValue()],
        [24, 70 + @randValue()],
        [25, 65 + @randValue()],
        [26, 75 + @randValue()],
        [27, 80 + @randValue()],
        [28, 85 + @randValue()],
        [29, 90 + @randValue()],
        [30, 95 + @randValue()]
      ].slice 0, limit
      data2: [
        [1, @randValue() - 5],
        [2, @randValue() - 5],
        [3, @randValue() - 5],
        [4, 6 + @randValue()],
        [5, 5 + @randValue()],
        [6, 20 + @randValue()],
        [7, 25 + @randValue()],
        [8, 36 + @randValue()],
        [9, 26 + @randValue()],
        [10, 38 + @randValue()],
        [11, 39 + @randValue()],
        [12, 50 + @randValue()],
        [13, 51 + @randValue()],
        [14, 12 + @randValue()],
        [15, 13 + @randValue()],
        [16, 14 + @randValue()],
        [17, 15 + @randValue()],
        [18, 15 + @randValue()],
        [19, 16 + @randValue()],
        [20, 17 + @randValue()],
        [21, 18 + @randValue()],
        [22, 19 + @randValue()],
        [23, 20 + @randValue()],
        [24, 21 + @randValue()],
        [25, 14 + @randValue()],
        [26, 24 + @randValue()],
        [27, 25 + @randValue()],
        [28, 26 + @randValue()],
        [29, 27 + @randValue()],
        [30, 31 + @randValue()]
      ].slice 0, limit
