# Mutual reference

Mutual reference describes classes of data that are interrelated, that is they not only refer to themselves but also refer to other data definitions. 

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
## How to design functions for mutual reference

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

Certainly! Let's continue with the section on how to design functions for mutually referential data definitions.

---


To complete the `blue-eyed-descendant?` function, we need to ensure it correctly checks both the parent and all of its descendants for the "blue" eye color. The key idea here is to use mutual recursion between the functions handling the `parent` and the `ListOfChildren`.

Here’s how we can do that:

1. **Define the function for the parent structure:** This function should check if the parent has blue eyes, and if not, delegate the check to its children.
2. **Define the function for the list of children:** This function should check each child in the list. If any child or its descendants have blue eyes, it should return `true`.

Let's continue from where we left off:

```lisp
;; Function to check if a parent or any of its descendants have blue eyes
(define (blue-eyed-descendant? p)
  (cond
    ;; Check if the parent has blue eyes
    [(string=? (parent-eyes p) "blue") true]
    ;; If not, check the list of children
    [else (blue-eyed-children (parent-loc p))]))

;; Function to check if any child in the list of children has blue eyes
(define (blue-eyed-children loc)
  (cond
    ;; An empty list means no children, hence return false
    [(empty? loc) false]
    ;; Otherwise, check the first child and recursively check the rest
    [else (or (blue-eyed-descendant? (first loc))
              (blue-eyed-children (rest loc)))]))
```

### Explanation

- **`blue-eyed-descendant?` function:**
  - It first checks if the current parent (`p`) has blue eyes. If true, it returns `true`.
  - If the parent does not have blue eyes, it calls `blue-eyed-children` on the parent's list of children (`parent-loc p`).

- **`blue-eyed-children` function:**
  - If the list of children (`loc`) is empty, it returns `false` because there are no children to check.
  - Otherwise, it checks if the first child in the list has blue eyes (by calling `blue-eyed-descendant?` on the first child). If true, it returns `true`.
  - If the first child does not have blue eyes, it recursively checks the rest of the children (`(rest loc)`).

### Testing the Function

Let’s test the function using the family tree defined in the notes:

```lisp
(check-expect (blue-eyed-descendant? Gustav) false)
(check-expect (blue-eyed-descendant? Eva) true)
(check-expect (blue-eyed-descendant? Fred) false)
(check-expect (blue-eyed-descendant? Carl) true)
(check-expect (blue-eyed-descendant? Bettina) true)
```

- `Gustav` does not have blue eyes and has no children, so the result is `false`.
- `Eva` has blue eyes, so the result is `true`.
- `Fred` does not have blue eyes and his children (`Gustav`) also do not have blue eyes, so the result is `false`.
- `Carl` does not have blue eyes, but his children (`Eva` and `Fred`) need to be checked. `Eva` has blue eyes, so the result is `true`.
- `Bettina` does not have blue eyes, but her children (`Eva` and `Fred`) need to be checked. `Eva` has blue eyes, so the result is `true`.

This completes the design and implementation of the `blue-eyed-descendant?` function. We can now use this function to check for the presence of blue-eyed descendants in any arbitrary arity tree structure representing a family.

### Summary

Mutual reference in data definitions allows for the creation of interrelated data structures, such as arbitrary arity trees. When designing functions for such data structures, we use mutual recursion to handle the interdependencies between the data definitions. This ensures that the functions can traverse and operate on the entire structure, including both the primary data and its associated references.

---