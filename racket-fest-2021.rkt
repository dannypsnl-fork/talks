#lang slideshow

(require slideshow/code)

(slide
  #:title "Macro as Type"
  (t "Hi"))

(slide
  #:title "Macro as Type?"
  (code (define- x : Number 1)))

(slide
  #:title "Became"
  (code (begin
          (define-for-syntax x Number)
          (define x 1))))

(slide
  #:title "How?"
  (code
    (define-syntax-parser define-
      [(_ name:id ty exp)
       (unless (equal? ty (typeof exp))
         (raise-syntax-error
           'unexpected
           (format "expect ~a, but got ~a"
                   ty
                   (typeof exp)))
           this-syntax
           #'exp)
       #'(begin
           (define-for-syntax name ty)
           (define name exp))])))

(slide
  #:title "typeof"
  (code
    (define (typeof stx)
      (syntax-parse stx
        [x:number Number]
        [x:string String]
        [x:boolean Boolean]
        [x:char Char]
        [_ (eval stx)]))))

(slide
  #:title "Function?"
  (code
    [(_ (name:id [p*:id ty*:type] ...) : ty:type body)
     (let (p* ty*) ...
             body)
     #'(begin
         (define-for-syntax name
           (-> ty* ... ty))
         (define (name p* ...)
           body))]))

(slide
  #:title "But origin racket code?")

(slide
  #:title "claim"
  (code
    [(_ name:id : ty:type)
     #'(define-for-syntax name ty)]))

(slide
  #:title "claim example"
  (code (claim add1 : (Number . -> . Number))
        (add1 "s")))

; TODO
; - generic
; - arbitrary length parameter
