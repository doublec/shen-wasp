# Change Log

## 0.12 - 2022-04-29

- Update to Shen OS Kernel 22.4

## 0.11 - 2019-09-28

- Add module declarations to Wasp Lisp files and a `shen-libs.ms` that
  can be imported to load all the compiled Shen code from Lisp.
- Update to Shen OS Kernel 22.0.
- Requires a new version of Wasp Lisp, that can handle larger package sizes.
  Tested with commit 95cbb26 of the Wasp VM from https://github.com/doublec/shen-wasp/
  in the `shen` branch.
- Changes command line argument handling to the OS Kernel 22.0 launcher extension.

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
