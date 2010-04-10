#lang scheme

(require (planet schematics/schemeunit:3:4))

(define h (make-hash))

(define (gen-integer)
  (λ (depth)
    (- 50 (random 100))))

(hash-set! h integer? (gen-integer))

(define (gen-positive)
  (λ (depth)
    (+ (abs ((gen-integer) depth)) 1)))

(hash-set! h positive? (gen-positive))

(define (gen-between/c n m)
  (λ (depth)
    (+ (* (- m n) (random)) n)))

(hash-set! h (between/c 0 10) (gen-between/c 0 10))

(define (gen contract)
  (let ([g (hash-ref h contract #f)])
    (if g
        g
        (error "Can not generate value for contract ~a" contract))))


(define (gen--> dom range)
  (λ (depth)
    (λ (x)
      ((gen range) (- depth 1)))))


(provide/contract
 [gen-integer (-> (-> integer? integer?))]
 [gen-positive (-> (-> integer? positive?))]
 [gen-between/c (->d
                 ([n integer?]
                  [m (and/c integer? (>=/c n))]) 
                 ()
                 [result (-> integer? (between/c n m))])]
 [gen--> (->d ([d contract?]
               [r contract?])
              ()
              [result (-> integer? (-> d r))])]
 )

(provide gen)




#|
(define (gen--> . args)
  (let ([f-args-c (reverse (rest (reverse args)))]
        [return-value-c (first (reverse args))])
    (let ([f-args-gen (map gen f-args-c)])
      (λ ()
        ;          (length f-args-gen)))))
        (map (λ (x)
               (apply x (list)))
             f-args-gen)))))

|#

