// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

  jQuery(document).ready(function(){

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
