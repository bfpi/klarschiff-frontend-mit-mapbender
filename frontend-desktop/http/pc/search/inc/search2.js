var results;
var searchField;
var search_url = 'http://demo.klarschiff-hro.de/pc/search/server.php';


$(document).ready(function() {
    results = $("div.results");
	searchField = $("input#searchtext");
    
    var placeholderSearch = "Stadtteil/Straße/Adresse eingeben…";
    searchField.attr("placeholder",placeholderSearch);
    $.Placeholder.init();
	
	searchField.keyup(function() {
		if($(this).val().length >= 3) {
			var searchText = searchField.val();
			
			$.ajax({
				url: search_url,
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
