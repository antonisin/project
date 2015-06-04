$(document).ready(function(){
    //binds
    $('.btn_svo').click(function(){
    	$(this).parents('.offer').find('.large, .subtitle, .nomar').toggle('blind',400)
    });
   	$('.checkBox').bind('click', function(){
   		$(this).hide(100, function(){ $(this).next().show(400)});
   	});
   	$('.checkImg').bind('click', function(){
   		$(this).hide(400, function(){ $(this).prev().prop('checked', false).show(100) });
   	});

	var selectOffer;
	var id = window.location.search.replace('?', '') - 1;
 // debugger
	var urlId = id + 1;
	selectOffer = $('#'+id);
    $('.large, .subtitle, .nomar, .checkImg').hide();
	$('#selectNr').append(id +1 +' ('+selectOffer.find("#offerLabel").html()+')'+'.');
	$("#selectOffer").append(selectOffer).find('.checkBox, .checkImg').unbind('click').next().show().prev().hide();
    
  });
