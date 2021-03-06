# Wasp/Shen, a Wasp Lisp port of the Shen Language

[Shen](http://shenlanguage.org/) is a functional programming language with a number of interesting features. These include:

* Optional static type checking
* Pattern matching
* Integrated Prolog system
* Parsing libraries

Shen can be ported without too much effort to other language systems. Many of the community ports are available from the [Shen download page](http://shenlanguage.org/download_form.html). A commercial port of Shen is available as part of [Shen Professional](http://shenlanguage.org/professional.html).

This port runs on top of [Wasp Lisp](http://bluishcoder.co.nz/tags/waspvm/), a small Lisp system with concurrency and distributed features. Wasp Lisp is not actively developed but the author [Scott Dunlop](https://waspvm.blogspot.com/) monitors the [github repository](https://github.com/swdunlop/WaspVM/) and processes pull requests. Shen requires features that Wasp Lisp doesn't currently support, like real numbers. I maintain a [fork on github](https://github.com/doublec/WaspVM/tree/shen) that implements the features that Shen needs.

The reason for this port is that I use Wasp Lisp in some projects and wanted to try Shen in some of the areas where I use Wasp and [MOSREF](https://bluishcoder.co.nz/2009/11/28/using-wasp-lisp-secure-remote-injection.html).

This port is heavily based on the [Shen Scheme](https://github.com/tizoc/shen-scheme) implementation. Much of the code is ported from Scheme to Wasp Lisp and the structure is kept the same. The license for code I wrote is the same as the Shen Scheme License, BSD3-Clause.

## Binaries

The following compiled binaries are available:

[shen_static.bz2](https://bluishcoder.co.nz/shen/shen_static.bz2). This is a static 64-bit linux binary with no dependancies. It should run on any 64-bit Linux system.  Decompress with:

    $ bunzip2 shen_static.bz2
    $ chmod +x shen_static
    $ ./shen_static

[shen_macos.bz2](https://bluishcoder.co.nz/shen/shen_macos.bz2). 64-bit binary for Mac OS. Decompress with `bunzip2` as above.

[shen.zip](https://bluishcoder.co.nz/shen/shen.zip). The zip file contains a Windows 64-bit binary, `shen.exe`. It should run on any modern 64-bit Windows system.

Releases and changelog are available on the [Github releases page](https://github.com/doublec/shen-wasp/releases).

## Usage

Running the `shen` executable without command line arguments will start the REPL. Command line handling is done via the Shen OS Kernel [launcher extension](https://github.com/Shen-Language/shen-sources/blob/master/doc/extensions/launcher.md). This makes the following command line arguments available:

    Usage: shen [--version] [--help] <COMMAND> [<ARGS>]
    
    commands:
        repl
            Launches the interactive REPL.
            Default action if no command is supplied.
    
        script <FILE> [<ARGS>]
            Runs the script in FILE. *argv* is set to [FILE | ARGS].
    
        eval <ARGS>
            Evaluates expressions and files. ARGS are evaluated from
            left to right and can be a combination of:
                -e, --eval <EXPR>
                    Evaluates EXPR and prints result.
                -l, --load <FILE>
                    Reads and evaluates FILE.
                -q, --quiet
                    Silences interactive output.
                -s, --set <KEY> <VALUE>
                    Evaluates KEY, VALUE and sets as global.
                -r, --repl
                    Launches the interactive REPL after evaluating
                    all the previous expresions.

For example, building the Shen KLambda files from the [Shen source](https://github.com/Shen-Language/shen-sources):

    $ shen eval -l make.shen -e "(make)"
    sources directory: "sources/"
    klambda directory: "klambda/"
    
    compiling core
    compiling declarations
    ...
    compiling yacc
    
    compilation complete.

## FFI

Wasp Lisp functions can be called from Shen. They live under the `wasp` namespace (requiring a `wasp.` prefix). For example, to spawn a Wasp thread to print something after five seconds:

    (wasp.spawn (freeze (do (wasp.pause 5000) (print "Hello World\n"))))

The Wasp function `spawn` takes a lambda that has no arguments. I couldn't find a way to create such a thing from Shen, but "freeze" is implemented to wrap its expression in a no argument lambda so that worked for this case.  Note that Wasp threads are cooperative, not preemptive, and are green threads, not system threads.

## Building

First step, build the fork of Wasp Lisp needed to run:

    $ git clone --branch shen https://github.com/doublec/WaspVM wasp-shen
    $ cd wasp-shen
    $ make install

Follow the prompts for the location to install the wasp lisp binaries and add that `bin` directory of that location to your path:

    $ export PATH=$PATH:/path/to/install/bin

Shen is provided in source code format from the [Shen Sources](https://github.com/Shen-Language/shen-sources) github repository. The code is written in Shen. It needs a working Shen system to compile that code to [KLambda](http://www.shenlanguage.org/learn-shen/shendoc.htm#The%20Primitive%20Functions%20of%20K%20Lambda), a small Lisp subset that Shen uses as a virtual machine. This KLamda code can be found in the `kl` directory in this repository. These KLambda files are compiled to Wasp Lisp and stored as compiled code in the `compiled` directory. The repository includes a recent version of these files. To generate, or re-generate, run the following commands:

    $ rlwrap wasp
    >> (import "driver")
    >> (compile-all)
    Compiling toplevel.kl
    Compiling core.kl
    Compiling sys.kl
    Compiling sequent.kl
    Compiling yacc.kl
    Compiling reader.kl
    Compiling prolog.kl
    Compiling track.kl
    Compiling load.kl
    Compiling writer.kl
    Compiling macros.kl
    Compiling declarations.kl
    Compiling types.kl
    Compiling t-star.kl

This will create files with the Wasp Lisp code in the `compiled/*.ms` files, and the compiled bytecode in `compiled/*.mo` files.

Creating a Shen executable can be done with:

    $ waspc -exe shen shen.ms
    $ chmod +x shen
    $ rlwrap ./shen
    Shen, copyright (C) 2010-2015 Mark Tarver
    www.shenlanguage.org, Shen 22.0
    running under Wasp Lisp, implementation: WaspVM
    port 0.11 ported by Chris Double
    
    (0-) 

## Running from the Wasp REPL

Shen can be run and debugged from the Wasp REPL. To import the compiled code and run Shen:

    $ rlwrap wasp
    >> (import "shen-lib")
    >> (kl:shen.repl)
    Shen, copyright (C) 2010-2015 Mark Tarver
    www.shenlanguage.org, Shen 22.0
    running under Wasp Lisp, implementation: WaspVM
    port 0.11 ported by Chris Double

    (0-)

When developing on the compiler it's useful to use `eval-all`. This will load the KLambda files, compile them to Scheme and `eval` them:

    >> (import "driver")
    >> (eval-all)
    >> (kl:shen.repl)
    ...

A single input line of Shen can be entered and run, returning to the Wasp REPL with:

    >> (kl:shen.read-evaluate-print) 
    (+ 1 2)
    3:: 3

KLambda functions can be called from Wasp by prefixing them with `kl:`. For example:

    >> (kl:shen.read-evaluate-print)
    (define factorial
      1 -> 1
      X -> (* X (factorial (- X 1))))
    factorial:: factorial
    >> (kl:factorial 10)
    :: 3628800

Shen allows introspecting compiled Shen functions and examining the KLambda code. From the Wasp REPL this is useful for viewing the KLambda and comparing with the generated Wasp Lisp:

    >> (kl:ps 'factorial)
    :: (defun factorial (V1172) (cond (...) (...)))
    >> (pretty (kl:ps 'factorial))
    (defun factorial (V1172 ) (cond ((= 1 V1172 ) 1 ) (#t (* V1172 (factorial (- V1172 1 ) ) ) ) ) ) :: null
    >> (pretty (kl->wasp (kl:ps 'factorial)))
    (begin (register-function-arity (quote factorial ) 1 )
           (define (kl:factorial V1172)
             (cond
               ((kl:= 1 V1172) 1)
               (#t (* V1172 (kl:factorial (- V1172 1))))))
           (quote factorial ) ) :: null

## Cross Compilation

Wasp binaries are a small Wasp VM stub plus the compiled Lisp code appended to it. This makes building for other platforms easy as long as you have the stub for that platform.

Wasp can be built for [Android](https://bluishcoder.co.nz/2013/05/09/building-wasp-lisp-and-mosref-for-android.html) and [static binaries via musl](https://bluishcoder.co.nz/2016/06/05/building-static-wasp-lisp-binaries.html) are possible.

I've made the following stubs available for building binaries for other systems:

* [Musl 64-bit Linux static stub](https://bluishcoder.co.nz/shen/waspvm-static-linux-x86_64.bz2)
* [64-bit Linux stub](https://bluishcoder.co.nz/shen/waspvm-linux-x86_64.bz2)
* [64-bit Windows stub](https://bluishcoder.co.nz/shen/waspvm-win-x86_64.exe.bz2)
* [64-bit Mac OS stub](https://bluishcoder.co.nz/shen/waspvm-Darwin-x86_64.bz2)

Decompress them and copy into the `lib/waspvm-stubs` directory where Wasp Lisp was installed. Shen can then be built on your platform for 64 bit linux, 64 bit Linux static binaries or 64 bit Windows with:

    $ waspc -exe shen -platform linux-x86_64 shen.ms
    $ waspc -exe shen_static -platform static-linux-x86_64 shen.ms
    $ waspc -exe shen.exe -platform win-x86_64 shen.ms
    $ waspc -exe shen_macos -platform Darwin-x86_64 shen.ms

## Building KLambda files from Shen Source

To generate new KLambda files from the original [Shen source](https://github.com/Shen-Language/shen-sources) requires loading the `make.shen` and running the `make` function. Once generated the KLambda files can be recompiled as described above to generate a new Wasp Shen system with updated Shen kernel code. The following shows how this can be done using an existing Wasp Shen executable:

    $ git clone https://github.com/Shen-Language/shen-sources
    $ cd shen-sources
    $ mkdir klambda
    $ shen eval -l make.shen -e "(make)"
    sources directory: "sources/"
    klambda directory: "klambda/"
    
    compiling core
    compiling declarations
    ...
    compiling yacc
    
    compilation complete.

Copy the KLambda files from the `klambda` directory to the `kl` directory of this repository and rebuild the Wasp Shen system:

    $ cp klambda/*.kl ...path to wasp shen.../kl/
    $ cd ...path to wasp shen...
    $ rlwrap wasp
    >> (import "driver")
    >> (compile-all)
    Compiling toplevel.kl
    ...
    <Ctrl+D>
    $ make
    ...

## Running Shen Kernel Tests

The Shen kernel tests are in the Shen Sources repository. They can be run with:

    $ git clone https://github.com/Shen-Language/shen-sources
    $ cd shen-sources/tests
    $ shen eval -l README.shen -l tests.shen
 
## Current Port State

This is a very early version. I've only just got it working. The [Shen tests](https://github.com/Shen-Language/shen-sources/tree/master/tests) pass.

The port is quite slow - about half the speed of the Shen C interpreter and significantly slower than Shen Scheme and Shen on SBCL. I've done some work on optimizing tail calls in the fork of the Wasp VM for Shen but there's much more work on the entire port that could improve things.

I'd like to wrap some of the Wasp concurrency code and see how well Shen works in areas I use Wasp for.

## Learning Shen

Some places to go to learn Shen:

* The [Shen OS Kernel Manual](http://shenlanguage.org/learn-shen/index.html) has a good overview of what the open source version of Shen can do. 
* [Shen System Functions](https://github.com/Shen-Language/shen-sources/blob/master/doc/system-functions.md)
* [Kicking the tires of Shen Prolog](https://bluishcoder.co.nz/2016/08/30/kicking-the-tires-of-shen-prolog.html)
* [Shen, A Sufficiently Advanced Lisp](https://www.youtube.com/watch?v=lMcRBdSdO_U)
* [Shen Trick Shots](https://www.youtube.com/watch?v=BUJNyHAeAc8)
* [The Book of Shen](https://www.amazon.co.uk/Book-Shen-Third-Mark-Tarver/dp/1784562130)

## Other Ports

* [Shen Scheme](https://github.com/tizoc/shen-scheme)
* [Shen Elisp](http://github.com/deech/shen-elisp)
* [Shen Ruby](https://github.com/gregspurrier/shen-ruby)
* [Shen Haskell](https://github.com/mthom/shentong)
* [Shen C](https://github.com/otabat/shen-c/)

## License

- Shen, Copyright © 2010-2015 Mark Tarver - [License](http://www.shenlanguage.org/license.pdf).
- Portions of the code adapted from shen-scheme, Copyright © 2012-2015 Bruno Deferrari under [BSD 3-Clause License](http://opensource.org/licenses/BSD-3-Clause).
- shen-wasp, Coyright © 2017 Chris Double under [BSD 3-Clause License](http://opensource.org/licenses/BSD-3-Clause).
