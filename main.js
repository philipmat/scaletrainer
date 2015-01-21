function hideAddressBar() {
	window.scrollTo(0, 1);
}

function w(what) {
	document.write(what)
}

function getParameterByName(name) {
    var match = RegExp('[?&]' + name + '=([^&]*)')
                    .exec(window.location.search);
    return match && decodeURIComponent(match[1].replace(/\+/g, ' '));
}

function g(where) {
	var newQS = window.location.search.replace(/t=./, '');
	newQS += '&t=' + where;
	document.location = newQS;
}
