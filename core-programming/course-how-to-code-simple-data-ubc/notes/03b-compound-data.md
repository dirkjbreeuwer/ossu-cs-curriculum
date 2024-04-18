# Compound data

It is often that functions consume more than a single measurement (number), a single switch position (bollean), or a single name (symbol). Instead they almost always process a piece of data that represents and object with many properties.

## Structures

**Definition:** Structures are compound data types that group related fields, allowing diverse data to be bundled together logically. Structures allow us to refer to several pieces of information as if they were one, in short they "compound" several pieces of data into one single piece. 

### Difference Between Structures and Objects in OOP:

**Structures:** Primarily used for grouping data, structures in functional languages are immutable by default and separate from functions that manipulate them.

**Objects:** In object-oriented programming (OOP), objects combine data and functions (methods) that act on the data, typically allow mutable state, and may use features like inheritance and polymorphism


### Template for functions that operate in structures

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

## Structure definitions

```Lisp
(define-struct posn (x y))
```

When DrRacket evaluates this structure defintion, it creates three operations for us:
1. make-posn, the CONSTRUCTOR, which creates posn structures
2. posn-x, a SELECTOR, whcih extracts the x coordinate
3. posn-y, a SELECTOR, which extracfts the y coordinate

## Data definitions

A data definition helps establish and formalize the structure and behavior of data in a program. It involves specifying:

* The structure type - This defines what kind of data compound the structure is (e.g., a structure representing a movie, a book, etc.).
* The fields within the structure - These are the individual components of the structure, each of which has a type (e.g., strings, numbers) and a specific role (e.g., title, author).
* Constructors and selectors - These are functions used to create instances of the structure and to access the fields within those instances, respectively.
* Constraints and relationships - Any invariants or specific relationships between fields that must always be true (e.g., a number field that must always be positive).
* Interpretations - Descriptions of what the data represents in the real world or within the context of the application.

