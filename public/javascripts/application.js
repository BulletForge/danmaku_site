// setting metadata default params
$.metadata.setType('elem', 'script');

var handle_search_type = function(){
    var title_like = $("#search_title_like");
    var user_login_like = $("#search_user_login_like");
    var tagged_with = $("#search_tagged_with");
    var keyword = title_like.val() + user_login_like.val() + tagged_with.val();
    title_like.val('');
    user_login_like.val('');
    tagged_with.val('');
    title_like.addClass('hidden');
    user_login_like.addClass('hidden');
    tagged_with.addClass('hidden');
        
    switch(this.value)
    {
        case "title":
            title_like.removeClass('hidden');
            title_like.val(keyword);
            break;
        case "username":
            user_login_like.removeClass('hidden');
            user_login_like.val(keyword);
            break;
        case "tags":
            tagged_with.removeClass('hidden');
            tagged_with.val(keyword);
            break;
        default:
            title_like.removeClass('hidden');
            title_like.val(keyword);
            break;
    }
};

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
    handle_search_type.apply($('#search_type')[0]);
    $('#search_type').change(handle_search_type);
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