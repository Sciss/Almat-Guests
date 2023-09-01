
/*
Best not to put classes in the SuperCollider bundle (eg. in folder SCClassLibrary) unless making a standalone.
For general use it's better to put classes here:
Platform.userExtensionDir;
Platform.systemExtensionDir;
*/

/*
NTS:
Make a little launch script for SuperCollider that changes the symlink for the extensions directory depending on the SC version I am using.
*/


// Extension of Object is implicit, I just put it here to show syntax inheritance.
MyClassTemplateName : Object {
	var <x=10,>y,<>z; //Getter, Setter, Both getter and setter
	const q=100; //Immutable
	classvar c; //Class variable



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

	printOn {|stream|
		stream << "MyClassTemplate with some values " << x << ", " << q;

	}

}



// You can add methods to classes in separate files (similar to protocols in Obj0C
+ MyClassTemplateName {
	myNewSelector {|a,b|

	}

	*myNewClassMethod {

	}
}


