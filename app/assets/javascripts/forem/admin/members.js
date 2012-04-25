// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
//= require jquery.autocomplete
//= require forem
//
$(document).ready(function() {
  group_id = $('#add_member').data('group-id');
  $('#new_member').autocomplete({source: Forem.base_path + '/admin/users/autocomplete'})

  $("#new_member").bind("autocompleteselect", function(event, ui) {
    $("#add_member").attr('disabled', false)
  })

  add_member = function() {
    user = $("#new_member").val()
    $.post(Forem.base_path + '/admin/groups/' + group_id + '/members', { user: user })
    $(this).attr('disabled', true)
    $("#new_member").val("")
    $('#members').append('<li>' + user + '</li>')
  }

  $('#add_member').click(add_member)
  $('#new_member').keypress(function(e){
    if (e.which == 13) {
      add_member();
    }
  })
})
