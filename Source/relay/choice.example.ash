import "relay/choice.ash";
//Comment to allow file_to_map() to see this file:
//Choice	override

void main(string page_text_encoded)
{
	string page_text = page_text_encoded.choiceOverrideDecodePageText();
	string [string] form_fields = form_fields();
	//Modify page_text as you will here.
	write(page_text);
}