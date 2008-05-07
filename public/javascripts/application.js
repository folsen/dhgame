// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
function slideDown(id_of_element_to_slide){
	new Effect.toggle(id_of_element_to_slide,'blind',[]);
}

counter = 0;

function startCounter(){
	$('counter_box').show();
	t = setTimeout(activateButton,1000);
}

function activateButton(){
	counter = counter + 1;
	$('javascript_counter').innerHTML = (15 - counter);
	if(counter == 15){
		$('submit_button').enable();
		$('text_input').enable();
		$('javascript_counter').innerHTML = "";
		$('counter_box').hide();		
	}else{
		startCounter();
			
	}
}

function showInfoBox(info_box_element){
	msg = $(info_box_element).innerHTML;
	alert(msg);
}

function hideBySlide(element_id){
	new Effect.toggle($(element_id), 'blind', []);
}