; Copyright (c) 2017 Chris Double.  All rights reserved.
; BSD 3-Clause License: http://opensource.org/licenses/BSD-3-Clause

(import "driver")
(import "compiled/toplevel.kl")
(import "compiled/core.kl")
(import "compiled/sys.kl")
(import "compiled/sequent.kl")
(import "compiled/yacc.kl")
(import "compiled/reader.kl")
(import "compiled/prolog.kl")
(import "compiled/track.kl")
(import "compiled/load.kl")
(import "compiled/writer.kl")
(import "compiled/macros.kl")
(import "compiled/declarations.kl")
(import "compiled/types.kl")
(import "compiled/t-star.kl")
(import "overwrites-internal")

(define (main)
  (kl:shen.shen))
