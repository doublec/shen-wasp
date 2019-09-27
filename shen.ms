; Copyright (c) 2017 Chris Double.  All rights reserved.
; BSD 3-Clause License: http://opensource.org/licenses/BSD-3-Clause

(import "shen-lib")

(define (usage)
  (println* "Usage: shen [options] [...args...]\n"
            "  -h, --help          : Prints help and exits\n"
            "  -l, --load <file>   : Loads Shen <file>\n"
            "  -e, --eval <string> : Evaluates <string>\n"
            "  -r, --repl          : Run the REPL, even if -l or -e are provided\n"
            "Any additional arguments are passed to the Shen system in\n"
            "the variable shen-wasp.*argv*"))

(define (process-load file)
  (define contents (kl:read-file file))
  (map (lambda (x) (kl:shen.eval-without-macros x)) contents))

(define (process-eval str)
  (println* (format (kl:eval (kl:head (kl:read-from-string str))))))

(define (main . args)
  (define argv (make-tc))
  (define repl #t)
  (until (null? args)
    (define arg (car args))
    (set! args (cdr args))
    (cond
      ((or (string=? arg "--help") (string=? arg "-h"))
        (usage)
        (set! repl #f))
      ((or (string=? arg "-l") (string=? arg "--load"))
        (set! repl #f)
        (process-load (car args))
        (define args (cdr args)))
      ((or (string=? arg "-e") (string=? arg "--eval"))
        (set! repl #f)
        (process-eval (car args))
        (define args (cdr args)))
      ((or (string=? arg "-r") (string=? arg "--repl"))
        (set! repl #t))
      (else
        (tc-add! argv arg))))
  (kl:set (quote shen-wasp.*argv*) (tc->list argv))
  (kl:shen.initialise)
  (when repl (kl:shen.repl)))
