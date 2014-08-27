$(document).on('ready page:load', function () {
  $('[data-noti-id]').each(function (index, noti) {
    $(noti).on('click', function (e) {
      e.preventDefault();
      $.post('/notifications/mark', { id: $(noti).data('noti-id') })
        .done(function (data) {
          location.href = $(noti).attr('href');
        })
    })
  });
});