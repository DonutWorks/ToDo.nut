
$(document).on('ready page:load', function () {
  $('#history_description').textcomplete([
    {
      match: /\B#(\w*)$/,
      search: function (term, callback) {
        $.getJSON('/' + gon.project_creator + '/' + gon.project_title + '/histories/list/' + term)
        .done(function (res) {
          callback($.map(res, function (history) {
            return '#' + history.phistory_id + ': ' + history.title;
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
      match: /\B@([^\s]*)$/,
      search: function (term, callback) {

        $.getJSON('/' + gon.project_creator + '/' + gon.project_title + '/members/' + term)

        .done(function (res) {
          callback($.map(res, function (member) {
            return member.nickname;
          }));
        })
        .fail(function (res) {
          callback([]);
        })
      },
      index: 1,
      replace: function (member) {
        return '@' + member + ' ';
      }
    }, {
      match: /\B&(\w*)$/,
      search: function (term, callback) {
        $.getJSON('/' + gon.project_creator + '/' + gon.project_title + '/todos/list/' + term)
        .done(function (res) {
          callback($.map(res, function (todo) {
            // return '&' + todo.id + ': ' + todo.title;
            return '&' + todo.ptodo_id + ': ' + todo.title;
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
