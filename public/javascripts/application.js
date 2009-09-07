window.addEvent('domready', function(){
	$('menu').getChildren("li").each(function(li){
		li.addEvent('click', function(){
			$$("#menu li.active").each(function(activeLi){
				activeLi.removeClass("active");
			});
			li.addClass("active");
		});
	});
});