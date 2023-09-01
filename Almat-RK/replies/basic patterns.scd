
/* Streams
 A Stream is an object that produces a sequence of values in response to 'next'.
The next method takes an argument, but it may be disregarded by the Stream.
For example, most Objects are 'trival' Streams, they respond to 'next' by returning themselves.
So, they define unending streams of themselves.

~stream = 3;
10.collect { | i | ~stream.next(i * 100) }
[ 3, 3, 3, 3, 3, 3, 3, 3, 3, 3 ]

Non-trivial streams can be defined with the class Routine which uses a function to specify the sequence of values of the Stream it implements.
The first 'next' message provides the Routine with the function's argument.
The function definition invokes the method 'yield' to return the first value in its stream.
The return value of that 'yield' is the parameter passed by the subsequent 'next' message.

In this example, the stream simply returns whatever parameter it receives from the next message:
r = Routine ({ | in |  loop { in = yield(in) } });
10.collect { | i | r.next(i * 100) }
[ 0, 100, 200, 300, 400, 500, 600, 700, 800, 900 ]

In this example the stream modifies and returns that parameter:

r = Routine ({ | in |  (1..10).do { | i | in = yield(i + in) } });
10.collect { | i | r.next(i * 100) }
[ 1, 102, 203, 304, 405, 506, 607, 708, 809, 910 ]

Streams may be arithmetically combined to create new Streams:
p = Routine({ (1..10).do{ | i | i.yield } });
q = Routine({ (1..10).reverse.do{ | i | (i * 10).yield } });
(p + q).nextN(11)

embedInStream is a method that allows one Stream to temporarily take control
from its enclosing Routine.  (In SC, embedInStream MUST be called from a Routine.)
p = Routine({ (1..3).do{ | i | i.yield } });
q = Routine({ (4..1).do{ | i | i.yield } });
r = Routine({ p.embedInStream; q.embedInStream }).nextN(8);
[ 1, 2, 3, 4, 3, 2, 1, nil ]

Regarded as streams, most Objects are endless streams of themselves, but they respond
to embedInStream as a singleton stream that  'yields' itself once. This makes it possible to
combine objects and streams in the definition of a more complex stream:

p = Routine({ (1..3).do{ | i | i.yield } });
q = Routine({ (4..1).do{ | i | i.yield } });
r = Routine({ [p, 100, 500, q, 3, 2, 1].do { | v | v.embedInStream } }).nextN(13);
[ 1, 2, 3, 100, 500, 4, 3, 2, 1, 3, 2, 1, nil ]

Of course, Streams represent a single sequence of values. So a single Stream definition cannot be freely reused. For example, we cannot add a stream to itself:
	p = Routine({ (1..3).do{ | i | i.yield } });
	r = p + p;
	r.nextN(4);
	[ 3, nil, nil, nil ]
*/

/*
A Pattern specifies a Stream and produces instances of that Stream in response to
'asStream'. But they also respond to 'embedInStream' by creating a new stream.
This provides the additional layer of abstraction required to allow reuse.

For example:
p = Pseq((1..3));  // a pattern that specifies a stream of 10 elements
p.asStream.nextN(4)
[ 1, 2, 3,  nil ]

The pattern p can be freely combined with itself to define a new pattern:

r = p + p;
r.asStream.nextN(4)
 [ 2, 4, 6, nil ]

Patterns can also be nested within the definitions of other patterns:

q = Pseq([p,p]);
q.asStream.nextN(7);
[ 1, 2, 3, 1, 2, 3, nil ]

The implementation of this nesting is strongly connected to Routines.
Pattern Classes typically define the runtime implementation of their streams in the method embedInStream. This method is written assuming it will be called from within a Routine.

Consequently, the asStream method of a Pattern typically creates a Routine and then calls its own embedInStream method.

Most Objects respond to asStream with themselves.  (Those Objects cannot embed a Pattern,
so there is no need to create a Routine.)
So most Objects can be viewed as Patterns that specify endless Streams of themselves but embed
in Pattern definitions as singleton Streams of themselves.

There is an interesting slippage here.  A Stream returns itself in response to asStream.
So a Stream, is a "Pattern" that specifies a concrete sequence of values, rather than an
abstract sequence of values that can be replicated.

This can be useful. For example,  one may wish to play a single sequence of pitches through
an unpredictable (or interactive) selection from a collection of patterns.  So, the Stream
holds onto that state as it is invoked by lexically separate Patterns.

IMHO, this kind of interconnection between abstract and concrete representations is
not well thought through in SC.  It is possible that, in Scala, it can be understood as
an interconnection of immutable and mutable objects....


*/
// Here are the basic methods in SC Patterns and Streams,
// sometimes pulled in from base classes

+Object {
	next { ^this }
	reset { ^this }
	asStream { ^this }
	embedInStream { ^this.yield; }
}

+Routine {
	asStream { ^this }
	embedInStream { arg inval;
		var outval;
		while {
			outval = this.value(inval);
			outval.notNil
		}{
			inval = outval.yield;
		};
		^inval
	}
	next { arg inval;
		_RoutineResume
		^this.primitiveFailed
	}

}

Pseq  {
	var <>list, <>repeats=1;
	*new { arg list, repeats=1;
		^super.new.list_(list).repeats_(repeats)
	}
	embedInStream { | inval |
		var item;
		repeats.do({ arg j;
			list.size.do({ arg i;
				item = list.wrapAt(i);
				inval = item.embedInStream(inval);
			});
		});
		^inval;
	}
	asStream { ^Routine({ arg inval; this.embedInStream(inval) }) }
}

/*


*/