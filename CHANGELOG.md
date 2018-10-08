# Change Log

## unreleased

- Add module declarations to Wasp Lisp files and a `shen-libs.ms` that
  can be imported to load all the compiled Shen code from Lisp.

## 0.10 - 2018-10-07

- Update to Shen OS Kernel 21.1.

## 0.9 - 2018-10-06

- Add `shen-wasp.*argv*` variable to get list of command line arguments.
- Fix 'cd' function so current directory changing works with 'load'.
- Add command line arguments to load scripts, evaluate expressions and show usage.

## 0.8 - 2018-07-04

- Update to Shen OS Kernel 21.0.

## 0.7 - 2017-05-23

- update to Shen OS Kernel 20.1.
- Improve startup time.

## 0.6 - 2017-05-02

- Includes KLambda code generated from Shen source with commit `b6bb8333` included to fix `*sterror*` issue.
- Includes KLambda code generated from shen source with commit `c5810337` included to fix `dict-fold` issue.
- Added Change Log.
