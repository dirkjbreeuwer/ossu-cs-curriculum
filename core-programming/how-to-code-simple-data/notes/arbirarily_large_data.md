# Self reference

Types of data:

* `Atomic (fixed size data)`: Numbers, strings, images.
* `Arbitrarily large data`: Undetermined number of pieces of information that must be processed as one piece of data.

`Self-reference`: When a type comment refers to itself. For a self-referential data definition to be valid, it must satisfy two conditions. First, it must contain at least two clauses. Second, at least one of the clauses must not refer back to the class of data that is being defined.

## Template for Lists

```Lisp
; A List-of-Number is one of: 
; – empty
; – (cons Number List-of-number)
; interpretation a list of numbers
```

## Why use this template? 

This template gives us a step by step definition of how a function that operates in this data type should behave:

```Lisp
(define (fn-for-lon lon)
  (cond [(empty? lon) (...)]
        [else 
        (... (first lon)
        (fn-fn-lon (rest lon))
        )]
  ))

```

empty = `empty` tells our function exactly what to do when the list is empty. This is usually referred as the base case. Usual values that can produce include `empty`, `zero`, `one`.

number = `first lon` and tells the function exactly what the contribution of the first element should be. In many cases the contribuition of the first is itself, or 1.


| function | base | contribution of first | combination | 
| --- | --- | --- | --- |
| sum | 0 | itself | + |
| count | 0 | 1 | + |
| contains-ubc? | false | (?string=> x "UBC") | (if y true nr) |


## What is empty, what is cons?

`Empty` is a kind of atomic value that returns true precisely when applied to an empty list.

`Cons` is a constructor for lists, it accepts two arguments: x which can be any type, and y which is a list.

```Lisp
(cons x y) → list?
  x : any/c
  y : list?
```

`empty`  a special value to represent the empty list

`empty?` a predicate to recognize an empty list and nothing else

`cons` a checked constructor to create two-field instances

`first` selector to extract the last item added

`rest` selector to extract the extended list

`cons?` predicate to recognize instances of cons
