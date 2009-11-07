window.addEvent('domready', function(){
	if($defined($('query'))){
		$('query').addEvent('keyup', function(){
			new Request.HTML({method: 'get', url: "/admin/users/search_users?query="+$('query').value, update: $('tableContent') }).send();
		});
	}
});