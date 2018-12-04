function showRelated(link) {
  $(".toggle").hide()
  var target = $(link).data("target");
  $(target).show();
}

function formatDate() {
  var dateInput = $("#date").val();
  var date = moment(dateInput);
  var format = $("#format").val();
  var locale = $("#locale option:selected").val();

  var params = $.param({
    date: encodeURIComponent(date.format()), // need to properly escape the +
    format: format,
    timeZoneOffset: (new Date().getTimezoneOffset() / -60),
    locale: locale
  });

  if (dateInput.length > 0 && format.length > 0) {
    $("#result").html("...");
    $.ajax('/format', {
      type: "post",
      data: params,
      dataType: 'json',
      success: function(data, status, xhr) {
        if (data.status == "ok") {
          $("#result").text(data.result);
        } else {
          $("#result").html("<em>Invalid date or format</em>");
        }
      }
    })
  } else {
    $("#result").html("<em>Please specify a valid date and format</em>");
  }
}

function loadTailDateTime() {
  tail.DateTime(".tail-datetime-field")
}

$(function() {
  // loadTailDateTime();
  var activeLink = $("ul.nav li a.active")[0];
  showRelated(activeLink);

  $("ul.nav li a").click(function(e) {
    e.preventDefault();
    $("ul.nav li a").removeClass("active");
    $(this).addClass("active");
    showRelated(this);
    return false;
  });

  $(".try input[type='text']").on('keypress', function(e) {
    if (e.keyCode == 13) {
      e.preventDefault()
      formatDate()
    }
  });

  $(".try input[type='text']").change(function() {
    formatDate();
  })

  $('#locale').change(function() {
    formatDate()
  });

  // also run on load
  formatDate();
});
