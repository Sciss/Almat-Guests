# wasm-sync

rust wasm experiments and a small library for dealing with coupled synchronizing oscillators.

## Project directory structure

`src` - Rust code, see `lib.rs`
`pkg` - compiled wasm and js
`www` - web app, see `index.js` 

## Setup

### To (re)compile rust lib:
``` shell
wasm-pack build

```

### Linking package to www
In pkg (possibly with sudo):

``` shell
npm link
```

Then in /www :

``` shell
npm link wasm-sync
```

### npm
In /www:

``` shell
npm install
```

## run

``` shell
npm run start
```


It is based on the following:

* https://rustwasm.github.io/book/game-of-life/introduction.html

and uses this template:


# 🦀🕸️ `wasm-pack-template`

A template for kick starting a Rust and WebAssembly project using
[`wasm-pack`](https://github.com/rustwasm/wasm-pack).

This template is designed for compiling Rust libraries into WebAssembly and
publishing the resulting package to NPM.

* Want to use the published NPM package in a Website? [Check out
  `create-wasm-app`.](https://github.com/rustwasm/create-wasm-app)
* Want to make a monorepo-style Website without publishing to NPM? Check out
  [`rust-webpack-template`](https://github.com/rustwasm/rust-webpack-template)
  and/or
  [`rust-parcel-template`](https://github.com/rustwasm/rust-parcel-template).

## 🔋 Batteries Included

* [`wasm-bindgen`](https://github.com/rustwasm/wasm-bindgen) for communicating
  between WebAssembly and JavaScript.
* [`console_error_panic_hook`](https://github.com/rustwasm/console_error_panic_hook)
  for logging panic messages to the developer console.
* [`wee_alloc`](https://github.com/rustwasm/wee_alloc), an allocator optimized
  for small code size.

## 🚴 Usage

### 🐑 Use `cargo generate` to Clone this Template

[Learn more about `cargo generate` here.](https://github.com/ashleygwilliams/cargo-generate)

```
cargo generate --git https://github.com/rustwasm/wasm-pack-template.git --name my-project
cd my-project
```

### 🛠️ Build with `wasm-pack build`

```
wasm-pack build
```

### 🔬 Test in Headless Browsers with `wasm-pack test`

```
wasm-pack test --headless --firefox
```

### 🎁 Publish to NPM with `wasm-pack publish`

```
wasm-pack publish
```
