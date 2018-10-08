; Copyright (c) 2017 Chris Double.  All rights reserved.
; BSD 3-Clause License: http://opensource.org/licenses/BSD-3-Clause
;
; Shen Scheme derived soure code is:
; Copyright (c) 2012-2015 Bruno Deferrari.  All rights reserved.

(import "primitives")
(import "declarations")
(import "compiler")
;(load "primitives.ms")
;(load "declarations.ms")
;(load "overwrites-internal.ms")
;(load "compiler.ms")

(define (pretty x) (if (list? x) (begin (print "(") (for-each (lambda (y) (if (list? y) (pretty y) (begin (print (format y)) (print " ")))) x) (print ") ")) (begin (print (format x)) (print " "))))

(define (char-whitespace? char)
  (or
    (= char (string-ref " " 0))
    (= char (string-ref "\t" 0))
    (= char (string-ref "\n" 0))
    (= char (string-ref "\r" 0))))

(define (digit? char)
  (and (>= char 48) (<= char 57)))

;; From https://rosettacode.org/wiki/S-Expressions#Scheme
(define (sexpr-read str)
  (define (help str)
    (let ((char (string-read-byte! str)))
      (cond
       ((or (not char) (eq? char (string-ref "\)" 0))) '())
       ((= char (string-ref "(" 0))
         (define lhs (help str))
         (define rhs (help str))
         (cons lhs rhs))
       ((char-whitespace? char) (help str))
       ((eq? char (string-ref "\"" 0)) (cons (quote-read str) (help str)))
       ((and (= char (string-ref "-" 0)) (> (string-length str) 1) (digit? (string-ref str 0))) (cons (* -1 (number-read str)) (help str)))
       ((digit? char) (string-prepend! str (make-string 1 char)) (cons (number-read str) (help str)))
       (else (string-prepend! str (make-string 1 char)) (cons (string-read str) (help str))))))
  ; This is needed because the function conses all parsed sexprs onto something,
  ; so the top expression is one level too deep.
  (define result (help str))
  (if (null? result ) result (car result)))
 
(define (list->string lst str)
  (cond
    ((null? lst) str)
    (else 
      (string-append-byte! str (car lst))
      (list->string (cdr lst) str))))


(define (quote-read str)
  (define (help str)
    (let ((char (string-read-byte! str)))
      (if
       (or (not char) (eq? char (string-ref "\"" 0)))
       '()
       (cons char (help str)))))
  (list->string (help str) (make-string)))

(define (string-read str)
  (define (help str)
    (let ((char (string-read-byte! str)))
      (cond
       ((or (not char) (char-whitespace? char)) '())
       ((eq? char (string-ref ")" 0)) (string-prepend! str (make-string 1 char)) '())
       (else (cons char (help str))))))
  (kl:intern (list->string (help str) (make-string))))

(define (number-read str)
  (define real #f)
  (define (help str)
    (let ((char (string-read-byte! str)))
      (cond
       ((or (not char) (char-whitespace? char)) '())
       ((eq? char (string-ref ")" 0)) (string-prepend! str (make-string 1 char)) '())
       ((eq? char (string-ref "." 0)) (set! real #t) (cons char (help str)))
       ((or (< char 48) (> char 57)) (string-prepend! str (make-string 1 char)) '())
       (else (cons char (help str))))))
  (define str (list->string (help str) (make-string)))
  ((if real string->real string->integer) str))

(define (read-kl-file path)
  (sexpr-read (string-append "(" (read-data-file path) ")")))

(import "lib/waspc")

(define (compile-all)
  (define files '("toplevel.kl"
                  "core.kl"
                  "sys.kl"
                  "sequent.kl"
                  "yacc.kl"
                  "reader.kl"
                  "prolog.kl"
                  "track.kl"
                  "load.kl"
                  "writer.kl"
                  "macros.kl"
                  "dict.kl"
                  "declarations.kl"
                  "types.kl"
                  "t-star.kl"
  ))
  (for-each
    (lambda (file)
      (print "Compiling ") (print file) (print "\n")
      (define compiled-name (string-append "compiled/" file))
      (write-lisp-file (string-append compiled-name ".ms") (cons `(module ,compiled-name) (map kl->wasp (read-kl-file (string-append "kl/" file)))))
      (waspc (string-append "compiled/" file ".ms")))
    files)
  (waspc "overwrites-internal.ms"))

(define (eval-all)
  (define files '("toplevel.kl"
                  "core.kl"
                  "sys.kl"
                  "sequent.kl"
                  "yacc.kl"
                  "reader.kl"
                  "prolog.kl"
                  "track.kl"
                  "load.kl"
                  "writer.kl"
                  "macros.kl"
                  "dict.kl"
                  "declarations.kl"
                  "types.kl"
                  "t-star.kl"))
  (for-each
    (lambda (file)
      (print "Compiling ") (print file) (print "\n")
      (map (lambda (x) (eval (kl->wasp x))) (read-kl-file (string-append "kl/" file))))
    files)
  (load "overwrites-internal.ms"))


(define (load-all)
  (define files '("toplevel.kl"
                  "core.kl"
                  "sys.kl"
                  "sequent.kl"
                  "yacc.kl"
                  "reader.kl"
                  "prolog.kl"
                  "track.kl"
                  "load.kl"
                  "writer.kl"
                  "macros.kl"
                  "dict.kl"
                  "declarations.kl"
                  "types.kl"
                  "t-star.kl"
  ))
  (for-each
    (lambda (file)
      (print "Loading ") (print file) (print "\n")
      (load (string-append "compiled/" file ".mo")))
    files)
  (load "overwrites-internal.ms"))

(kl:set (quote *language*) "Wasp Lisp")
(kl:set (quote *implementation*) "WaspVM")
(kl:set (quote *port*) "0.10")
(kl:set (quote *porters*) "Chris Double")
(kl:set (quote *sterror*) (cons (current-output) #f))
(kl:set (quote *stinput*) (cons (current-input) (make-string)))
(kl:set (quote *stoutput*) (cons (current-output) #f))
(kl:set (quote *home-directory*) (getcwd))
(kl:set (quote shen.*initial-home-directory*) (getcwd))







