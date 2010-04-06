(module contract-gen scheme
  
  (require (planet schematics/schemeunit:3:4))
  
  (define h (make-hash))
  
  (define (gen-integer)
    (λ ()
      (- 50 (random 100))))
  
  (hash-set! h integer? (gen-integer))
  
  (define (gen-positive)
    (λ ()
      (+ (abs ((gen-integer))) 1)))
  
  (hash-set! h positive? (gen-positive))
  
  (define (gen-between/c n m)
    (λ ()
      (+ (* (- m n) (random)) n)))
  
  (hash-set! h (between/c 0 10) (gen-between/c 0 10))
  
  (define (gen contract)
    (let ([g (hash-ref h contract #f)])
      (if g
          g
          (error "Can not generate value for contract ~a" contract))))
  
 
  
  (define (test-gen-->0.1)
    0)
  (define (test-gen-->0.2 an-integer)
    0)
  (define (test-gen-->0.3 an-integer a-positive)
    0)
  (define (test-gen-->0.4 a-between/c-0-10)
    a-between/c-0-10)
  
  (provide/contract
   [gen-integer (-> (-> integer?))]
   [gen-positive (-> (-> positive?))]
   [gen-between/c (->d
                   ([n integer?]
                    [m (and/c integer? (>=/c n))]) 
                   ()
                   [result (-> (between/c n m))])]
   [test-gen-->0.1 (-> any)]
   [test-gen-->0.2 (-> integer? any)]
   [test-gen-->0.3 (-> integer? positive? any)]
   [test-gen-->0.4 (-> (between/c 0 10) (between/c 0 10))]
   )
  
  (provide gen-->)
  
  
  
  (define (gen--> . args)
    (let ([f-args-c (reverse (rest (reverse args)))]
          [return-value-c (first (reverse args))])
      (let ([f-args-gen (map gen f-args-c)])
        (λ ()
          ;          (length f-args-gen)))))
          (map (λ (x)
                 (apply x (list)))
               f-args-gen)))))
  
  
  
  ;;(test-gen between/c 10 (λ ()
  ;;                         (test-fun ((gen between/c) 0 10))))
  
  
  )