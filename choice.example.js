const kol = require("kolmafia")

module.exports.main = function (page_text_encoded)
{
	//Standard inputs:
	var choice_override_script = require("relay/choice.ash");
	var page_text = choice_override_script.choiceOverrideDecodePageText(page_text_encoded);
	//Uncomment if you need these:
	//var form_fields = kol.formFields();
	//var choice_id = choice_override_script.choiceOverrideDiscoverChoiceIDFromPageText(page_text);
	
	
	
	
	//Modify page_text as you will here.
	kol.write(page_text);
}
