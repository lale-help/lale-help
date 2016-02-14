ready = ->
	$('.user-icon').hover(
		( (event) -> 
			$(this).find('.preview').show()
			$(this).find('.preview').position({
		    	my: "left",
		    	at: "center",
		    	of: event,
		    	collision: "flipfit"
		  	})
		)
		(-> 
			$(this).find('.preview').hide()
			$(this).find('.preview').removeAttr("style")
		)
	)

$(document).on 'ready', ready
$(document).on 'page:load', ready