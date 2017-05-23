; Copyright (c) 2017 Chris Double.  All rights reserved.
; BSD 3-Clause License: http://opensource.org/licenses/BSD-3-Clause
;
; Shen Scheme derived soure code is:
; Copyright (c) 2012-2015 Bruno Deferrari.  All rights reserved.

(define kl:shen.old-sysfunc? kl:shen.sysfunc?)
(define (kl:shen.sysfunc? x) (or (null? x) (kl:shen.old-sysfunc? x)))

(define (kl:element? V2813 V2814)
  (and (member V2813 V2814) #t))

(define (kl:shen.alpha? V2704)
  (kl:element? V2704 '("A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" "P" "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z" "a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z" "=" "*" "/" "+" "-" "_" "?" "$" "!" "@" "~" ">" "<" "&" "%" "{" "}" ":" ";" "`" "#" "." "'")))

(define (kl:shen.alphanums? V2706)
  (define buf (make-string 1 65))
  (define len (string-length V2706))
    
  (define i 0)
  (while (< i len)
    (string-set! buf 0 (string-ref V2706 i))
    (if (not (kl:shen.alphanum? buf))
        (return #f))
    (set! i (+ 1 i)))
  #t)

(define (kl:integer? x)
  (or (integer? x) (and (real? x) (= 0.0 (- (real->integer x) x)))))
(define (kl:map V2961 V2962) (map V2961 V2962))
(define (kl:append V2735 V2736) (append V2735 V2736))
(define (kl:sum V2899) (apply + V2899))
(define (kl:reverse V2925) (reverse V2925))

(define (kl:shen.pvar? x)
  (and (vector? x) (eq? (vector-ref x 0) 'shen.pvar)))

(define (kl:variable? V2712)
  (cond ((or (kl:boolean? V2712) (or (number? V2712) (string? V2712))) #f)
  (#t (kl:shen.analyse-variable? (kl:str V2712)))))

(define (kl:symbol? V2700)
  (cond ((or (kl:boolean? V2700) (or (number? V2700) (string? V2700))) #f)
         (#t (kl:shen.analyse-symbol? (kl:str V2700)))))

(define (kl:<-address/or V2855 V2856 V2857)
  (if (>= V2856 (vector-length V2855))
    (kl:thaw V2857)
    (vector-ref V2855 V2856)))

(define (kl:shen.compose V1709 V1710)
  (define r V1710)
  (define m V1709)
  (while (pair? m)
    (set! r ((car m) r))
    (set! m (cdr m)))
  (if (null? m)
    r
    (kl:shen.f_error (quote shen.compose))))

(define (kl:shen.safe-multiply a b)
  (define m (* a b))
  (if (and (not (= a 0)) (not (= (/ m a) b)))
    (error "Integer overflow in safe-*")
    m))

