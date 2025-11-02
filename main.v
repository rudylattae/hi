module main

import os

fn main() {
	println('Hello World!')
	res := os.execute('ls')
	println(res)
}
