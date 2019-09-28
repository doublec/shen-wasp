; Copyright (c) 2017 Chris Double.  All rights reserved.
; BSD 3-Clause License: http://opensource.org/licenses/BSD-3-Clause

(import "shen-lib")

(define (main . args)
  (kl:shen.initialise)
  (kl:shen.x.launcher.main (cons "shen" args)))
