//If you need this in javascript form, it's available at https://github.com/Ezandora/Choice-Override
import "relay/choice.ash";

void main(string page_text_encoded)
{
	string page_text = page_text_encoded.choiceOverrideDecodePageText();
	
	string [string] form_fields = form_fields(); //Delete this line if you don't need this.
	int choice_id = choiceOverrideDiscoverChoiceIDFromPageText(page_text); //Delete this line if you don't need this.
	
	//Modify page_text as you will here. replace_first(), etc.
	write(page_text);
}