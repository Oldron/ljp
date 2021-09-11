<%@ Page Language="C#" %>
<%@ Import Namespace="System.Net" %>
<%@ Import Namespace="System.Xml" %>
<script runat=server>

protected String getPhotos() {

  HttpWebRequest request = WebRequest.Create("http://www.livejournal.com/stats/latest-img.bml") as HttpWebRequest;
  HttpWebResponse response = (HttpWebResponse)request.GetResponse();
  WebHeaderCollection header = response.Headers;
  var encoding = ASCIIEncoding.ASCII;
  String responseText;
  using (var reader = new System.IO.StreamReader(response.GetResponseStream(), encoding)) {
      responseText = reader.ReadToEnd();
  }

  XmlDocument xml = new XmlDocument();
  xml.LoadXml(responseText);

  var sRes = "";
  XmlNodeList xnList = xml.SelectNodes("/livejournal/recent-images/recent-image");
  var cnt = 0;
  foreach (XmlNode xn in xnList) {
    var hrefImg = xn.Attributes["img"].Value; 
    var hrefUrl = xn.Attributes["url"].Value;
    var sItem = String.Format("<a href=\"{0}\"><img src=\"{1}\" /></a>", hrefUrl, hrefImg);
    sRes += sItem + "<br/>";
    cnt++;
    if(200 < cnt) {
      break;
    }
  }

  return sRes;
}
</script>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>LJ last photos</title>
  <link rel="shortcut icon" href="/favicon.ico" type="image/x-icon">
</head>
<body>
  <% =getPhotos()%>
</body>
</html>