
var deleteCookie, getCookie, setCookie;

getCookie = function(name) {
  var end, len, start;
  start = document.cookie.indexOf(name + "=");
  len = start + name.length + 1;
  if ((!start) && (name !== document.cookie.substring(0, name.length))) {
    return null;
  }
  if (start === -1) return null;
  end = document.cookie.indexOf(";", len);
  if (end === -1) end = document.cookie.length;
  return unescape(document.cookie.substring(len, end));
};

setCookie = function(name, value, expires, path, domain, secure) {
  var expires_date, today;
  today = new Date();
  today.setTime(today.getTime());
  if (expires) expires = expires * 1000 * 60 * 60 * 24;
  expires_date = new Date(today.getTime() + expires);
  return document.cookie = name + "=" + escape(value) + (expires ? ";expires=" + expires_date.toGMTString() : "") + (path ? ";path=" + path : "") + (domain ? ";domain=" + domain : "") + (secure ? ";secure" : "");
};

deleteCookie = function(name, path, domain) {
  if (getCookie(name)) {
    return document.cookie = name + "=" + (path ? ";path=" + path : "") + (domain ? ";domain=" + domain : "") + ";expires=Thu, 01-Jan-1970 00:00:01 GMT";
  }
};

