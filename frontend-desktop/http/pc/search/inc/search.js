var results;
var searchField;

$(document).ready(function() {
	results = $("div.results");
	searchField = $("input#searchtext");
	
	searchField.keyup(function() {
		if($(this).val().length >= 3) {
			var searchText = searchField.val();
			
			$.ajax({
				url: 'search/server.php',
				dataType: 'json',
				data: {
					searchtext : searchText
				},
				success: showResults
			});
		} else {
			results.children().remove();
			results.fadeOut();
		}
	})
	
	$(".resultElement").live("click",function() {
		results.fadeOut();
	});
	
});

function showResults(json) {
	results.children().remove();
	results.append(json.result);
	results.fadeIn();
}