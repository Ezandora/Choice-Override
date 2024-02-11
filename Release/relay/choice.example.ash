import "relay/choice.ash";

void main(string page_text_encoded)
{
	string page_text = page_text_encoded.choiceOverrideDecodePageText();
	
	//string [string] form_fields = form_fields();
	//int choice_id = choiceOverrideDiscoverChoiceIDFromPageText(page_text);
	
	//Modify page_text as you will here. replace_first(), etc.
	write(page_text);
}