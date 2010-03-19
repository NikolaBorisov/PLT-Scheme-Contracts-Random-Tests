#lang scheme
(require (planet schematics/schemeunit:3:4))

(define h (make-hash))

(define gen-integer
  (λ ()
    (random 100)))

(hash-set! h integer? gen-integer)

(define (gen contract)
  (let ([g (hash-ref h contract #f)])
    (if g
        (g)
        (error "Can not generate value for contract ~a" contract))))

(define (test-gen contract attempts)
  (if (<= attempts 0)
      #t
      (begin
        (check-equal? (contract (gen contract))
                      #t)
        (test-gen contract (- attempts 1)))))

(test-gen integer? 10)
