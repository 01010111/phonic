package util;

import js.html.XMLHttpRequest;

class HrefTools {
    public static function fetch(href:String, then:String -> Void) {
        var request = new XMLHttpRequest();
        request.open("GET", href, true);
        request.onload = (e) -> then(request.response);
        request.onerror = (e) -> trace(e);
        request.send();
    }
}