String getHtmlTemplate(String redirectUrl) {
  return '''
<!DOCTYPE html>
<html>
<head>
  <title>Payment</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <script type="text/javascript">
    function redirectToUrl() {
      setTimeout(function() {
        window.location.href = '$redirectUrl';
      }, 1);
    }
  </script>
</head>
<body onload="redirectToUrl()">
</body>
</html>
''';
}
