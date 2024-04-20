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
