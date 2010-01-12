// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
function uploadSuccess(value){
    console.log("success");
    var input = $("version_asset_id");
    input.value = value;
}

function uploadFailed(message){
    console.log("failure");
}