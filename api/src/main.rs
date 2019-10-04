#![feature(proc_macro_hygiene, decl_macro)]

#[macro_use] extern crate rocket;
extern crate rocket_contrib;

use std::process;
use std::env;
use rocket_contrib::serve::StaticFiles;

#[get("/hello")]
fn hello() -> &'static str {
    "Hello, world! (Rust)"
}

fn main() {
    // TODO make it possible to specify UI path
    let ui_path = match env::current_exe() {
        Ok(p) => p.parent().unwrap().join("ui/"),
        Err(_) => process::exit(0x0100),
    };

    rocket::ignite()
        .mount("/", StaticFiles::from(ui_path))
        .mount("/api", routes![hello])
        .launch();
}
