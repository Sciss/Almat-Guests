// extern crate henry;
use henri;

fn main() {
    let mut hen = henri::Henri::new(2, 4);

    // let mut p = hen.newphase(4);

    // let f = 90000.0_f64;

    // p.flow[1] = Box::new(move |x: &[f64], i: usize| -> f64 { x[i - 1] * -f });
    // p.flow[3] = Box::new(move |x: &[f64], i: usize| -> f64 { x[i - 1] * -f });
    // p.flow[0] = Box::new(move |x: &[f64], i: usize| -> f64 { x[i + 1] * f });
    // p.flow[2] = Box::new(move |x: &[f64], i: usize| -> f64 { x[i + 1] * f });

    // p.newpath();
    // p.paths[0][0] = 0.5_f64;
    // p.paths[0][2] = 0.5_f64;

    // hen.process = Box::new(
    //     move |_i: &[f64], o: &mut [f64], phs: &Vec<henri::PhaseSpace>| {
    //         o[0] = phs[0].paths[0][0];
    //         o[1] = phs[0].paths[0][1];
    //         o[2] = phs[0].paths[0][2];
    //         o[3] = phs[0].paths[0][3];
    //     },
    // );

    let mut p = hen.newphase(48 * 2 * 3);

    p.newpath();

    let f = 1000.0_f64;

    for i in 1..(48 * 3 - 1) {
        p.flow[i * 2] = Box::new(move |x: &[f64], i: usize| -> f64 { x[i - 1] * -f });
        p.flow[i * 2 + 1] = Box::new(move |x: &[f64], i: usize| -> f64 { x[i + 1] * f });
        p.paths[0][i * 2] = 0.5_f64;
    }

    hen.process = Box::new(
        move |_i: &[f64], o: &mut [f64], phs: &Vec<henri::PhaseSpace>| {
            o[0] = phs[0].paths[0][4];
            o[1] = phs[0].paths[0][5];
            o[2] = phs[0].paths[0][6];
            o[3] = phs[0].paths[0][7];
        },
    );

    hen.start();
}
