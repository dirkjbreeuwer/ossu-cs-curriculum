# Processing arbitrarily large data

## Lists

In Lisp, a list is a fundamental data structure that is either empty (known as the empty list and represented by () or nil) or a pair consisting of a first element (the head of the list) and another list (the tail of the list). Lists are typically constructed using cons cells, which are pairs that hold two values: the first element of the current list and a reference to the next cons cell in the sequence, or nil if it's the end of the list.

```Lisp
empty ; an empty list
(cons "Venus" empty) ; a list with one item
(cons "Venus" (cons "Earth" empty)) ; list with two items
```

The contract, purpose, hader and examples of a function that adds numbers in a list.

```Lisp
; A list-of-3-numbers is
;; (cons x (cons y (cons z empty)))
;; where x, y, and z are numbers

;; add-up-3: list-of-3-numbers -> number
;; to add up three numbers in list-of-3-numbers
;; Examples and tests
(check-expect (add-up-3 (cons 1 (cons 2 (cons 3 empty)))) 6)
; Stub
(define (add-up-3 a-list-of-3-numbers) ...)

```

### Data template for lists

```Lisp
; A list-of-symbols is one of: 
; – empty
; – (cons Number list-of-symbols)
; interpretation: a list of numbers
```

Normally, definitions in english explain a new idea in term of old, well-uinderstood concepts. This defintiion refers to itself. This type of defintioon is called [SELF-REFERENTIAL](./04a-self-reference.md) or RECURSIVE.

### Processing lists of arbitrary length

```Lisp
;; contains-car? : list-of-symbols -> boolean
;; to determine whether the symbol "car" occurs on a list-of-symbols
(define (contains-car? a-list-of-symbols) ...) ; stub

(check-expect (contains-car? (cons "truck" empty)) false)
(check-expect (contains-car? (cons "car" (cons "truck" empty))) true)

```

Based on the data template for lists we can then construct a function template to that handles an empty case and a list case

```Lisp
(define (contains-car? a-list-of-symbols)
  (cond
    [(empty? a-list-of-symbols) ...]
    [(cons? a-list-of-symbols) ...]))
```

We can also add selectors if any element of the clause is a [compound data](./03b-compound-data.md). In the case of a list, it is compound so we can add selectors *first* and *rest*.

```Lisp
(define (contains-car? a-list-of-symbols)
  (cond
    [(empty? a-list-of-symbols) ...]
    [else ... (first a-list-of-symbols) ... (rest a-list-of-symbols)...]))
```

