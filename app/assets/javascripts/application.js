//= require jquery
//= require jquery.metadata
//= require jquery_ujs
//= require s3_upload
//= require s3_upload_callbacks
//= require bootstrap

// setting metadata default params
$.metadata.setType('elem', 'script');
$(".alert").alert()

$(function(){
  $("body").on("click", "a[data-method=delete]", function() {
    var f = $("<form style='display:none' method='post' action='"+ this.href + "'><input type='hidden' name='_method' value='delete' /></form>");
    $(this).after(f);
    f.submit();
    return false;
  });
});
