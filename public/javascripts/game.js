var Game = new Class({
	initialize: function(options){
		this.options = $merge({
			contentID:					"content", 
			loadingSpinner: 		"/images/spinner.gif"
		}, options || {});
		
		this.funny_messages = [
			"Calculating eigenvalues...",
			"Collapsing Schrödingers equation...",
			"Looking up stuff in the database...",
			"Googling your answer...",
			"Trying to figure out what you're doing...",
			"Unraveling the circular references...",
			"Calculating residual electronic interaction...",
			"Reticulating splines..."
		];
		
		this.content = $(this.options.contentID);
	},
	play: function(parameters) {
		this._setupSpinner();
		var usedMessages = $A([]);
		var numberOfMessages = Math.floor(Math.random()*3)+2;
		for(i=0;i<numberOfMessages;i++){
			var index = Math.floor(Math.random()*this.funny_messages.length);
			while(usedMessages.contains(index)){
				index = Math.floor(Math.random()*this.funny_messages.length);
			}
			usedMessages.push(index);
			this._setWaitMsg.delay(1300*i, this, usedMessages.getLast());
		}
		(
			function() { 
				new Request({
					url: '/answer', 
					evalScripts: true,
					method: 'post',
					onFailure: function(xhr){
						if(xhr.status == 404){
							failmsg = '<img src="/images/failure.png" alt="Failure">';
							failmsg += '<h2 style="text-align:center;">';
							failmsg += 'Nope.. that ain\'t right</h2>';
							this.content.set('html', failmsg);
						} else if(xhr.status == 418){
							failmsg = '<img src="/images/time.png" alt="Can\'t answer yet">';
							failmsg += '<h2 style="text-align:center;">';
							failmsg += 'Sorry, but you have to wait 15 seconds between answers.';
							failmsg += '</h2>';
							this.content.set('html', failmsg);
						} else {
							failmsg = '<h2 style="text-align:center;">';
							failmsg += 'Something went wrong and we could not process your request.<br />';
							failmsg += 'Please contact an admin if the problem does not go away.</h2>';
							this.content.set('html', failmsg);
							(function(){window.location.reload()}).delay(2000);
							return false;
						}
						(function(){
							this._resetStyle();
							this.content.set('html', xhr.responseText);
						}).delay(3000, this);
					}.bind(this),
					onSuccess: function(responseText){
						successmsg = '<img src="/images/success.png" alt="Success">';
						successmsg += '<h2 style="text-align:center;">';
						successmsg += 'Success!</h2>';
						this.content.set('html', successmsg);
						(function(){
							this._resetStyle();
							this.content.set('html', responseText);
						}).delay(3000, this);
					}.bind(this)
				}).send(parameters)
			}
		).delay(1400*(numberOfMessages), this);
	},
	_resetStyle: function(){
		this.content.setStyle('text-align', 'left');
		this.content.setStyle('padding', '0');
	},
	_displaySuccessMessage: function(response){
		this.content.setStyle('text-align', 'left');
		this.content.setStyle('padding', '0');
		this.content.set('html', response);
	},
	_displayFailMessage: function(response){
		this.content.setStyle('text-align', 'left');
		this.content.setStyle('padding', '0');
		failmsg = '<h2 style="text-align:center;">';
		failmsg += 'It was our purpose<br />';
		failmsg += 'Something went terribly wrong<br />';
		failmsg += 'We couldn\'t do it</h2>';
		this.content.set('html', failmsg);
	},
	_setupSpinner: function(){
		this.content.setStyle('text-align', 'center');
		this.content.setStyle('padding', '30px 0 30px 0');
		this.content.set('html', '<img src="'+this.options.loadingSpinner+'" alt="Waiting..." /><span id="wait-msg"></span>');
	},
	_setWaitMsg: function(index){
		$('wait-msg').set('html', '<h2 style="text-align:center;">'+this.funny_messages[index]+'</h2>');
	}
});