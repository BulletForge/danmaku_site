(function($) {
  var FLASH_UPLOADER_ID = 0;
  
  var bindFunction = function(fn, target) {
    return function(){
      return fn.apply(target, arguments);
    };
  };
  
  var FlashUploader = function(el, settings) {
  	this.index = FLASH_UPLOADER_ID++;
  	this.el = el;
  	this.settings = settings;
  	this.container = el.find('.uploadContainer');

  	this.settings.file_dialog_complete_handler  =  bindFunction(this.fileDialogComplete, this);  	
		this.settings.upload_progress_handler       =  bindFunction(this.uploadProgress, this);
		this.settings.upload_error_handler          =  bindFunction(this.uploadError, this);
		this.settings.upload_success_handler        =  bindFunction(this.uploadSuccess, this);
		this.settings.upload_complete_handler       =  bindFunction(this.uploadComplete, this);
		  	
  	this.swfu = new SWFUpload(this.settings);
  	this.currentFileIndex = 0;
  };

  FlashUploader.prototype = {
  	cancelQueue: function(id) {
  	},

  	fileDialogComplete: function(numFilesSelected, numFilesQueued) {
  		for( var i=0; i < numFilesSelected; i++ ) {
  		  var file = this.swfu.getFile(this.currentFileIndex++);
  		  var template = $('<li id="' + this.fileDomId(file) + '"></li>');
  		  template.append( $('<h6></h6>').text(file.name) )
  		      .append('<div class="bar"><div class="progress" style="width:0"></div></div>');

  		  this.container.append(template);
  		}
  		
  		this.swfu.startUpload();
  	},

  	uploadProgress: function(file, bytesLoaded, bytesTotal) {
  	  var percent = bytesLoaded * 100 / bytesTotal;
  	  var percentStr = '' + percent + '%';
  		$(this.fileDomId(file)).find('.progress').css('width', percentStr);
  	},

  	uploadError: function(file, errorCode, message) {
  		alert(message);
  	},
  	
  	uploadSuccess: function(file, serverData) {
  	  var $file = $(this.fileDomId(file));
  	  var $progress = $file.find('.progress');
  	  
  	  $progress.css('width', '100%');
  		$file.fadeOut(function(obj) {
  		  obj.element.remove();
  		});
  		this.processServerData(serverData || {});
  	},
  	
  	processServerData : function(data) {
  	  data = JSON.parse(data);
  	  if ( data && data.success ){
  	    this.onSuccessData(data);
  	  } else {
  	    this.onFailureData(data);
  	  }
  	},
  	
  	onSuccessData : function(data) {
  	  $(data.replace_dom).fadeOut('normal', function(){
  	    $(data.replace_dom).html(data.partial)
  	      .prepend("<h4 class='notice'>Your files has been uploaded successfully!</h4>")
  	      .fadeIn('normal', function(){
  	          setTimeout(function(){
  	            $(data.replace_dom).find("h4.notice").fadeOut();	        
  	          }, 3000)
  	      });
  	  });
  	},
  	
  	onFailureData : function(data) {
  	  alert("failure! " + data);
  	},
  	
  	uploadComplete: function(file) {
  		if (this.swfu.getStats().files_queued > 0) {
  			this.swfu.startUpload();
  		}
  	},

  	fileDomId: function(file){
  		return 'fu_' + this.index + '_file_' + file.index
  	}
  	
  };
 
  FlashUploader.init = function() {
  	$('.swfUploadArea').each( function(i, element) {
  	  var $el = $(element);
  		if ( !$el.data('flashUploader') ) {
  		  var options = jQuery.extend( {}, FlashUploader.defaultOptions, $el.metadata() );
  		    		  
  		  if( options.single_file )
          options.button_actions = SWFUpload.BUTTON_ACTION.SELECT_FILE;
        else
          options.button_actions = SWFUpload.BUTTON_ACTION.SELECT_FILES;
          
        
  		  $el.data( 'flashUploader', new FlashUploader($el, options) );

  			var $buttonWrap = $el.find(".embedButton");
  			var $obj = $el.find('object');
  			var $input = $buttonWrap.find('input');

  			$buttonWrap.css('position', 'relative');

  			$obj.css({
  			  position    : 'absolute',
  				left        : 0,
  				top         : 0,
  				width       : $input.width() + 'px',
  				height      : $input.height() + 'px'
  			});
  		}
  	})
  };
  
  FlashUploader.defaultOptions = {
    flash_url               : "/flash/swfupload.swf",
    use_query_string        : true,
    upload_url              : '/upload',
    file_size_limit         : '200MB',
    file_types              : "*",
    file_types              : "All file types",
    file_upload_limit       : 0,
    button_width            : 180,
    button_height           : 18,
    button_text             : '<span class="button"></span>',
    button_text_style       : '.button { font-family: Arial, sans-serif; font-size: 14pt; font-weight:bold; }',
    button_text_top_padding : 0,
    button_text_left_padding: 0,
    button_placeholder_id   : 'swfUploadButton',
    button_window_mode      : SWFUpload.WINDOW_MODE.TRANSPARENT,
    button_cursor           : SWFUpload.CURSOR.HAND,
    single_file             : false,
    debug                   : false    
  };
  
  // Initialize all flash uploaders
  $(function(){ FlashUploader.init(); });
})(jQuery);







