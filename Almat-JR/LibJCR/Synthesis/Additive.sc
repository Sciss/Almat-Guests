Additive {
	//var <x=10,>y,<>z; Getter, Setter, Both getter and setter
	//var const q=100; Immutable
	//classvar c; Class variable





	*new1 {|a,b|

		^super.new.initme(a,b); // when overriding new you must call the superclass.
		// Only Object.new actually creates the object.
	}

	// Use this design pattern to do initializations.
	initme {|a,b|

	}

	*myClassMethod {|a,b|

	}

	mySelector {|a,b|
		// implicitly receives a first argument of this

		if (a == b) {
			^true; // ^ is how to return a value from the function
		} {
			^false; // You can have multiple exit points.
		};
	}

	mySelector2 {|a,b|
		// You cannot return void in SuperCollider If no ^ is specified the method returns this.
	}

}

