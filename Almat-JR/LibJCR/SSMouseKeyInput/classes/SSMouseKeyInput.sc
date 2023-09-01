/***********************************************

Server-side keyboard and mouse input hooks into the language.
Allows keylistening and mouse listening OS-wide, even when SuperCollider is not the key application.

Jonathan Brodsky-Reus Apr 2015


**********************************************/



/*********************************************************************************************
Keyboard - A keylistener that responds OS-wide, even when SuperCollider is not the key application.
The key listener won't respond to key combinations.. eg. shift, cmd, alt, ctrl are ignored.
*********************************************************************************************/
Keyboard {
	// OSX keycodes and abbreviations
	classvar <keycodes;
	classvar singleton;
	var <callbacks, <callbacks_up, <callbacks_down, <callback_keylogger;
	var <keysynths, <oscresponder, <responderKey;
	var <>verbose, <>keylogger_enabled;
	var <server;
	var <key_lastpressed, <>debounce_time;


	*enable {|serv|
		Keyboard.getSingleton(serv).enable;
	}

	*disable {
		Keyboard.getSingleton().disable;
	}

	initme {|serv|
		Keyboard.initKeycodes;
		callbacks = ();
		callbacks_up = ();
		callbacks_down = ();
		callback_keylogger = nil;
		verbose = false;
		keylogger_enabled = true;
		debounce_time = 0.08;
		key_lastpressed = ();
		server = serv;
		responderKey = ("/sskeyinput" ++ rrand(1,32000)).asSymbol;
	}

	*getSingleton {|serv=nil|
		if(singleton.isNil) {
			serv = serv ? Server.default;
			singleton = super.new.initme(serv);
			CmdPeriod.add({
				Keyboard.disable;
			});
			singleton.enable();
		};
		^singleton;
	}

	*addKeyResponder {|keysymbol, cb_func|
		Keyboard.getSingleton().addKeyResponder(keysymbol,cb_func);
	}


	*doForKey {|keysymbol, state, function|
		Keyboard.getSingleton().doForKey(keysymbol, state, function);
	}

	*enableKeylogger {|keylog_func=nil|
		Keyboard.getSingleton().enableKeylogger(keylog_func);
	}

	*disableKeylogger {
		Keyboard.getSingleton().disableKeylogger;
	}

	*setVerbose {|val|
		Keyboard.getSingleton().verbose = val;
	}


	/******
	Enable Keylogging.
	keylog_func - The callback function which is called every time a key change is registered.

	*******/
	enableKeylogger {|keylog_func=nil|
		keylogger_enabled = true;
		if(keylog_func.notNil) {
			callback_keylogger = keylog_func;
		} {
			if(callback_keylogger.isNil) {
				callback_keylogger = {|state, symbol, index|
					Post << "KEYLOG //// " << "State: " << state << " Symbol: " << symbol << " Index: " << index << $\n;
				};
			};
		}
	}

	disableKeylogger {
		keylogger_enabled = false;
	}


	doForKey {|keysymbol, state, function|
		Keyboard.addKeyResponder(keysymbol, {|val, symb, indx|
			if (val == 1) {
				if(callbacks_down[symb].isNil) {
					if(verbose) {
						("No response for keydown " ++ indx ++ " // " ++ symb).postln;
					};
				} {
					callbacks_down[symb].value(val, symb, indx);
				};
			} {
				if(callbacks_up[symb].isNil) {
					if(verbose) {
						("No response for keyup " ++ indx ++ " // " ++ symb).postln;
					};
				} {
					callbacks_up[symb].value(val, symb, indx);
				};
			};
		});

		if(state == 'UP') {
			callbacks_up.put(keysymbol, function);
		};

		if(state == 'DOWN') {
			callbacks_down.put(keysymbol, function);
		};

	}


	/* keysymbol - a valid symbol representing a key in keycodes
	cb_func - a callback to perform when the given key is pressed/released, cb_func expects 1 argument, the key up/down value
	EX:
	{|val| if (val == 1) {"Key is down".postln;} {"Key is up".postln;}; }
	*/
	addKeyResponder {|keysymbol, cb_func|

		("Add responder for "++keysymbol).postln;
		if (keycodes.findKeyForValue(keysymbol).isNil) {
			Error("Key symbol"+keysymbol+" not valid").throw;
		};

		("Found key for value: "+keycodes.findKeyForValue(keysymbol)).postln;
		callbacks.isNil && {callbacks = ()};
		callbacks.put(keysymbol,cb_func);

		"CALLBACKS".postln;
		callbacks.postln;
	}

	// initialize synth and osc responder
	enable {
		if(this.isEnabled) {
			"Keyboard is already enabled".postln;
		} {
			// SC 3.5 has the Changed UGEN, here we use HPZ2 to detect keystate changes
			// NTS:: Look into how HPZ2 is working on the scope/plotter - I think it's causing double signals.
			Server.default.waitForBoot {
				keysynths = keycodes.collect{|key, code|
					{
						var t_state = KeyState.kr(code,-1,1,lag:0);
						var hpz2 = HPZ2.kr(t_state);
						var t_tr = hpz2 > 0;
						SendReply.kr(t_tr, responderKey, [code, t_state]);
						0;
					}.play;
				};

				// OSCFunc available only in SC 3.5
				//oscresponder = OSCFunc({|msg| (" "+ msg + "  " + ~keycodes[msg[2]]).postln; d[l[msg[2]]].value(msg[3].asInteger)}, \tr);

				// Here's the 3.4.4 compatible version
				oscresponder = OSCresponder(nil, responderKey, {|t, r, msg|
					var keysymbol, now, lastpressed, indx = msg[3].asInteger, state = msg[4].asInteger;
					keysymbol = keycodes[indx];
					now = Process.elapsedTime;
					lastpressed = key_lastpressed[keysymbol] ? (now - debounce_time - 1);
					if((now - lastpressed) > debounce_time) {
						if(keylogger_enabled) {
							callback_keylogger.value(state, keysymbol, indx);
						};
						if(callbacks[keysymbol].isNil) {
							if(verbose) {
								("No response for key " ++ indx ++ " // " ++ keycodes[indx]).postln;
							};
						} {
							callbacks[keysymbol].value(state, keysymbol, indx);
						};
					};
					key_lastpressed[keysymbol] = now;
				}).add;

				"Keyboard enabled".postln;
			};
		};
	}

	isEnabled { ^(keysynths.notNil && oscresponder.notNil); }

	// free all resources
	disable {
		keysynths.do {|synth|
			synth.free;
		};
		oscresponder.remove;
		keysynths = oscresponder = nil;
		"Keyboard disabled".postln;
	}

	*listKeycodes {
		Keyboard.initKeycodes;
		^keycodes;
	}

	*getKeycode {|keysymbol|
		var val;
		Keyboard.initKeycodes;
		val = keycodes.findKeyForValue(keysymbol);
		if (val.isNil) {
			Error("Key symbol"+keysymbol+" not valid").throw;
		};
		^val;
	}

	// http://macbiblioblog.blogspot.nl/2014/12/key-codes-for-function-and-special-keys.html
	*initKeycodes {
		keycodes ?? {
			keycodes = (
				10:'sectionsign',
				18:'1',
				19:'2',
				20:'3',
				21:'4',
				23:'5',
				22:'6',
				26:'7',
				28:'8',
				25:'9',
				29:'0',
				27:'minus',
				24:'equal',
				51:'backspace',
				48:'tab',
				12:'q',
				13:'w',
				14:'e',
				15:'r',
				17:'t',
				16:'y',
				32:'u',
				34:'i',
				31:'o',
				35:'p',
				0:'a',
				1:'s',
				2:'d',
				3:'f',
				5:'g',
				4:'h',
				38:'j',
				40:'k',
				37:'l',
				6:'z',
				7:'x',
				8:'c',
				9:'v',
				11:'b',
				45:'n',
				46:'m',
				33:'leftbracket',
				30:'rightbracket',
				36:'return',
				53:'escape',
				76:'keypad_enter',
				51:'delete',
				41:'semicolon',
				39:'apost',
				42:'bkslsh',
				50:'tilde',
				43:'comma',
				47:'period',
				44:'fwdslsh',
				49:'space',
				123:'left',
				126:'up',
				125:'down',
				124:'right',
				63:'fn',
				122:'f1',
				120:'f2',
				99:'f3',
				118:'f4',
				96:'f5',
				97:'f6',
				98:'f7',
				100:'f8',
				101:'f9',
				109:'f10',
				103:'f11',
				111:'f12',
				105:'f13',
				55:'command',
				56:'shift',
				57:'capslock',
				58:'option',
				59:'control',
				60:'rightshift',
				61:'rightoption',
				62:'rightcontrol'

			);
		};
		^keycodes;
	}

}


/*********************************************************************************************
SSMouseInput - A mouse input listener that responds OS-wide, even when SuperCollider is not the key application.
*********************************************************************************************/
SSMouseInput {
	classvar singleton;
	var callbacks,listenersynth,oscresponder,responderKey;


	*enable {
		SSMouseInput.getSingleton().enable;
	}

	*disable {
		SSMouseInput.getSingleton().disable;
	}

	initme {|server|
		this.initCallbacks;
		responderKey = ("/ssmouseinput" ++ rrand(1,32000)).asSymbol;
	}

	*getSingleton {
		if(singleton.isNil) {
			singleton = super.new.initme(Server.default);
			CmdPeriod.add({
				SSMouseInput.disable;
			});
		};
		^singleton;
	}

	*addMouseResponder {|mouseaction, cb_func|
		SSMouseInput.getSingleton().addMouseResponder(mouseaction,cb_func);
	}

	/* mouseaction - a valid symbol representing a mouse function (movex, movey, button)
	cb_func - a callback to perform when the given mouseaction happens.
	cb_func for movex/movey has 1 argument, the mouse position
	cb_func for button has 1 argument, the button up/down value
	EX:
	{|val| if (val == 1) {"Mouse is down".postln;} {"Mouse is up".postln;}; }
	*/
	addMouseResponder {|mouseaction, cb_func|
		if (callbacks.includesKey(mouseaction).not) {
			Error("Mouse action"+mouseaction+" not valid").throw;
		};
		callbacks.put(mouseaction,cb_func);
	}

	// initialize synth and osc responder
	enable {
		if(this.isEnabled) {
			"Keyboard is already enabled".postln;
		} {
			// SC 3.5 has the Changed UGEN, here we use HPZ2 to detect keystate changes
			listenersynth = {
				var xsig = MouseX.kr(0,1,lag:0);
				var ysig = MouseY.kr(0,1,lag:0);
				var bsig = MouseButton.kr(-1,1,lag:0);
				var xhpz = HPZ2.kr(xsig) > 0;
				var yhpz = HPZ2.kr(ysig) > 0;
				var bhpz = HPZ2.kr(bsig) > 0;
				SendReply.kr(xhpz | yhpz | bhpz, responderKey, [xhpz,yhpz,bhpz,xsig,ysig,bsig]);
			}.play;



			// OSCFunc available only in SC 3.5
			// Here's the 3.4.4 compatible version
			oscresponder = OSCresponder(nil, responderKey, {|t, r, msg|
				var movex=msg[3],movey=msg[4],button=msg[5];
				var xpos=msg[6],ypos=msg[7],bstate=msg[8];

				if (movex.asBoolean) {
					callbacks['movex'].value(xpos);
				};
				if (movey.asBoolean) {
					callbacks['movey'].value(ypos);
				};
				if (button.asBoolean) {
					callbacks['button'].value(bstate);
				};

			}).add;

			"SSMouseInput enabled".postln;
		};
	}

	isEnabled { ^(listenersynth.notNil && oscresponder.notNil); }

	// free all resources
	disable {
		listenersynth.free;
		oscresponder.remove;
		listenersynth = oscresponder = nil;
		"SSMouseInput disabled".postln;
	}

	initCallbacks {
		callbacks ?? {
			callbacks = (
				'movex':{|xpos| ("MOUSEX: "++xpos).postln},
				'movey':{|ypos| ("MOUSEY: "++ypos).postln},
				'button':{|bstate| ("MOUSEB: "++bstate).postln}
			);
		};
	}

}


