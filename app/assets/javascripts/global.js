$(document).ready(function(){
  $('.ajax-popup-link').magnificPopup({
        type: 'ajax'
    });
  $('.open-popup-link').magnificPopup({
    type:'inline',
    midClick: true
  });
  $.magnificPopup.instance._onFocusIn = function(e) {
      // Do nothing if target element is select2 input
      if( $(e.target).hasClass('select2-input') ) {
         return true;
      } 
      // Else call parent method
      $.magnificPopup.proto._onFocusIn.call(this,e);
  };

  $('#budget').change(function(){
    $('#formBudget .form-control').fadeOut('fast', function() {
      $('.budget_wait').fadeIn('fast');
      $('#formBudget').submit();
    });
  });
});
