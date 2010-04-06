#lang scheme
(require "contract-gen.scm")
(require (planet schematics/schemeunit:3:4))

(define (test-gen-s g attempts)
  (if (<= attempts 0)
      #t
      (begin (g)
             (test-gen-s g (- attempts 1)))))

(define (test-gen g f attempts)
  (if (<= attempts 0)
      #t
      (begin (apply f (g))
             (test-gen-s g (- attempts 1)))))


(define (make/c contract . args)
  (void))


(check-equal? (test-gen-s (gen-integer) 100)
              #t)

(check-equal? (test-gen-s (gen-positive) 100)
              #t)

(check-equal? (test-gen-s (gen-between/c 0 100) 100)
              #t)

(check-equal? (test-gen (gen--> integer?) test-gen-->0.1 100)
              #t)
(check-equal? (test-gen (gen--> integer? integer?) test-gen-->0.2 100)
              #t)
(check-equal? (test-gen (gen--> integer? positive? integer?) test-gen-->0.3 100)
              #t)
(check-equal? (test-gen (gen--> (between/c 0 10) (between/c 0 10)) test-gen-->0.4 100)
              #t)