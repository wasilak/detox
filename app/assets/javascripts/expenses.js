// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

  jQuery(document).ready(function(){

    jQuery('#tabs a').click(function (e) {
      e.preventDefault();
      jQuery(this).tab('show');
    });

    jQuery('#tabs a:first').tab('show');

    jQuery('#expensesTable').dataTable({
      "aLengthMenu": [[10, 25, 50, 100, 200, -1], [10, 25, 50, 100, 200, "All"]],
      "iDisplayLength": 50,
      "fnFooterCallback": function ( nRow, aaData, iStart, iEnd, aiDisplay ) {

            var expenses_sum = 0;
            for ( var i=0 ; i<aiDisplay.length ; i++ )
            {
                Globalize.culture("pl");
                amount = Globalize.parseFloat(Globalize.format(aaData[aiDisplay[i]][3], "c"));
                expenses_sum += Number(amount);
            }

            jQuery("#sum").html(Globalize.format(expenses_sum, "c"));
        },
        "oLanguage": {
          "sLengthMenu": "_MENU_"
        }
    });

  });
  jQuery(function () {
      var chart;
      jQuery(document).ready(function() {
          chart = new Highcharts.Chart({
              credits: false,
              chart: {
                  renderTo: 'pieChart',
                  plotBackgroundColor: null,
                  plotBorderWidth: null,
                  plotShadow: true
              },
              title: false,
              tooltip: {
                pointFormat: '<b>{point.y} zł ( {point.percentage}% )</b>',
                percentageDecimals: 1
              },
              plotOptions: {
                  pie: {
                      allowPointSelect: true,
                      cursor: 'pointer',
                      dataLabels: {
                          enabled: false
                      },
                      showInLegend: true
                      }
              },
              legend: {
                layout: 'horizontal',
                labelFormatter: function() {
                  return this.name;
                }
              },
              series: [{
                  type: 'pie',
                  name: 'share',
                  data: chart1_data
              }]
          });
          chart2 = new Highcharts.Chart({
              credits: false,
              chart: {
                  renderTo: 'pieChart2',
                  plotBackgroundColor: null,
                  plotBorderWidth: null,
                  plotShadow: true
              },
              title: false,
              tooltip: {
                // pointFormat: '{series.name}: <b>{point.percentage}%</b>',
                pointFormat: '<b>{point.y} zł ( {point.percentage}% )</b>',
                percentageDecimals: 1
              },
              plotOptions: {
                  pie: {
                      allowPointSelect: true,
                      cursor: 'pointer',
                      dataLabels: {
                          enabled: false
                      },
                      showInLegend: true
                  }
              },
              legend: {
                layout: 'horizontal',
                labelFormatter: function() {
                  // return '<b>'+ this.name +'</b>( '+ this.y.toFixed(2) +' zł )';
                  return this.name;
                }
              },
              series: [{
                  type: 'pie',
                  name: 'share',
                  data: chart2_data
              }]
          });
      });

});
