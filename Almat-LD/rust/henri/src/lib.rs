use std::io;

const DT: f64 = 1.0_f64 / (48_000_f64 * 2.0_f64);

pub struct PhaseSpace {
    pub flow: Vec<Box<Fn(&[f64], usize) -> f64>>,
    pub paths: Vec<Vec<f64>>,
    dim: usize,
    numpaths: usize,
}

impl PhaseSpace {
    pub fn new(d: usize) -> PhaseSpace {
        let mut i = 0;
        let mut f: Vec<Box<Fn(&[f64], usize) -> f64>> = vec![];
        while i < d {
            f.push(Box::new(move |_x: &[f64], _i: usize| -> f64 { 0.0_f64 }));
            i = i + 1;
        }

        PhaseSpace {
            flow: f,
            paths: vec![],
            dim: d,
            numpaths: 0,
        }
    }

    pub fn newpath(&mut self) -> () {
        self.paths.push(vec![0.0_f64; self.dim]);
        self.numpaths = self.numpaths + 1;
    }

    pub fn integrate_forward(&mut self) -> () {
        let mut i: usize = 0;
        let mut j: usize;
        while i < self.numpaths {
            j = 0;
            while j < self.dim {
                // println!("integrating for {}", j);
                self.paths[i][j] = self.paths[i][j] + self.flow[j](&self.paths[i], j) * DT;
                j = j + 1;
            }
            i = i + 1;
        }
    }

    pub fn integrate_backward(&mut self) -> () {
        let mut i: usize = 0;
        let mut j: usize;
        let mut k: usize;
        while i < self.numpaths {
            j = self.dim;
            k = 0;
            while k < self.dim {
                j = j - 1;
                // println!("integrating for {}", j);
                self.paths[i][j] = self.paths[i][j] + self.flow[j](&self.paths[i], j) * DT;
                k = k + 1;
            }
            i = i + 1;
        }
    }
}
// #[derive(Debug, Sync)]
pub struct Henri {
    pub chin: usize,
    pub chout: usize,
    pub process: Box<Fn(&[f64], &mut [f64], &Vec<PhaseSpace>) -> ()>,
    phnum: usize,
    pub phases: Vec<PhaseSpace>,
    ina: Vec<f64>,
    outa: Vec<f64>,
    idx: usize,
}

unsafe impl Send for Henri {}
//unsafe impl Sync for Henri {}

impl Henri {
    pub fn new(chin: usize, chout: usize) -> Henri {
        Henri {
            chin,
            chout,
            process: Box::new(|_i: &[f64], _o: &mut [f64], _p: &Vec<PhaseSpace>| -> () {}),
            phnum: 0,
            phases: vec![],
            ina: vec![0.0_f64; chin],
            outa: vec![0.0_f64; chout],
            idx: 0,
        }
    }

    pub fn newphase(&mut self, d: usize) -> &mut PhaseSpace {
        self.phases.push(PhaseSpace::new(d));
        self.phnum = self.phnum + 1;
        return &mut self.phases[self.phnum - 1];
    }

    pub fn integrate(&mut self) -> () {
        let mut i = 0;
        let mut k = 0;
        while i < self.phnum {
            // println!("integrating phase {} forward", i);
            self.phases[i].integrate_forward();
            i = i + 1;
        }
        i = self.phnum;
        while k < self.phnum {
            i = i - 1;
            // println!("integrating phase {} backward", i);
            self.phases[i].integrate_backward();
            k = k + 1;
        }
    }

    pub fn start(mut self) -> () {
        // set up jack
        let (client, _status) =
            jack::Client::new("rusty_henri", jack::ClientOptions::NO_START_SERVER).unwrap();

        let client = client;

        let mut in_ports = vec![];
        for i in 0..self.chin {
            in_ports.push(
                client
                    .register_port(&format!("in_{}", i), jack::AudioIn::default())
                    .unwrap(),
            );
        }

        let mut out_ports = vec![];
        for i in 0..self.chout {
            out_ports.push(
                client
                    .register_port(&format!("out_{}", i), jack::AudioOut::default())
                    .unwrap(),
            );
        }

        let jackprocess = jack::ClosureProcessHandler::new(
            move |_: &jack::Client, ps: &jack::ProcessScope| -> jack::Control {
                // Get output and input buffers
                let mut outb: Vec<_> = out_ports.iter_mut().map(|x| x.as_mut_slice(ps)).collect();
                let inb: Vec<_> = in_ports.iter_mut().map(|x| x.as_slice(ps)).collect();

                // println!("called with {} frames", outb[0].len());
                // Write output
                for v in 0..outb[0].len() {
                    // self.outa.clear();
                    for i in 0..self.chin {
                        self.ina[i] = inb[i][v] as f64
                    }
                    (self.process)(&self.ina, &mut self.outa, &self.phases);
                    for i in 0..self.chout {
                        outb[i][v] = self.outa[i] as f32
                    }
                    self.idx = self.idx + 1;
                    // if self.idx == 3 {
                    //     self.outa[5] = 0.0_f64;
                    // }
                    self.integrate();
                    // let x = 220.0 * time * 2.0 * std::f64::consts::PI;
                    // let y = x.sin();
                    // *v = y as f32;
                    // time += 1.0 / 48000.0 as f64;;
                }

                // Continue as normal
                jack::Control::Continue
            },
        );

        // activate the client
        let _active_client = client.activate_async((), jackprocess).unwrap();

        // block
        let mut user_input = String::new();
        io::stdin().read_line(&mut user_input);
    }
}
