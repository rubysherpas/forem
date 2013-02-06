//= require select2

(function($) {
  $(document).ready(function() {
    $('#new_member').select2({
      minimumInputLength: 1,
      ajax: {
        url: Forem.routes.admin_user_autocomplete,
        datatype: 'json',
        data: function(term, page) {
          return { 
            term: term,
          }
        },
        results: function(data, page) {
          return { results: data };
        }
      },
      formatResult: function(user) {
        return user.value;
      },
      formatSelection: function(user) {
        return user.value;
      }
    });

    add_member = function() {
      user = $("#new_member").val()
      group_id = $('#add_member').data('group-id');
      $.post(Forem.routes.admin_group_members(group_id), { user: user })
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
})(jQuery)
