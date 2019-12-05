(
var x = 5
x
)

let x = 5 in
    x

type process = Process of float * process Lazy.t

let next = function Process (_, cont) -> Lazy.force cont

let this = function Process (this, _) -> this

let rec const flt = Process (flt, lazy (const flt))

let rec apply func proc1 proc2 =
  Process
    ( func (this proc1) (this proc2)
    , lazy (apply func (next proc1) (next proc2)) )

let rec map func proc = Process (func (this proc), lazy (map func (next proc)))

let rec sinosc ph incr =
  Process (sin (this ph), lazy (sinosc (apply ( +. ) ph incr) (next incr)))

let rec myosc func ph incr =
  Process (func (this ph), lazy (myosc func (apply ( +. ) ph incr) (next incr)))

let rec inc x = Process (this x, lazy (inc (apply ( +. ) (const 1.0) (next x))))

let rec collect proc = function
  | 0 ->
      []
  | n ->
      this proc :: collect (next proc) (n - 1)

(* Tests *)

;;
collect (sinosc (const 0.0) (const 0.1)) 100

;;
collect (inc (const 0.0)) 100

;;
collect (inc (inc (const 0.0))) 100

;;
collect (myosc sin (const 0.0) (const 0.1)) 10


  fun asdasd asdsad
  proc 
