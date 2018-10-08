; Copyright (c) 2017 Chris Double.  All rights reserved.
; BSD 3-Clause License: http://opensource.org/licenses/BSD-3-Clause
;
; Shen Scheme derived soure code is:
; Copyright (c) 2012-2015 Bruno Deferrari.  All rights reserved.

(module "primitives")
(import "lib/with-io")
(import "lib/eval")

(define (call-with-output-string proc)
  (define q (make-queue))
  (proc q)
  (send 'quit q)
  (define msg (wait q))
  (define output (make-string))
  (while (not (eq? msg 'quit))
    (string-append! output msg)
    (set! msg (wait q)))
  output)

(export call-with-output-string)

(define (write-u8 byte out)
  (define out (car out))
  (cond
    ((file? out) (write-file out (make-string 1 byte)))
    (else
      (send (make-string 1 byte) out)
      (if (or (= byte 13) (= byte 10))
        (pause))))
  out)

(export write-u8)

(define (read-u8 in)
  (define input-buffer (cdr in))
  (define my-in (car in))
  (if (file? my-in) (return (read-file-u8 my-in input-buffer)))
  (if (> (string-length input-buffer) 0)
    (string-read-byte! input-buffer)
    (begin
      (define msg (wait my-in))
      (cond
        ((and (string? msg) (> (string-length msg) 0))
          (string-append! input-buffer msg)
          (read-u8 in))
        ((string? msg) -1)
        (else (error 'read-u8 "Non-string on input stream"))))))

(export read-u8)

(define (read-file-u8 in input-buffer)
  (if (> (string-length input-buffer) 0)
    (string-read-byte! input-buffer)
    (begin
      (define msg (read-file in 1024))
      (cond
        ((and (string? msg) (> (string-length msg) 0))
          (string-append! input-buffer msg)
          (read-file-u8 in input-buffer))
        ((string? msg) -1)
        (else (error 'read-file-u8 "Non-string on file stream"))))))

(export read-file-u8)

;; Boolean Operators
;;

(define (assert-boolean value)
  (if (boolean? value)
      value
      (error 'assert-boolean "expected a boolean, got" value)))

(export assert-boolean)

;; Symbols
;;

(define (kl:intern name)
  (cond ((equal? name "true") #t)
        ((equal? name "false") #f)
        ((string-find name "@") (string->symbol (string-replace name "@" "_waspvm_at_")))
        ((string-find name ";") (string->symbol (string-replace name ";" "_waspvm_sc_")))
        ((string-find name "$") (string->symbol (string-replace name "$" "_waspvm_dl_")))
        (else (string->symbol name))))

;; Strings
;;

(define (kl:str value)
   (cond ((eq? value #t) "true")
         ((eq? value #f) "false")
         ((symbol? value)
          (define s (symbol->string value))
          (cond
           ((string-find s "_waspvm_at_")
            (string-replace s "_waspvm_at_" "@"))
           ((string-find s "_waspvm_sc_")
            (string-replace s "_waspvm_sc_" ";"))
           ((string-find s "_waspvm_dl_")
            (string-replace s "_waspvm_dl_" "$"))
           (else s)))
         ((function? value) ;; Required for kl:symbol to return false for functions
          (string-append "#" (format (type value)) " " (format value)))
         (else
          (format value))))

;; Assignments
;;

(define *shen-globals* (make-dict))

(define (kl:set key val)
  (dict-set! *shen-globals* key val)
  val)

(define (kl:value key)
  (if (not (dict-set? *shen-globals* key))
    (error 'kl:set "variable has no value: " key))
  (dict-ref *shen-globals* key))

(define (kl:error-to-string e)
  (format e))

(define (vector=? a b)
  (define len (vector-length a))
  (if (not (= len (vector-length b)))
    (return #f))

  (define i 0)
  (while (< i len)
    (if (not (kl:= (vector-ref a i) (vector-ref b i)))
      (return #f))
    (set! i (+ 1 i)))
  #t)
                  
(define (kl:= a b)
  (cond ((eq? a b) #t) ;; fast path
        ((number? a) (and (number? b) (= a b)))
        ((pair? a)
         (and (pair? b)
              (kl:= (car a) (car b))
              (kl:= (cdr a) (cdr b))))
        ((string? a) (and (string? b) (string=? a b)))
        ((vector? a) (and (vector? b) (vector=? a b)))
        ;; the first eq? test already covers for null and symbols
        (else #f)))

(define (kl:eval-kl expr)
  (eval (kl->wasp expr)))

(define (full-path-for-file filename)
  (path-join (kl:value (quote *home-directory*)) filename))

(define (kl:open filename direction)
  (let ((full-path (full-path-for-file filename)))
    (case direction
      ((in) (if (path-exists? full-path)
                (cons (open-file full-path "r") (make-string))
                (error 'kl:open "File does not exist" full-path)))
      ((out) (cons (open-file full-path "wct") #f))
      (else (error 'kl:open "Invalid direction" direction)))))

(define (kl:close stream)
   (if (file? (car stream))
     (close-file (car stream))
     (send 'close (car stream))))

(define (kl:get-time sym)
  (case sym
    ((real) (now))
    ((run) (now))
    (else (error kl:get-time "get-time does not understand the parameter" sym))))

(export kl:get-time kl:close kl:open kl:eval-kl kl:= kl:error-to-string kl:value kl:set kl:str kl:intern)
