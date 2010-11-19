var queueBytesLoaded = 0;
var file = null;

var queueChangeHandler = function(queue){
	file = queue.files[0];
	$('#s3-swf-upload-bar > span.name').html(file.name)
	$('#s3-swf-upload-bar > span.size').html(readableBytes(file.size))
};

var uploadingFinishHandler = function(){
	$('#s3-swf-upload-bar > span.progress').css('width', '100%');
	$('#s3-swf-upload-bar > span.progress > span.percentage').html('100%');
  	postArchiveData();
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

var postArchiveData = function(){
	var key = s3_swf_1_object.keyPrefix + file.name;
	$.ajax({
		url:  "/upload/archive",
        type: "POST",
        contentType: "application/json; charset-utf-8",
        data: JSON.stringify({archive: {s3_key: key, attachment_file_name: file.name}, user_id: user_id, project_id: project_id, version_id: version_id}),
        dataType: "json",
        success: function(data, status, request){
            $(data.replace_dom).html(data.partial)
        },
        error: function(request, status, error){
        }
	});
}