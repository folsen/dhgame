var Requester = new Class({
	initialize: function(options){
		this.options = $merge({
			contentID: 					"content",
			loadingSpinner: 		"/images/spinner.gif"
		}, options || {});
		this.hash = window.location.hash;
		this.content = $(this.options.contentID);
		
		// Poll to see if a user clicks forward or back
		this.hashChange.periodical(100, this);
	},
	get: function(path){
		this._setupSpinner();
		new Request.HTML({
			url: path, 
			update: this.options.contentID, 
			method: 'get',
			onFailure: this._displayFailMessage.bind(this),
			onSuccess: this._resetStyleAndPath.bind(this, path)
		}).send();
		if($defined($$("#menu li."+path.substring(path.indexOf('/')+1))[0])) {
			$$("#menu li").each(function(li){
				li.removeClass("active");
			});
			$$("#menu li."+path.substring(path.indexOf('/')+1))[0].addClass("active");
		}
	},
	sendForm: function(path, method, parameters) {
		this._setupSpinner();
		new Request.HTML({
			url: path, 
			update: this.options.contentID, 
			method: method,
			onFailure: this._displayFailMessage.bind(this),
			onSuccess: this._resetStyleAndPath.bind(this)
		}).send(parameters);
	},
	hashChange: function(){
		if(window.location.hash != this.hash){
			this.get("/"+window.location.hash.substring(1));
		}
		this.hash = window.location.hash;
	},
	bindLinkEvents: function(){
		$$('.load-remote').each(function(link){
			link.addEvent('click', function(e){
				e.stop();
				requester.get(link.getProperty("href"));
			});
		});
	},
	_resetStyleAndPath: function(path){
		this.content.setStyle('text-align', 'left');
		this.content.setStyle('padding', '0');
		if(path){
			window.location.hash = path.substring(path.indexOf("/")+1);	
		}
		this.hash = window.location.hash;
		this.bindLinkEvents();
	},
	_displayFailMessage: function(){
		failmsg = '<h2 style="text-align:center;">';
		failmsg += 'It was our purpose<br />';
		failmsg += 'Something went terribly wrong<br />';
		failmsg += 'We couldn\'t do it</h2>';
		this.content.set('html', failmsg);
	},
	_setupSpinner: function(){
		this.content.setStyle('text-align', 'center');
		this.content.setStyle('padding', '30px 0 30px 0');
		this.content.set('html', '<img src="'+this.options.loadingSpinner+'" alt="Waiting..." />');
	},
});