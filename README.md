
# voodoo.mk

> Let the voodoo build your C project for you.  
> voodoo.mk is a simple Makefile which helps you build your C project.

I've been amazed by [@macmade](https://github.com/macmade)'s [Magic Makefile][] since its release, although I never really took time to understand how it really works.  
I figured the best way to do so was to write one myself, and there is voodoo.mk.  
It's nowhere as powerful as Magic Makefile, and it will most likely never be, but I learned a lot writing it, and I intend to improve it.

## Warning

This is mostly an educational project, with a lot of quirks and [limitations](#limitations).  
If you need a full-featured Makefile, make sure to check out [Magic Makefile][], and its lot of amazing features.

[Magic Makefile]: http://www.eosgarden.com/en/opensource/magic-makefile/overview/

## Usage

    $ mkdir my-project
    $ wget https://raw.github.com/romac/voodoo.mk/master/Makefile
    $ make init

That will create the following directory structure:

    my-project/
    ├── Makefile
    ├── build
    │   ├── bin
    │   ├── lib
    │   └── obj
    │       └── lib
    ├── src
    │   ├── include
    │   └── lib
    │       └── include
    └── test
        ├── bin
        └── lib

Now, just edit `Makefile`, and follow the instructions inside.
Once you're done, start coding, and run `make` from time to time :)

## Commands

### `make init`
Create the expected directory structure.

### `make`
Build both the dynamic library and the executable.

### `make run`
Run (and build, if needed) the executable.

### `make test`
Run (and build, if needed) the test binary.

### `make clean`
Clean the build products.

## Limitations

- Only supports C code.
- Only works on OS X.
- Assume you want to build both a dynamic library and well as an executable, linked with the former.  
  Doing one without the other is possible without too much effort, but it requires modifying the Makefile.
- Most likely a ton of others that I haven't thought of yet.

## TODO

- Add `make help`.
- Log messages detailing what's happening instead of showing the commands being executed (should be configurable).
- Fix at least some of the limitations above.

## License

voodoo.mk is released under the [MIT license](http://romac.mit-license.org).
