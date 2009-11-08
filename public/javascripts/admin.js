window.addEvent('domready', function(){
	if($defined($('query'))){
		$('query').addEvent('keyup', function(){
			new Request.HTML({method: 'get', url: "/admin/users?query="+$('query').value, update: $('tableContent') }).send();
		});
	}
});