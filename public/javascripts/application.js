// setting metadata default params
$.metadata.setType('elem', 'script');

var voting_ajax = function(el, vote){
    $.ajax({
        url: el.href,
        type: "POST",
        contentType: "application/json; charset-utf-8",
        data: JSON.stringify({vote : {vote : vote}}),
        dataType: "json",
        success: function(data, status, request){
            $(data.replace_dom).html(data.partial)
        },
        error: function(request, status, error){
        }
    });
    return false;
}

$(function(){
    var $up = $("#vote_up");
    var $down = $("#vote_down");
    $up.click(function(e){return voting_ajax(e.target, true);});
    $down.click(function(e){return voting_ajax(e.target, false);});
});


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