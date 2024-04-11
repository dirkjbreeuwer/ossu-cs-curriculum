# How to design functions recipe

The HtDF recipe consists of the following steps:

1. Signature (contract), purpose and stub.
2. Define examples, wrap each example in a check-expect (a test)
3. Template and inventory.
4. Code the function body.
5. Test and debug until correct


## Example

```lisp
;; Contract: double: Number -> Number
;; Purpose: produces n times 2

;; Examples:
(check-expect (double 0) (* 0 2)) ; these are the examples and tests
(check-expect (double 1) (* 1 2))
(check-expect (double 3) (* 3 2))

;; Definition 
;; (define (double n)  0)  ; this is the stub

;; (define (double n)     ; this is the template
;;  (... n))

(define (double n) ; this is the main function body
  (* n 2))
```