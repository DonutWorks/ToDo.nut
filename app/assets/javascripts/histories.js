
$(document).on('ready page:load', function () {
  $('#history_description').textcomplete([
    {
      match: /\B#(\w*)$/,
      search: function (term, callback) {
        $.getJSON('/projects/'+gon.project_id+'/histories/list/' + term)
        .done(function (res) {
          callback($.map(res, function (history) {
            return '#' + history.id + ': ' + history.title;
          }));
        })
        .fail(function (res) {
          callback([]);
        });
      },
      replace: function (history) {
        return history.split(':')[0] + " ";
      },
      index: 1
    }, {
    //   match: /\B@(\w*)$/,
    //   search: function (term, callback) {
    //     $.getJSON('/histories/list_members/')
    //     .done(function (res) {
    //       callback($.map(res, function (member) {
    //         return member.email;
    //       }));
    //     })
    //     .fail(function (res) {
    //       callback([]);
    //     })
    //   },
    //   index: 1,
    //   replace: function (member) {
    //     return '@' + member + ' ';
    //   }
    // }, {
      match: /\B&(\w*)$/,
      search: function (term, callback) {
        $.getJSON('/projects/'+gon.project_id+'/todos/list/' + term)
        .done(function (res) {
          callback($.map(res, function (todo) {
            return '&' + todo.id + ': ' + todo.title;
          }));
        })
        .fail(function (res) {
          callback([]);
        })
      },
      index: 1,
      replace: function (todo) {
        return todo.split(':')[0] + " ";
      }
    }]);
});
