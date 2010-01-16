// setting metadata default params
$.metadata.setType('elem', 'script');

var handle_search_type = function(){
  console.log(arguments);
  
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

$(function(){
    $('#search_type').change(handle_search_type);
    handle_search_type.apply($('#search_type'));
    
})

function uploadFailed(message){
}