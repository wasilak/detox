jQuery('#budgets_table').dataTable({
  "aLengthMenu": [[10, 25, 50, 100, 200, -1], [10, 25, 50, 100, 200, "All"]],
  "iDisplayLength": 50
});

jQuery(function () {
  var chart;
  jQuery(document).ready(function() {
    // $('.inlinesparkline').sparkline('html', { enableTagOptions: true });

    $('.inlinesparkline').each(function() {
      var values = $.parseJSON($(this).attr('data-values'));
      $(this).sparkline(values, { type:'pie'});
    });

        $('#chart_1').highcharts({
            chart: {
                // type: 'areaspline'
                // type: 'area'
                // type: 'spline'
                // type: 'line'
                type: 'column'
            },
            title: {
                text: 'Stacked column chart'
            },
            xAxis: {
                categories: chart1_data.categories
            },
            yAxis: {
                min: 0,
                title: {
                    text: 'Expenses in Budgets'
                },
                stackLabels: {
                    enabled: true,
                    style: {
                        fontWeight: 'bold',
                        color: (Highcharts.theme && Highcharts.theme.textColor) || 'gray'
                    }
                }
            },
            legend: {
                align: 'right',
                x: -70,
                verticalAlign: 'top',
                y: 20,
                floating: true,
                backgroundColor: (Highcharts.theme && Highcharts.theme.background2) || 'white',
                borderColor: '#CCC',
                borderWidth: 1,
                shadow: false
            },
            tooltip: {
                formatter: function () {
                    return '<b>' + this.x + '</b><br/>' +
                        this.series.name + ': ' + this.y + '<br/>' +
                        'Total: ' + this.point.stackTotal;
                }
            },
            plotOptions: {
                column: {
                    stacking: 'normal',
                    dataLabels: {
                        enabled: true,
                        color: (Highcharts.theme && Highcharts.theme.dataLabelsColor) || 'white',
                        style: {
                            textShadow: '0 0 3px black, 0 0 3px black'
                        }
                    }
                }
            },
            series: chart1_data.series
        });

      // chart = new Highcharts.Chart({
      //     credits: false,
      //     chart: {
      //         renderTo: 'pieChart',
      //         plotBackgroundColor: null,
      //         plotBorderWidth: null,
      //         plotShadow: true
      //     },
      //     title: false,
      //     tooltip: {
      //       pointFormat: '<b>{point.y} zł ( {point.percentage}% )</b>',
      //       percentageDecimals: 1
      //     },
      //     plotOptions: {
      //         pie: {
      //             allowPointSelect: true,
      //             cursor: 'pointer',
      //             dataLabels: {
      //                 enabled: false
      //             },
      //             showInLegend: true
      //             }
      //     },
      //     legend: {
      //       layout: 'horizontal',
      //       labelFormatter: function() {
      //         return this.name;
      //       }
      //     },
      //     series: [{
      //         type: 'pie',
      //         name: 'share',
      //         data: chart1_data
      //     }]
      // });
      // chart2 = new Highcharts.Chart({
      //     credits: false,
      //     chart: {
      //         renderTo: 'pieChart2',
      //         plotBackgroundColor: null,
      //         plotBorderWidth: null,
      //         plotShadow: true
      //     },
      //     title: false,
      //     tooltip: {
      //       // pointFormat: '{series.name}: <b>{point.percentage}%</b>',
      //       pointFormat: '<b>{point.y} zł ( {point.percentage}% )</b>',
      //       percentageDecimals: 1
      //     },
      //     plotOptions: {
      //         pie: {
      //             allowPointSelect: true,
      //             cursor: 'pointer',
      //             dataLabels: {
      //                 enabled: false
      //             },
      //             showInLegend: true
      //         }
      //     },
      //     legend: {
      //       layout: 'horizontal',
      //       labelFormatter: function() {
      //         // return '<b>'+ this.name +'</b>( '+ this.y.toFixed(2) +' zł )';
      //         return this.name;
      //       }
      //     },
      //     series: [{
      //         type: 'pie',
      //         name: 'share',
      //         data: chart2_data
      //     }]
      // });
  });

});
