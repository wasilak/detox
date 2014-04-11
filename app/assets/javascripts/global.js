$(document).ready(function(){
  $('.ajax-popup-link').magnificPopup({
        type: 'ajax'
    });
  $.magnificPopup.instance._onFocusIn = function(e) {
      // Do nothing if target element is select2 input
      if( $(e.target).hasClass('select2-input') ) {
         return true;
      } 
      // Else call parent method
      $.magnificPopup.proto._onFocusIn.call(this,e);
  };
});
