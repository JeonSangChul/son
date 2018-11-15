$(".note-edit-btn").click(function(){if(c)return!1;var
b=$(this).data("id");a&&d();a=b;$("#content-function-cog-"+b).find(".dropdown
.fa").addClass("fa-spin");c=!0;$.ajax({url:contextPath+"/content/edit/"+b+".json?_="+
(new
Date).getTime(),dataType:"json",type:"get",success:function(a){$("#note-text-"+b).hide();$("#content-function-cog-"+b).find(".buttons").show().end().find(".dropdown").hide().find(".fa").removeClass("fa-spin");$('
<textarea id="note-edit-'+b+'" name="text"></textarea>
').val(a.text).insertAfter("#note-text-"+b).summernote({lang:"ko-KR",focus:!0,oninit:function(){400<$(window).height()&&$(".note-editable").css("max-height",$(window).height()-100)}})},complete:function(){c=!1}})});
$(".note-update-form").submit(function(){if(c)return!1;
var
b=$(this).data("id"),d=$(this);d.find('textarea[name="text"]').val($("#note-edit-"+b).code());c=!0;$.ajax({url:d.attr("action")+".json",dataType:"json",type:d.attr("method"),data:d.serialize(),success:function(d){$("#note-text-"+b).html(d.text).find("code").each(function(b,a){Prism.highlightElement(a)});e(b);a=null},complete:function(){c=!1}});return!1});$(".note-delete-btn").click(function(){if(c)return!1;if(confirm("\uc815\ub9d0\ub85c
\uc0ad\uc81c \ud558\uc2dc\uaca0\uc2b5\ub2c8\uae4c?")){var b=
$(this).data("id"),a=$("#note-delete-form-"+b);c=!0;$.ajax({url:a.attr("action")+".json",dataType:"json",type:a.attr("method"),data:a.serialize(),success:function(a){$("#note-"+b).detach();$("#note-count").text(function(b,a){return
parseInt(a,10)-1})},complete:function(){c=!1}})}})}); $(function(){var
a=!1;$(".note-vote-btn").click(function(d){var
b=$(this).data();if("unvote"==b.type&&!confirm("\ucde8\uc18c\ud558\uc2dc\uaca0\uc2b5\ub2c8\uae4c?"))return!1;if("disabled"!=b.type&&!a){d=$("#note-"+b.type+"-form");var
k=d.serialize(),g=$.param({contentId:b.id});a=!0;$.ajax({url:d.attr("action")+".json",dataType:"json",type:d.attr("method"),data:k+"&"+g,success:function(d){$("#content-vote-count-"+b.id).html(d.voteCount);b.eval?c($.extend({},b)):e($.extend({},b));a=!1}})}return!1});
var c=function(a){$(["assent","dissent"]).each(function(b,c){var
e=$("#note-evaluate-"+c+"-"+a.id),p="note-evaluate-"+c+"-"+c,l="note-evaluate-"+c+"-unvote";"unvote"==a.type?l="note-evaluate-"+c+"-unvote
note-evaluate-"+c+"-disabled":a.type!=c&&(p="note-evaluate-"+c+"-disabled",l="note-evaluate-"+c+"-"+c);e.removeClass(a.type==c?p:l).addClass(a.type==c?l:p).attr("data-original-title",function(b,e){if(a.type==c)return
e+" \ucde8\uc18c";if(e)return e.replace("
\ucde8\uc18c","")});a.type==c?(e.parent("a").data("type",
"unvote"),e.tooltip("show")):("unvote"==a.type?e.parent("a").data("type",c):e.parent("a").data("type","disabled"),e.tooltip("hide"))})},e=function(a){var
b=$("#note-vote-"+a.id),c="vote"==a.type?"unvote":"vote";b.removeClass("note-"+a.type).addClass("note-"+c).attr("data-original-title",function(b,c){return"vote"==a.type?c+"
\ucde8\uc18c":c.replace("
\ucde8\uc18c","")}).tooltip("show");b.parent("a").data("type",c)}});
$(function(){var a=!1,c=function(a){var
c=$("#article-scrap-btn").find("i"),b="scrap"==a.type?"unscrap":"scrap";"scrap"==a.type?c.addClass("note-scrapped"):c.removeClass("note-scrapped");c.attr("data-original-title",function(b,c){return"vote"==a.type?c+"
\ucde8\uc18c":c.replace(" \ucde8\uc18c","")}).
