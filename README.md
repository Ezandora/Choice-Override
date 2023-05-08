Choice Override
=====
Choice Override library for KoLmafia. Allows the use of multiple choice.id.ash/choice.id.js relay override scripts, all co-existing.

Installation
----------------
You won't usually have to do this, unless you are developing a script for this library.
<pre>
git checkout Ezandora/Choice-Override Release
</pre>

Writing a new override script
----------------
Copy choice.example.ash in relay/, and name it choice.choice_adventure_id.ash. [Choice adventures by number.](http://kol.coldfront.net/thekolwiki/index.php/Choice_Adventures_by_Number_(1-99))
Or download choice.example.js from above.

Then edit the script:
<pre>
import "relay/choice.ash";

void main(string page_text_encoded)
{
	string page_text = page_text_encoded.choiceOverrideDecodePageText();
	
	string [string] form_fields = form_fields(); //Delete this line if you don't need this.
	int choice_id = choiceOverrideDiscoverChoiceIDFromPageText(page_text); //Delete this line if you don't need this.
	
	//Modify page_text as you will here. replace_first(), etc.
	write(page_text);
}
</pre>

Or, in javascript:
<pre>
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

</pre>


When releasing your script, you'll need to add the library to a file named "dependencies.txt", located in the root folder of your svn or git directory. It will need this line:
<pre>
github Ezandora/Choice-Override Release
</pre>

Choice Zero
----------------
An optional "choice.0.ash" or "choice.0.js" script will operate as a general catch-all, for choices that aren't otherwise handled by other scripts.

If your choice.0 script wants to know the choice adventure ID, use this code:
<pre>
int choice_id = page_text.choiceOverrideDiscoverChoiceIDFromPageText();
</pre>

Or, in JavaScript:
<pre>
var choice_id = choice_override_script.choiceOverrideDiscoverChoiceIDFromPageText(page_text)
</pre>
