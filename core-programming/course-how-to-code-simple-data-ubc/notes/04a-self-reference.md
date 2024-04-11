
# Self-Reference

## Types of Data

- **Atomic (fixed size data):** Numbers, strings, images.
- **Arbitrarily large data:** Undetermined number of pieces of information that must be processed as one piece of data.

## Self-Reference

Self-reference occurs when a data definition refers to itself within its own definition. This pattern is especially useful in defining recursive data structures like lists, trees, and graphs. For a self-referential data definition to be both meaningful and useful, it must adhere to two critical conditions:

1. **Multiple Clauses:** The definition must include at least two clauses to support recursion. A clause typically represents a possible state or case for the data structure (e.g., an empty list vs. a list with elements).
2. **Non-Self-Referential Clause:** This acts as a base case to prevent infinite recursion, ensuring the structure is usable and operations on it can terminate.

## Template for Lists

```lisp
; A List-of-Number is one of: 
; – empty
; – (cons Number List-of-number)
; interpretation: a list of numbers
```

### Why Use This Template?

This template provides a step-by-step definition for functions operating on this data type:

```lisp
(define (fn-for-lon lon)
  (cond [(empty? lon) (...)]
        [else 
         (... (first lon)
              (fn-for-lon (rest lon)))]
  ))
```

- **empty:** Specifies the base case action when the list is empty. Common base cases include `empty`, `zero`, `one`.
- **number:** The `first lon` defines the contribution of the first element, often itself or 1.

### Function Table

| Function        | Base  | Contribution of First       | Combination                |
|-----------------|-------|-----------------------------|----------------------------|
| sum             | 0     | itself                      | +                          |
| count           | 0     | 1                           | +                          |
| contains-ubc?   | false | `(?string=> x "UBC")`       | `(if y true nr)`           |

## Concepts and Definitions

- **Empty:** A special value representing the empty list.
- **Empty?:** A predicate that returns true for an empty list and nothing else.
- **Cons:** A constructor for lists, taking two arguments: `x` (any type) and `y` (a list).
  
  ```lisp
  (cons x y) → list?
    x : any/c
    y : list?
  ```
- **Cons?:** A predicate to recognize instances of cons.
- **First:** A selector to extract the last item added.
- **Rest:** A selector to extract the extended list.

