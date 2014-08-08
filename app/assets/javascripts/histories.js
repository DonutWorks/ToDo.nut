// # Place all the behaviors and hooks related to the matching controller here.
// # All this logic will automatically be available in application.js.
// # You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready(function () {
  $('#history_description').textcomplete([
    {
      match: /\B#(\w*)$/,
      search: function (term, callback) {
        $.getJSON('/histories/list/' + term)
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
      match: /\B@(\w*)$/,
      search: function (term, callback) {
        $.getJSON('/histories/list_members/')
        .done(function (res) {
          callback($.map(res, function (member) {
            return member.email;
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
      match: /\B\!(\w*)$/,
      search: function (term, callback) {
        $.getJSON('/todos/list/')
        .done(function (res) {
          callback($.map(res, function (todo) {
            return '!' + todo.id + ': ' + todo.title;
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