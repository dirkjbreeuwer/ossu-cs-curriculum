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

### An example

```Lisp
;; Data Analysis & Definitions:
(define-struct student (last first teacher))
;; A student is a structure: (make-student l f t) where l, f, and t are symbols.

;; Contract: subst-teacher : student symbol -> student

;; Purpose: to create a student structure with a new
;; teacher name if the teacher’s name matches 'Fritz

;; Examples:
(subst-teacher (make-student 'Find 'Matthew 'Fritz) 'Elise)
;; => (make-student 'Find 'Matthew 'Elise)
(subst-teacher (make-student 'Find 'Matthew 'Amanda) 'Elise)
;; => (make-student 'Find 'Matthew 'Amanda)

;; Template:
(define (process-student a-student a-teacher)
  ... (student-last a-student)
      (student-first a-student)
      (student-teacher a-student) ...)

;; Definition:
(define (subst-teacher a-student a-teacher)
  (cond
    [(symbol=? (student-teacher a-student) 'Fritz)
     (make-student (student-last a-student)
                   (student-first a-student)
                   a-teacher)]
    [else a-student]))

;; Tests:
(subst-teacher (make-student 'Find 'Matthew 'Fritz) 'Elise)
;; expected value:
;; (make-student 'Find 'Matthew 'Elise)

(subst-teacher (make-student 'Find 'Matthew 'Amanda) 'Elise)
;; expected value:
;; (make-student 'Find 'Matthew 'Amanda)

```
### Key activities for designing a function for commpound data

| Phase           | Goal                                                  | Activity                                                                                     |
|-----------------|-------------------------------------------------------|----------------------------------------------------------------------------------------------|
| Data Analysis and Design | to formulate a data definition                        | determine how many pieces of data describe the “interesting” aspects of the objects mentioned in the problem statement • add a structure definition and a data definition (for each class of problem object) |
| Contract Purpose and Header | to name the function; to specify its classes of input data and its class of output data; to describe its purpose; to formulate a header | name the function, the classes of input data, the class of output data, and specify its purpose: ;; name : in1 in2 ... -> out ;; to compute ... from x1 ... (define (name x1 x2 ...) ...) |
| Examples        | to characterize the input-output relationship via examples | search the problem statement for examples • work through the examples • validate the results, if possible • make up examples                          |
| Template        | to formulate an outline                                | for those parameters that stand for compound values, annotate the body with selector expressions • if the function is conditional, annotate all appropriate branches               |
| Body            | to define the function                                 | develop a Scheme expression that uses Scheme’s primitive operations, other functions, selector expressions, and the variables                            |
| Test            | to discover mistakes (“typos” and logic)               | apply the function to the inputs of the examples • check that the outputs are as predicted                                                           |
# Mixed data 

## Desgining functions for mixed data

Some functions must operate of different data types. These functions must employ a different method to operate on each data type. We usually use **cond** expressions plus PREDICATES such as *number?*, *boolean?*, *symbol?*, *struct?* to define how to operate on each data type. 

Example

```Lisp
(define (distance-to-0 a-pixel)
  (cond
    [(number? a-pixel) ... ]
    [(posn? a-pixel) ...]))
```

Since each possible input is a structure, we can also add two selector expression to each cond cluase. 

Example

```Lisp
;; Data Definition:
(define-struct circle (center radius))
(define-struct square (nw length))
;; A shape is either
;; 1. a structure: (make-circle p s)
;;    where p is a posn, s a number;
;; 2. a structure: (make-square p s)
;;    where p is a posn, s a number.

;; Contract, Purpose, Header:
;; perimeter : shape -> number
;; to compute the perimeter of a-shape

;; Examples: see tests

;; Template:
(define (perimeter a-shape)
  (cond
    [(square? a-shape)
     ... (square-nw a-shape) ... (square-length a-shape) ...]
    [(circle? a-shape)
     ... (circle-center a-shape) ... (circle-radius a-shape) ...]))

;; Definition:
(define (perimeter a-shape)
  (cond
    [(circle? a-shape)
     (* (2 (circle-radius a-shape)) pi)]
    [(square? a-shape)
     (* (square-length a-shape) 4)]))

;; Tests: (same as examples)
(= (perimeter (make-square ... 3)) 12)
(= (perimeter (make-square ... 1)) (* 2 pi))
(= (perimeter (make-circle ... 1)) (* 2 pi))

```

### Key activities for designing a function with mixed data

| Phase                | Goal                                          | Activity                                                                                                                                                         |
|----------------------|-----------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Data Analysis and Design | to formulate a data definition                 | determine how many distinct classes of "objects" make up the classes of problem data • enumerate the alternatives in a data definition • formulate a data definition for each alternative, if it is a form of compound data |
| Contract Purpose and Header | to name the function; to specify its classes of input data and its class of output data; to describe its purpose; to formulate a header | name the function, the classes of input data, the class of output data, and specify its purpose: `;; name : in1 in2 ... -> out ;; to compute ... from x1 ... (define (name x1 x2 ...) ...)` |
| Examples             | to characterize the input-output relationship via examples | create examples of the input-output relationship • make sure there is at least one example per subclass                                                           |
| Template             | to formulate an outline                       | introduce a `cond`-expression with one clause per subclass • formulate a condition for each case, using built-in and predefined predicates                                      |
| Body                 | to define the function                        | develop a Scheme expression for each `cond`-line (an answer), assuming that the condition holds                                                                   |
| Test                 | to discover mistakes (“typos” and logic)      | apply the function to the inputs of the examples • check that the outputs are as predicted                                                                         |
