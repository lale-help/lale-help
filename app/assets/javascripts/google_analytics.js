$(document).on('ready', function() {

  var trackingId = document.getElementsByTagName("body")[0].getAttribute('data-ga-id');

  if (trackingId) {
    (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
    (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
    m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
    })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');

    ga('create', trackingId, 'auto');
    // due to German privacy regulations IP needs to be anonymized; docs: https://goo.gl/EDPmwo
    ga('set', 'anonymizeIp', true);

    console.log("GA tracking with id:", trackingId);

    // We're using turbolinks so we need to call pageview on every page:change rather than page load.
    // page:change also gets called on full page reloads, so non-turbolinks requests are also tracked.
    $(document).on('page:change', function() {
      console.log("GA pageview:", window.location.pathname);
      ga('send', 'pageview', window.location.pathname);
    });
  }

});