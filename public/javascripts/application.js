// setting metadata default params
$.metadata.setType('elem', 'script');

var handle_search_type = function(){
    // this --> $("search_type")
    var title_like = $("search_title_like");
    var user_login_like = $("search_user_login_like");
    var tagged_with = $("search_tagged_with");
    var keyword = title_like.value + user_login_like.value + tagged_with.value;

    switch(this.value)
    {
        case "title":
            title_like.writeAttribute('type', "text");
            title_like.writeAttribute('value', keyword);
            user_login_like.writeAttribute('type', "hidden");
            user_login_like.writeAttribute('value', "");
            tagged_with.writeAttribute('type', "hidden");
            tagged_with.writeAttribute('value', "");
            break;
        case "username":
            title_like.writeAttribute('type', "hidden");
            title_like.writeAttribute('value', "");
            user_login_like.writeAttribute('type', "text");
            user_login_like.writeAttribute('value', keyword);
            tagged_with.writeAttribute('type', "hidden");
            tagged_with.writeAttribute('value', "");
            break;
        case "tags":
            title_like.writeAttribute('type', "hidden");
            title_like.writeAttribute('value', "");
            user_login_like.writeAttribute('type', "hidden");
            user_login_like.writeAttribute('value', "");
            tagged_with.writeAttribute('type', "text");
            tagged_with.writeAttribute('value', keyword);
            break;
        default:
            title_like.writeAttribute('type', "text");
            title_like.writeAttribute('value', keyword);
            user_login_like.writeAttribute('type', "hidden");
            user_login_like.writeAttribute('value', "");
            tagged_with.writeAttribute('type', "hidden");
            tagged_with.writeAttribute('value', "");
            break;
    }
};

Event.observe(window, "load", function(){
    // this --> window
    Event.observe('search_type', 'change', handle_search_type);
    handle_search_type.apply($('search_type'));
    
})

function uploadFailed(message){
}