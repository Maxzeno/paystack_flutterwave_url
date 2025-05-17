String getHtmlTemplate(String redirectUrl) {
  return '''
<!DOCTYPE html>
<html>
<head>
  <title>Redirect After Delay</title>
  <script type="text/javascript">
    function redirectToUrl() {
      setTimeout(function() {
        window.location.href = '$redirectUrl';
      }, 10);
    }
  </script>
</head>
<body onload="redirectToUrl()">
  <h1></h1>
</body>
</html>
''';
}
