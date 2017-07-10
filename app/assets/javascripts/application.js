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
//= require turbolinks
//= require_tree .
//= require jquery
//= require bootstrap-sprockets

// Post Character Counter

var max_count = 140

var updateCharacterCount = function(){

  var char_count = $('#post-textarea').val().length;
  var remaining_char = max_count - char_count;

  if (char_count <= max_count) {
    $('#post-character-count').removeClass('red_text')
      .text(remaining_char);
  } else {
    $('#post-character-count').addClass('red_text')
      .text(remaining_char);
  }
}

$(document).on('turbolinks:load', updateCharacterCount);
$(document).on('turbolinks:load', function(){
  $('#post-textarea').focus(function(){
    $("#post-textarea").on('change keyup paste input', updateCharacterCount);
  });
});