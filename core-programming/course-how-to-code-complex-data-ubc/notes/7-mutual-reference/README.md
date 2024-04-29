# Mutual reference

Mutual reference describes classes of data that are interrelated, that is the not only refer to themselves but also refer to other data definitions. 

One example of interrelated data are arbitrary arity trees. 

Arbitrary arity trees, also known as n-ary trees, are trees where each node can have a variable number of children, as opposed to binary trees where each node has at most two children. In these trees, nodes can have anywhere from zero to an unlimited number of children, providing a flexible structure for representing hierarchical data.

## Definition
An arbitrary arity tree is a data structure consisting of nodes where:

* Root Node: The topmost node with no parent.
* Child Nodes: Nodes connected to a given node. Each node can have any number of child nodes.
* Leaf Nodes: Nodes with no children.
* Internal Nodes: Nodes that have at least one child.

## Motivation
Arbitrary arity trees are used in a variety of applications due to their flexibility and adaptability in representing complex data structures. They are suitable for modeling data with natural hierarchies, such as organizational structures, file systems, or family trees.

## How to design data for mutual reference

Since the two data definitions must refer to eachother, they are only meaninful if they are introduced together.

```Lisp
;; A parent is a structure:
(define-struct parent (loc name year eyes))
;; where loc is a ListOfChildren, n and e are symbols, and d is a number

;;A ListOfChildren is either:
;; - Empty
;; - (cons p loc) where p is a parent and loc is a list of children

```

When two or more data definitions refer to each other, they are said to be **mutually recursive** or **mutually referential**. 

To define the oldest generation in a family tree, we begin with the youngest generation and work our way up.

```Lisp

; Youngest Generation
(define Gustav (make-parent empty "Gustav" 1990 "blue"))

(define Fred&Eva (list Gustav))

; Middle Generation
(define Eva (make-parent Fred&Eva "Eva" 1966 "blue"))
(define Fred (make-parent Fred&Eva "Fred" 1988 "yellow"))

(define Carl&Bettina (list Eva))

; Oldest Generation
(define Carl (make-parent Carl&Bettina "Carl" 1896 "green"))
(define Bettina (make-parent Carl&Bettina  "Bettina" 1926 "green"))
```

If we want to create a function that operates in a mutually-referential data definition. We begin operating on the main class, which in this case is a parent.

A parent is a structure (make-parent loc name year eyes), so we know we have to include selector expressions for the four fields.

```Lisp
;; blue-eyed-descendant? Parent -> Boolean
;; to determine whether a parent or any of its descendants
;; have blue in the eyes field
(check-expect (blue-eyed-descendant? Gustav) false)
(check-expect (blue-eyed-descendant? Eva) true)

;(define (blue-eyed-descendant? p) false ; stub

(define (blue-eye-descendant? p)
  ...
  (parent-name p)  ; String
  (parent-year p) ; Number
  (parent-eyes p) ; String
  (parent-loc  p) ; ListOfChildren
  )
```

This template shows us that parent-eyes is available and we can be checked:

```Lisp
(define (blue-eye-descendant? p)
  (cond
    [(string=? (parent-eyes p) "blue") true]
    [else
     (parent-name p)  ; String
     (parent-year p) ; Number
     (parent-loc p) ; ListOfChildren
     ]))
```

If the eye in the parent structure is not true, then we must continue looking in the children structure, since we need to operate on a ListOfChildren we create another function:

```Lisp


(define (blue-eyed-children loc)
  (cond
    [(empty? loc) false]
    [else
     (cond
       [(blue-eyed-descendant? (first loc)) true]
       [else (blue-eyed-children (rest loc))])
     ]
    )

  )


```
