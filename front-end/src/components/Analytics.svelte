<script>
  var Countly = Countly || {};
  Countly.q = Countly.q || [];

  Countly.app_key = 'a7e9b2afbbddf5fec01b3dbb76c3e3fc1ab3befe';
  Countly.url = 'https://analytics.ficklebits.com';

  Countly.q.push(['track_sessions']);
  Countly.q.push(['track_pageview']);
  Countly.q.push(['track_errors']);

  (function() {
    var cly = document.createElement('script'); cly.type = 'text/javascript';
    cly.async = true;
    cly.src = 'https://cdnjs.cloudflare.com/ajax/libs/countly-sdk-web/20.4.0/countly.min.js';
    cly.onload = function(){setTimeout(Countly.init, 100)};
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(cly, s);
  })();
</script>

<noscript><img alt="" src='https://analytics.ficklebits.com/pixel.png?app_key=a7e9b2afbbddf5fec01b3dbb76c3e3fc1ab3befe&begin_session=1'/></noscript>
