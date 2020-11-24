function main(page_text_encoded)
{
	//Standard inputs:
	var choice_override_script = require("relay/choice.ash");
	var page_text = choice_override_script.choiceOverrideDecodePageText(page_text_encoded);
	
	var form_fields = Lib.formFields(); //Delete this line if you don't need this.
	var choice_id = choice_override_script.choiceOverrideDiscoverChoiceIDFromPageText(page_text); //Delete this line if you don't need this.
	
	//Modify page_text as you will here.
	Lib.write(page_text);
}
