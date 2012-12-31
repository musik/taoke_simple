var scriptjs = document.scripts[document.scripts.length - 1];
var keyword = scriptjs.getAttribute("data");
var jurl = "vcap.";
jurl += "me:3000";
var gourl = "http://" + jurl + "/search?tb=&q=" + keyword;
var srcjs = scriptjs.src;
//if (srcjs.indexOf('?') != -1) {
    //clickLink(gourl)
//}
function replaceLink() {
    var node = document.getElementsByTagName('h1')[0]
    node.innerHTML = "<a href=\"" + gourl + "\" id=\"goto\">去淘宝网选购" + node.innerHTML + "</a>";
    

}
function clickLink(url) {
    document.write("<a href=\"" + url + "\" id=\"goto\"></a>");
    try {
        document.getElementById("goto").click()
    } catch(e) {
        try {
            invokeClick(document.getElementById("goto"))
        } catch(x) {
            location.href = url
        }
    }
}
function invokeClick(element) {
    if (element.click) element.click();
    else if (element.fireEvent) element.fireEvent('onclick');
    else if (document.createEvent) {
        var evt = document.createEvent("MouseEvents");
        evt.initEvent("click", true, true);
        element.dispatchEvent(evt)
    }
}

