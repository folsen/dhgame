/*****************************************************************
 *
 * jsProgressBarHandler 0.1 - by Bramus! - http://www.bram.us/
 *
 * v 0.1 - 2007.08.02 - initial release
 *
 * Licensed under the Creative Commons Attribution 2.5 License - http://creativecommons.org/licenses/by/2.5/
 *
 *****************************************************************/
 
	if (!JS_BRAMUS) { var JS_BRAMUS = new Object(); }

	JS_BRAMUS.jsProgressBarHandler = Class.create();
	
	JS_BRAMUS.jsProgressBarHandler.prototype = {
	
		imageWidth			: 240,
		pbArray				: new Object(),
	
		initialize			: function() {
			
			this.initialPos		= (this.imageWidth / 2) * (-1);
			this.pxPerPercent	= (this.imageWidth / 2) / 100;
			
			$$('span.progressBar').each(function(progressBar) {
				this.buildProgressBar(progressBar);  
			}.bind(this));
			
		},
		
		buildProgressBar	: function(progressBar) {
			var percentage 		= parseInt(progressBar.innerHTML.replace("%",""));
			var id				= progressBar.id;
			
			progressBar.update('<img id="' + id + '_percentImage" src="/images/percentImage.png" alt="0%" style="background-position: 0px 0px;"/> <span id="' + id + '_percentText">0%</span>');
			
			this.setPercentage(id, percentage);
		},
		
		setPercentage		: function(id, percentage) {

			var prevPercentage	= (this.pbArray[id] || 0);
			
			if ((percentage.toString().substring(0,1) == "+") || (percentage.toString().substring(0,1) == "-")) {
				percentage	= prevPercentage + parseInt(percentage);
			}
			
			if (percentage < 0)		percentage = 0;
			if (percentage > 100)	percentage = 100;
			
			if (percentage != prevPercentage) {					
				if (prevPercentage < percentage) {
					prevPercentage++;	
				} else {
					prevPercentage--;	
				}			
			}
			
			this.pbArray[id]	= prevPercentage;
			
			$(id + "_percentImage").style.backgroundPosition 	= "" + (this.initialPos + (prevPercentage * this.pxPerPercent)) + "px 0px";
			$(id + "_percentImage").alt 						= "" + prevPercentage + "%";
			$(id + "_percentImage").title 						= "" + prevPercentage + "%";
			
			$(id + "_percentText").update("" + prevPercentage + "%");
										  
			if (percentage != prevPercentage) {
				setTimeout("myJsProgressBarHandler.setPercentage('" + id + "','" + percentage + "')", 10);
			}
			
		},
		
		getPercentage		: function(id) {
			return this.pbArray[id];	
		}
	
	}
	

	function initProgressBarHandler() { myJsProgressBarHandler = new JS_BRAMUS.jsProgressBarHandler(); }
	Event.observe(window, 'load', initProgressBarHandler, false);