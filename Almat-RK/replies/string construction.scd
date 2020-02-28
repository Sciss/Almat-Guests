// levenshtein distance
~ld = { | s,t|
	var m,n, d, cost;
	m = s.size;
	n = t.size;
	d = m.collect {| i |  0.dup(n).addFirst(i + 1) };
	d = d.addFirst( (0..n) );
	n.do { | j |
		j = j + 1;
		m.do { | i |
			i = i + 1;
			if (s[i-1] == t[j-1]) {
				cost = 0
			} {
				cost = 1;
			};
			d[i][j] = (d[i-1][j] + 1) 				// deletion
			min: (d[i][j-1] + 1) 					// insertion
			min: (d[i-1][j-1] + cost);				// substitution

		}
	};
	d;
};

~study = { |s, t| var sa, ta, d;
	d= ~ld.(s, t);
	d = d.collect({| l, i | l.addFirst((" " ++ s)[i]) });
	d = d.addFirst(("  " ++ t).collectAs({|x| x}, Array));
	d
};


// take the matrix from the ld calculation and work out what chars from the source are in the target
// display this by making them caps in source and target
~parse = { | table, s, t |
	var choices;  // 0 substitute, 1 insert, 2 delete
	var held = [];
	var spos = table.size -1;
	var tpos = table[0].size - 1;
	while{ (spos >0) && (tpos >0) } {
		// hack in a preference for contiguous characters
		// so txtest -> test takes txTEST rather than TxtEST
		 if (s[spos -1] == t[tpos - 1]) {
			choices = 0
		} {
			choices = [table[spos -1][tpos-1], table[spos -1][tpos], table[spos][tpos-1]].minIndex;
		};
		case
		{choices ==0 } {
			if(table[spos -1][tpos-1] == table[spos][tpos]) { held = held.add([spos, tpos]) };
			spos = spos -1; tpos = tpos-1 }
		{choices == 1 } { spos = spos -1}
		{choices == 2 } { tpos = tpos-1 };
	};
	s = s.copy;
	t = t.copy;
	(held - 1).do { | p|
		s[p[0]] = s[p[0]].toUpper;
		t[p[1]] = t[p[1]].toUpper;
	};
	[s,t]
};

// do the whole thing
~replace = { |s,  t|
	~parse.(~ld.(s,t), s,t);
};

// a few tests, not methodical
// these match towards the end of the source string
~replace.("abtsttest", "test")
~replace.("abtesttst", "test")
~replace.("test", "abtsttest" )
~replace.("testab", "test")
~replace.("txtxtyyy", "txyyy")
~replace.("ttxtyyy", "txyyy")


// reversing the string matches towards the beginning
// might  be preferable for Steno
~rReplace = { |s,  t|
	s = s.reverse; t = t.reverse;
	~parse.(~ld.(s,t), s,t).collect(_.reverse)
};


~rReplace.("abtsttest", "test")
~rReplace.("abtesttst", "test")
~rReplace.("test", "abtsttest" )
~rReplace.("testab", "test")
~rReplace.("txtxtyyy", "txyyy")
~rReplace.("ttxtyyy", "txyyy")
