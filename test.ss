#lang scheme
(require "contract-gen.scm")
(require (planet schematics/schemeunit:3:4))

(define (test-gen-s g attempts)
  (if (<= attempts 0)
      #t
      (begin (g 2)
             (test-gen-s g (- attempts 1)))))

(define (test-gen--> dom range attempts)
  (local ([define g (gen--> dom range)]
          [define dom-gen (gen dom)])
    (do ([x 0 (+ x 1)])
      ((>= x attempts))
      ((g 2) (dom-gen 2)))
    #t))

(define (make/c contract . args)
  (void))


(check-equal? (test-gen-s (gen-integer) 100)
              #t)

(check-equal? (test-gen-s (gen-positive) 100)
              #t)

(check-equal? (test-gen-s (gen-between/c 0 100) 100)
              #t)

(check-equal? (test-gen--> integer? integer? 100)
              #t)

(check-equal? (test-gen--> integer? positive? 100)
              #t)

