# Arbitrarily Large Data

Types of data:

* Atomic (fixed size data): Numbers, strings, images.
* Arbitrarily large data: Undetermined number of pieces of information that must be processed as one piece of data.

`Self-reference`: When a type comment refers to itself. For a self-referential data definition to be valid, it must satisfy two conditions. First, it must contain at least two clauses. Second, at least one of the clauses must not refer back to the class of data that is being defined. 

## Lists

```Lisp
; A List-of-names is one of: 
; – '()
; – (cons String List-of-names)
; interpretation a list of invitees, by last name
```

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
