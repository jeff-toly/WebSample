//獲取IE版本
function IEVersion()
{ 
  var browser = navigator.appName;
  var b_version = navigator.appVersion;
  var version = b_version.split(";");
  if (version.length > 1)
  {
    var trim_Version = version[1].replace(/[ ]/g, "");
    if (browser == "Netscape" && trim_Version == "Trident/7.0")
      return "IE11";
    else if (browser == "Microsoft Internet Explorer" && trim_Version != "MSIE10.0")
      return "IE5-9";
    else if (browser == "Microsoft Internet Explorer")
      return "IE10";
  }
  return "NOT IE";
}
