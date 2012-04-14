jQuery ($) ->

  groupId = $('#add_member').data('group-id');
  $('#new_member').autocomplete(source: "#{Forem.base_path}/admin/users/autocomplete")

  $("#new_member").bind "autocompleteselect", (event, ui) ->
    $("#add_member").prop('disabled', false)

  addMember = ->
    user = $("#new_member").val()
    $.post("#{Forem.base_path}/admin/groups/#{groupId}/members", user: user)
    $(@).prop('disabled', true)
    $("#new_member").val("")
    $('#members').append('<li>' + user + '</li>')


  $('#add_member').click(addMember)

  $('#new_member').keypress (e) ->
    addMember() if e.which == 13


