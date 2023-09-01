//

JGui : Object {
  var width, height,
	window,
	sliders;

  *new{|w=600,h=400,label="MyGui"|
	^super.new.init(w,h,label);
  }

  init{|w,h,label|
	// Do initialization work here
	if(window != nil, { window.close; });
	width = w;
	height = h;
	sliders = ();
	window = Window.new(label, Rect(100,100,w,h));
  }

	window{ ^window; }

  front{
	window.front;
  }

  close{
	window.close;
  }

  // More nice functions..
  addSlider{|width, height, label, displayvalue=false|
	var xpos,ypos,newslider;
	#xpos,ypos = this.getNextSliderPos(width,height);
	sliders[sliders.size] = newslider = JSlider.new(window, xpos, ypos, width, height);
	^newslider;
  }

  getNextSliderPos{|w,h|
	var x=10,y=0,i=0;
	while({i < sliders.size},{
		y = y + sliders[i].height;
		i=i+1;
	});
	y = y + 10;
	^[x,y]
  }

  slider{|index|
	^sliders[index];
  }
}


JSlider : Object {
	var xpos, ypos,
	width, height,
	showvalue,
	parentwindow,
	sliderview,
	callback,
	buttons,
	labelview,
	valueview;

	*new{|win,x,y,w,h|
		^super.new.init(win,x,y,w,h);
	}

	init{|win,x,y,w,h|
		parentwindow = win;
		buttons=();
		xpos=x; ypos = y; width = w; height = h;
		sliderview = Slider(win, Rect(x,y,w,h));
	}

	height{ ^height; }

	callback_{|newfunc|
		postln("Set callback");
		sliderview.action = newfunc;
	}

	addButton{|w,h,toggle=false|
		var xpos,ypos,newbutton;
		#xpos,ypos = this.getNextButtonPos(w,h);
		buttons[buttons.size] = newbutton = JButton.new(parentwindow, xpos, ypos,w,h,toggle);
		^newbutton;
	}

	getNextButtonPos{|w,h|
		var x=0,y=0,i=0;
		x = xpos + width + 5;
		y = ypos;
		while({i < buttons.size},{
			x = x + buttons[i].width;
			i=i+1;
		});
		x = x + 5;
		^[x,y]
	}

	sliderview{^sliderview;}

	button{|index|
		^buttons[index];
	}

}

JButton : Object {
	var xpos, ypos,
	width, height,
	labelfield,
	parentwindow,
	buttonview,
	callback,
	toggle;

	*new{|win,x,y,w,h,toggle=false|
		^super.new.init(win,x,y,w,h,toggle);
	}

	init{|win,x,y,w,h,toggle|
		parentwindow = win;
		xpos=x; ypos = y; width = w; height = h;
		buttonview = Button(win, Rect(x,y,w,h));
		if(toggle,{
			buttonview.states = [
				["",Color.black,Color.grey],
				["",Color.black,Color.white]
			];
		});
	}

	height{ ^height; }
	width{^width;}

	buttonview{^buttonview;}

	callback_{|newfunc|
		callback = newfunc; // not actually used
		buttonview.action = newfunc;
	}
}
