//Choice Override
//Version 1.1.1.
//Written by Ezandora.
//Allows for generic choice adventure overrides. Will load scripts named choice.choice_adventure_id.ash or choice.choice_adventure_id.js.
//This script is in the public domain.

//Also supports choice.0.ash, which it will call if there aren't any other choice overrides for that adventure.
//dependencies.txt entry: https://github.com/Ezandora/Choice-Override.git


//We need to pass in page text through a cli_execute("call script arguments"); command.
//We use url_encode() and url_decode() for this purpose.
//We can't use visit_url() in the target script, because that will send the choice POST twice, leading to bad things.
string choiceOverrideDecodePageText(string page_text_encoded)
{
	return url_decode(page_text_encoded);
}

string choiceOverrideEncodePageText(buffer page_text_encoded)
{
	return url_encode(page_text_encoded);
}

int choiceOverrideDiscoverChoiceIDFromPageText(string page_text)
{
	//Same as mafia's:
	string [int] extraction_patterns;
	extraction_patterns[extraction_patterns.count()] = "name=['\"]?whichchoice['\"]? value=['\"]?(\\d+)['\"]?";
	extraction_patterns[extraction_patterns.count()] = "value=['\"]?(\\d+)['\"]? name=['\"]?whichchoice['\"]?";
	extraction_patterns[extraction_patterns.count()] = "choice.php\\?whichchoice=(\\d+)";
	foreach key, s in extraction_patterns
	{
		string [int, int] matches = page_text.group_string(s);
		if (matches.count() == 0)
			continue;
		string value = matches[0][1];
		if (!is_integer(value))
			continue;
		return value.to_int();
	}
	//Try extracting a choice.php: (witchess)
	
	string [int][int] generic_matches = page_text.group_string("\"choice.php\\?([^\" ]*)\"");
	if (generic_matches.count() > 0)
	{
		string first_level = generic_matches[0][1];
		string [int][int] second_level_matches = first_level.group_string("whichchoice=([0-9]*)");
		if (second_level_matches.count() > 0)
		{
			string value = second_level_matches[0][1];
			if (is_integer(value))
				return value.to_int();
		}
	}
	
	if (page_text.contains_text("<b>Hippy Talkin'</b>"))
		return 798;
	return -1;
}



boolean choiceOverrideScriptProbablyExists(string script_name)
{
	try
	{
		//Try to determine if that choice override exists:
		//We could cache this, but I think mafia does that already.
		buffer file_contents = file_to_buffer(script_name);
		if (file_contents.length() != 0)
			return true;
	}
	finally
	{
	}
	return false;
}

//use:
//string script_name = choiceOverrideGetFullScriptName("choice.0");
//no extension, that is found
string choiceOverrideGetFullScriptName(string base_script_file_name)
{
	string path_name_without_extension = "relay/" + base_script_file_name;
	
	
	foreach extension in $strings[.ash,.js]
	{
		string full_path = path_name_without_extension + extension;
		if (choiceOverrideScriptProbablyExists(full_path))
			return full_path;
	}
	return "";
	
}

static
{
	//We test against choice zero exactly once per session, because that would be an extra filesystem call otherwise.
	boolean __tested_against_choice_zero = false;
	string __choice_zero_script_name = "";
	
}

void choiceOverrideTestAgainstChoiceZero()
{
	if (__tested_against_choice_zero) return;
	__tested_against_choice_zero = true;
	__choice_zero_script_name = choiceOverrideGetFullScriptName("choice.0");
}

choiceOverrideTestAgainstChoiceZero();

void main()
{
	buffer page_text = visit_url(); //Will POST automatically and such.
	int choice_id = choiceOverrideDiscoverChoiceIDFromPageText(page_text);
	
	string script_name = choiceOverrideGetFullScriptName("choice." + choice_id);
	
	if (script_name != "")
	{
		//Let them handle it:
		cli_execute("call " + script_name + " " + page_text.choiceOverrideEncodePageText());
	}
	else if (__choice_zero_script_name != "") //catch-all
	{
		if (!choiceOverrideScriptProbablyExists(__choice_zero_script_name)) //It did exist, now it doesn't.
		{
			//Rescan:
			__tested_against_choice_zero = false;
			choiceOverrideTestAgainstChoiceZero();
		}
		if (__choice_zero_script_name != "")
			cli_execute("call " + __choice_zero_script_name + " " + page_text.choiceOverrideEncodePageText());
	}
	else
		write(page_text);
}