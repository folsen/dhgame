var Requester = new Class({
	initialize: function(options){
		this.options = $merge({
			contentID: 					"content",
			loadingSpinner: 		"/images/spinner.gif"
		}, options || {});
		
		this.content = $(this.options.contentID);
	},
	get: function(path){
		this.content.setStyle('text-align', 'center');
		this.content.setStyle('padding', '30px 0 30px 0');
		this.content.set('html', '<img src="'+this.options.loadingSpinner+'" alt="Waiting..." />')
		new Request.HTML({
			url: path, 
			update: this.options.contentID, 
			method: 'get',
			onFailure: function(){
				failmsg = '<h2 style="text-align:center;">';
				failmsg += 'It was our purpose<br />';
				failmsg += 'Something went terribly wrong<br />';
				failmsg += 'We couldn\'t do it</h2>';
				this.content.set('html', failmsg);
			}.bind(this),
			onSuccess: function(){
				this.content.setStyle('text-align', 'left');
				this.content.setStyle('padding', '0');
				window.location.hash = path.substring(path.indexOf("/")+1);
			}.bind(this)
		}).send()
	}
});