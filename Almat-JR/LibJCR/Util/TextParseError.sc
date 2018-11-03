/* Comment out this class definition */
ParseError {
	parse {arg str;
		var regexp;
		regexp = "\"";
		str.findRegexp(regexp);
	}
}


/* Run these two lines after commenting out the class definition above and recompiling the class library.
r = "[\"]";
"\"Find Me".findRegexp(r);
*/

