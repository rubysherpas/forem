// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
//= require jquery.autocomplete
//= require forem
//
jQuery(function($) {
  var groupId = $('#add_member').data('group-id');
  $('#new_member').autocomplete({source: Forem.base_path + 'admin/users/autocomplete'})

  $("#new_member").bind("autocompleteselect", function(event, ui) {
    $("#add_member").prop('disabled', false)
  })

  var addMember = function() {
    var user = $("#new_member").val()
    $.post(Forem.base_path + 'admin/groups/' + groupId + '/members', { user: user })
    $(this).prop('disabled', true)
    $("#new_member").val("")
    $('#members').append('<li>' + user + '</li>')
  }

  $('#add_member').click(addMember);
  $('#new_member').keypress(function(e){
    if (e.which == 13) {
      addMember();
    }
  });
});
