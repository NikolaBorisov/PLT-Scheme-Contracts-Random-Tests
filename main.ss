#lang scheme
(require (planet schematics/schemeunit:3:4))

(define h (make-hash))

(define gen-integer
  (λ ()
    (- 50 (random 100))))

(hash-set! h integer? gen-integer)

(define gen-positive
  (λ ()
    (abs (gen-integer))))

(hash-set! h positive? gen-positive)

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
(test-gen positive? 10)
