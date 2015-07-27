// setting metadata default params
$.metadata.setType('elem', 'script');
$(".alert").alert()

$(function(){
  $("a[data-method=delete]").live("click", function() {
    var f = $("<form style='display:none' method='post' action='"+ this.href + "'><input type='hidden' name='_method' value='delete' /></form>");
    $(this).after(f);
    f.submit();
    return false;
  });
});

function uploadFailed(message){
}