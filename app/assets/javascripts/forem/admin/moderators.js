//= require jquery.autocomplete

$(document).ready(function() {
  $('#new_member').autocomplete({
    source: function(word) {
      $.get('/admin/users/autocomplete')
    }
  });
})
