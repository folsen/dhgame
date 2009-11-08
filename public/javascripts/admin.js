window.addEvent('domready', function(){
	if($defined($('query'))){
		$('query').addEvent('keyup', function(){
			new Request.HTML({method: 'get', url: "/admin/users?query="+$('query').value, update: $('tableContent') }).send();
		});
	}
	
	if($defined($('wrong-answers'))){
		updateWrongAnswers.periodical(2000);
	}
});

function updateWrongAnswers() {
	new Request({method: 'get', url: "/admin/visualize?last_id="+lastID(),
		onSuccess: function(responseText){
			$('wrong-answers').set('html',responseText+$('wrong-answers').get('html'));
		}
	}).send();
}
function lastID(){
	return $('wrong-answers').getFirst().getFirst().get('html');
}