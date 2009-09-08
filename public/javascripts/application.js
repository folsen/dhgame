window.addEvent('domready', function(){
	requester = new Requester();
	
	if(location.hash != ""){
		requester.get("/"+location.hash.substring(1));	
	} else {
		requester.get("/home");
	}
	
	$('menu').getChildren("li").each(function(li){
		li.addEvent('click', function(){
			$$("#menu li.active").each(function(activeLi){
				activeLi.removeClass("active");
			});
			requester.get(li.getProperty("class"));
			li.addClass("active");
		});
	});
});