$(document).ready(function(){
    console.log($.fn.jquery)
    // on page change, needed because pages don't reload
    // as you go through pages
    $(window).bind('page:change', function() {
        console.log("Changed page");
        
        window_loaded = false;
        
        //force window to load
        $(window).load();
    });
});

$(window).load(function(){

    if(!window_loaded){
        
        window_loaded = true;
        
        console.log("window loaded");
        
        // remove all handlers from inputs and divs
        // to prevent duplicate actions
        $("div,span,button,input").off();
        
        $(".tag_section").each(function(i, obj) {
            $(obj).click(function(){
                if(currentOpenTab != ""){
                    $("#"+currentOpenTab+"_links").toggle(300);
                    if(currentOpenTab == $(obj).attr("tag_name")){
                        currentOpenTab = "";
                        return;
                    }
                }
                if(currentOpenTab != $(obj).attr("tag_name")){
                    currentOpenTab = "";
                    $("#"+$(obj).attr("tag_name")+"_links").toggle(300, function(){
                        if($("#"+$(obj).attr("tag_name")+"_links").css("display") == "block")
                            currentOpenTab = $(obj).attr("tag_name");
                    });
                }
            });
        });
        
        $(".current_tag").each(function(i, obj) {
            $(obj).click(function() {
               $.ajax({
                type: "POST",
                url: "/link/remove_tag/"+$("#link_num").html(),
                data: {tag_name: $(obj).html(), authenticity_token: $("#auth_token").val()},
                success: function(data, textStatus, jqXHR) {
                    //console.log(data);
                    $(obj).remove();
                },
                error: function(jqXHR, textStatus, errorThrown) {
                    console.log("Error=" + errorThrown);
                    alert("There was an error");
                }
              });
            });
        });
        
        $("#add_tags_button").click(function() {
            addTag($("#tag_add_input").val());
        });
        
        $("#tag_add_input").blur(function(){
            // give click time to register
            setTimeout(function() {$("#tag_suggestions").css("display","none");}, 100);
        })
        
        $("#tag_add_input").keyup(function(e){
            if(!e.metaKey && !e.ctrlKey){
                if(suggestionTimeout != null)
                    clearInterval(suggestionTimeout);
                suggestionTimeout = setTimeout(function(){
                    getSuggestions();
                },300);
            }
        });
        
    }
    
});

function addTag(tags){
    $.ajax({
        type: "POST",
        url: "/link/add_tag/"+$("#link_num").html(),
        data: {tags: tags, authenticity_token: $("#auth_token").val()},
        success: function(data, textStatus, jqXHR) {
            for(var i in data.data){
                $("#current_tags").append('<span class="current_tag" title="remove tag">'+data.data[i].name+'</span>');
            }
            $("#tag_add_input").val("");
        },
        error: function(jqXHR, textStatus, errorThrown) {
            console.log("Error=" + errorThrown);
            //alert("There was an error");
        }
    });
}

function getSuggestions(){
    $.ajax({
        type: "POST",
        url: "/link/tag_suggestions/",
        data: {partial_name: $("#tag_add_input").val().substring($("#tag_add_input").val().indexOf(",") == -1 ? 0 : $("#tag_add_input").val().lastIndexOf(",")+1,$("#tag_add_input").val().length), authenticity_token: $("#auth_token").val()},
        success: function(data, textStatus, jqXHR) {
            $(".suggestions").remove();
            $(".suggestions").off();
            for(var i in data.data){
                $("#tag_suggestions").append("<span class='suggestions'>"+data.data[i].name+"</span>")
            }
            
            $(".suggestions").mousedown(function(){
                if($("#link_tags").html() != null)
                    addTag($(this).html());
                else{
                    var curVal = $("#tag_add_input").val();
                    if(curVal.indexOf(",") == -1)
                        $("#tag_add_input").val($(this).html());
                    else
                        $("#tag_add_input").val($("#tag_add_input").val().substring(0,$("#tag_add_input").val().lastIndexOf(",")+1)+$(this).html());
                }
            });
            
            if(data.data.length > 0)
                $("#tag_suggestions").css({"display":"block","left":$("#tag_add_input").offset().left+"px","width":($("#tag_add_input").outerWidth(false)-2)+"px"});
        },
        error: function(jqXHR, textStatus, errorThrown) {
            console.log("Error=" + errorThrown);
            alert("There was an error");
        }
    });
}


var window_loaded = false;
var currentOpenTab = "";
var suggestionTimeout = null;
