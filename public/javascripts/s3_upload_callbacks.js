var queueBytesLoaded = 0;
var myQueue = null;

var queueChangeHandler = function(queue){
	myQueue = queue;
	$('#s3-swf-upload-bar > span.name').html(queue.files[0].name)
	$('#s3-swf-upload-bar > span.size').html(readableBytes(queue.files[0].size))
};

var uploadingFinishHandler = function(){
	$('#s3-swf-upload-bar > span.progress').css('width', '100%');
	$('#s3-swf-upload-bar > span.progress > span.percentage').html('100%');
  	alert('All files have been successfully uploaded');
};

var progressHandler = function(progress_event){
	$('#file_todo_list:first-child > span.file_size').css('display', 'none');
	var current_percentage = Math.floor((parseInt(progress_event.bytesLoaded)/parseInt(progress_event.bytesTotal))*100)+'%';
	$('#s3-swf-upload-bar > span.progress').css({display: 'block', width: current_percentage});
	$('#s3-swf-upload-bar > span.progress > span.percentage').html(current_percentage);
};

var readableBytes = function(bytes) {
	var s = ['bytes', 'kb', 'MB', 'GB', 'TB', 'PB'];
	var e = Math.floor(Math.log(bytes)/Math.log(1024));
	return (bytes/Math.pow(1024, Math.floor(e))).toFixed(2)+" "+s[e];
}

var uploadingFinishHandler = function(upload_options, event){
	console.log(upload_options)
	console.log(event)
}
