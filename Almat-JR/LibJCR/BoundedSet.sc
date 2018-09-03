

BoundedRealSet {
	var <>leftBoundClosed, <>rightBoundClosed;
	var <>leftBound, <>rightBound;

	*new {|left,right,isClosedInterval=true|
		^super.new.init(left,right,isClosedInterval);
	}

	init {|left,right,isClosedInterval=true|
		leftBoundClosed = rightBoundClosed = isClosedInterval;
		leftBound=left; rightBound=right;
	}

	*makeCantor {|numSteps=1,myset|
		if (numSteps == 1) {
			var leftSet, rightSet,third;
			third=(myset.rightBound - myset.leftBound) / 3;
			leftSet = BoundedRealSet.new(myset.leftBound,myset.leftBound+third);
			rightSet = BoundedRealSet.new(myset.rightBound-third,myset.rightBound);
			^[leftSet,rightSet];
		} {
			var tmp;
			tmp = BoundedRealSet.makeCantor(numSteps-1,myset);
			^(BoundedRealSet.makeCantor(numSteps-1,tmp[0])
				++ BoundedRealSet.makeCantor(numSteps-1,tmp[1]));
		}

	}


	printOn {|stream|
		var lchar, rchar;
		lchar = leftBoundClosed.if({"["},{"("});
		rchar = rightBoundClosed.if({"]"},{")"});
		stream << lchar << leftBound << "," << rightBound << rchar;
	}
}


/*
a = BoundedRealSet.makeCantor(4,BoundedRealSet.new(0,1));
a.size

c = BoundedRealSet.new(0,1);
c.hello;


BasedNumber.new(10,10);

*/



// Add some base functionality

BasedNumber {
	var <>base=10;
	var <>value;

	*new {|val,thebase=10|
		^super.new.init(val,thebase);
	}

	init {|val,thebase|
		value = val; base = thebase;
	}


	printOn {|stream|
		if (base == 10) {
			value.printOn(stream);
		} {
			var str = String.newClear;
			var tmp = value.asInteger;
			({tmp >= base}).while {
				str = (tmp.asInteger % base).asString ++ str;
				tmp = (tmp.asInteger / base).asInteger;
			};
			str= tmp.asString ++ str;
			str.printOn(stream);
			// Make the nice base output
		}
	}

	*getRandomCantorValue {
		^((1.0.rand) * (10**14));
	}

}



+ Number {
	asBase {|newbase=10|
		^(BasedNumber.new(this,newbase));
	}
}


/*
~basednum = BasedNumber.new(3,10)
~basednum.base = 3
~basednum.value = rand(600).asInteger;
~basednum.base = 8;
5.asBase(3);
*/

