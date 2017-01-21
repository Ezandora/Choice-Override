Choice-Override
=====
Choice Override library for KoLmafia. Allows the use of multiple choice.id.ash relay override scripts, all co-existing.

Installation
----------------
You won't usually have to do this, unless you are developing a script for this library.
<pre>
svn checkout https://github.com/Ezandora/Choice-Override/branches/Release/
</pre>

The dependencies.txt entry for svn:
<pre>
https://github.com/Ezandora/Choice-Override/branches/Release/
</pre>


Usage
----------------
Copy choice.example.ash in relay/, and name it choice.choice_adventure_id.ash. [Choice adventures by number.](http://kol.coldfront.net/thekolwiki/index.php/Choice_Adventures_by_Number_(1-99))
Then edit the script:
<pre>
import "relay/choice.ash";
//Comment to allow file_to_map() to see this file:
//Choice	override

void main(string page_text_encoded)
{
	string page_text = page_text_encoded.decodePageText();
	//Modify page_text as you will here.
	write(page_text);
}
</pre>