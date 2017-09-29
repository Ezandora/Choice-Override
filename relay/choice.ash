//Choice Override
//Version 1.0.3.
//Written by Ezandora.
//Allows for generic choice adventure overrides. Will load scripts named choice.choice_adventure_id.ash.
//Tested to at least 17705; probably works before then?
//This script is in the public domain.

//To develop your own relay override, copy choice.example.ash and name it choice.id.ash. So, a friar script would be choice.720.ash
//Also supports choice.0.ash, which it will call if there aren't any other choice overrides for that adventure.
//dependencies.txt entry: https://github.com/Ezandora/Choice-Override/branches/Release/

//Design notes:
//At the moment, we use file_to_map against ASH scripts directly. This works, if they contain a tab character.
//However, that feels slightly unstable, and might break in the future.
//For convenience, we'll continue using it. But in the future, we may require the presence of a tabbed file named choice.choiceid.txt.


//We need to pass in page text through a cli_execute("call script arguments"); command.
//For now, we use url_encode() and url_decode().
//We can't use visit_url() in the target script, because that will send the choice POST twice, leading to bad things.
string choiceOverrideDecodePageText(string page_text_encoded)
{
	return url_decode(page_text_encoded);
}

string choiceOverrideEncodePageText(buffer page_text_encoded)
{
	return url_encode(page_text_encoded);
}




int choiceOverrideDiscoverChoiceIDFromPageText(buffer page_text)
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
		string [string] map;
		file_to_map(script_name, map); //in the future, we may change this to test against .txt
		if (map.count() > 0)
			return true;
	}
	finally
	{
	}
	return false;
}

static
{
	//We test against choice zero exactly once per session, because that would be an extra filesystem call otherwise.
	boolean __tested_against_choice_zero = false;
	boolean __choice_zero_script_exists = false;
	void choiceOverrideTestAgainstChoiceZero()
	{
		if (__tested_against_choice_zero) return;
		__tested_against_choice_zero = true;
		__choice_zero_script_exists = choiceOverrideScriptProbablyExists("relay/choice.0.ash");
	}
	choiceOverrideTestAgainstChoiceZero();
}

void main()
{
	buffer page_text = visit_url(); //Will POST automatically and such.
	int choice_id = choiceOverrideDiscoverChoiceIDFromPageText(page_text);
	
	string script_name = "relay/choice." + choice_id + ".ash";
	
	if (choiceOverrideScriptProbablyExists(script_name))
	{
		//Let them handle it:
		cli_execute("call " + script_name + " " + page_text.choiceOverrideEncodePageText());
	}
	else if (__choice_zero_script_exists) //catch-all
		cli_execute("call relay/choice.0.ash " + page_text.choiceOverrideEncodePageText());
	else
		write(page_text);
}