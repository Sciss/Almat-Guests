# wreck
luc.doebereiner@gmail.com, 2019

## Building

```dune build toplevel.exe```

### Build and test parser only

```dune build wreckparse.cma```
```dune utop _build/default/ -- -implicit-bindings```

## TODO
* processes as combination of processes (without update part)
* indentation in emacs mode
* functions as args
* delays, filters
* mapping, zipping, apply, parallel etc.
* inc sample counter for forks in paths
* audio input
* multichannel and expansion
* midi input
* startup arguments, standalone compilation, nojack, dylib compilation, debug mode

### Changes/Done
* comments
* fix let bindings removal
* function redefinition
* remove module on stopping to play
* clean fptr variables after process fun compilation