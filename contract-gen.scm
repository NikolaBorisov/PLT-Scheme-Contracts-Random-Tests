#lang scheme

(require (planet schematics/schemeunit:3:4))

;; for determinism during testing
(random-seed 0)

(define h (make-hash))


;; robby probably knows a better way to do this
(define-type Env-item
  [item (ct contract?)
        (exp symbol?)])

;; just a shorthand 
(define Env (listof Env-item?))


(define (gen-integer)
  (λ (depth env)
    (- 50 (random 100))))

(hash-set! h integer? (gen-integer))

(define (gen-positive)
  (λ (depth env)
    (+ (abs ((gen-integer) depth)) 1)))

(hash-set! h positive? (gen-positive))

(define (gen-between/c n m)
  (λ (depth env)
    (+ (* (- m n) (random)) n)))

(hash-set! h (between/c 0 10) (gen-between/c 0 10))

(define (gen contract)
  (let ([g (hash-ref h contract #f)])
    (if g
        g
        (error "Can not generate value for contract ~a" contract))))

(define (use-env cont env)
  (void))

(define (gen--> dom range)
  (λ (depth env)
    (let ([exp (use-env (dom . -> . range) env)])
      (cond
        [(not exp #f) exp]
        [else (λ (x)
      ((gen range) (- depth 1) (cons (item range 'x)
                                     env)))]))))

;; gen-listof : contract -> (depth -> (listof contract))
(define (gen-listof contr)
  (local ([define contr-gen (gen contr)]
          [define f (λ (depth env)
                      (cond [(<= depth 0) (list)]
                            [else (cons (contr-gen (- depth 1))
                                        (f (- depth 1)))]))])
    f))


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
 [gen-listof (->d ([element-contr contract?])
                  ()
                  [result (-> integer? (listof element-contr))])]
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

