// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require popper
//= require bootstrap
//= require cocoon
//= require_tree .

$(document).ready(function() {

  if ($('#new_user').length > 0) {
    $('.navbar').css('display', 'none');
  }


  $('#q_created_at_datebegin').datepicker({
    format: 'yyyy-mm-dd',
    autoclose: true,
    language: "ru",
    todayHighlight: true
  });
  $('#q_created_at_dateend').datepicker({
    format: 'yyyy-mm-dd',
    autoclose: true,
    language: "ru",
    todayHighlight: true
  });
  $('#q_updated_at_datebegin').datepicker({
    format: 'yyyy-mm-dd',
    autoclose: true,
    language: "ru",
    todayHighlight: true
  });
  $('#q_updated_at_dateend').datepicker({
    format: 'yyyy-mm-dd',
    autoclose: true,
    language: "ru",
    todayHighlight: true
  });
  $('#q_valid_until_dateend').datepicker({
    format: 'yyyy-mm-dd',
    autoclose: true,
    language: "ru",
    todayHighlight: true
  });
  $('#payment_paymentdate').datepicker({
    format: 'yyyy-mm-dd',
    autoclose: true,
    language: "ru",
    todayHighlight: true
  });

  // setTimeout(function() {
  //     $(".alert").fadeTo(500, 0).slideUp(500, function(){
  //         $(this).remove();
  //     });
  // }, 2000);

  $('.check-integr').on('ajax:complete', function(data) {
    console.log(data);
  });
  document.body.addEventListener('ajax:success', function(event) {
    var detail = event.detail;
    console.log(detail);
    var data = detail[0],
      status = detail[1],
      xhr = detail[2];
  })



});