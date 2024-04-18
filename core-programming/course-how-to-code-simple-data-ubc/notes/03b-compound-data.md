# Compound data

## Structures

It is often that functions consume more than a single measurement (number), a single switch position (bollean), or a single name (symbol). Instead they almost always process a piece of data that represents and object with many properties.

**Definition:** Structures are compound data types that group related fields, allowing diverse data to be bundled together logically. Structures allow us to refer to several pieces of information as if they were one, in short they "compound" several pieces of data into one single piece. 

### Difference Between Structures and Objects in OOP:

**Structures:** Primarily used for grouping data, structures in functional languages are immutable by default and separate from functions that manipulate them.

**Objects:** In object-oriented programming (OOP), objects combine data and functions (methods) that act on the data, typically allow mutable state, and may use features like inheritance and polymorphism



```Lisp
(define-struct ball (x y))
;; Ball is (make-ball Number Number)
;; interp. a ball at position x, y 

(define BALL-1 (make-ball 6 10))

#;
(define (fn-for-ball b)
  (... (ball-x b)     ;Number
       (ball-y b)))   ;Number
;; Template rules used:
;;  - compound: 2 fields
```
