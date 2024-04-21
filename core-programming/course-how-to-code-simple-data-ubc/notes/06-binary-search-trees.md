# Binary search tress (mutual referential data with structures)

A binary search tree (BST) is a data structure in which each node has at most two children, referred to as the left child and the right child. The nodes are arranged such that for any given node, the values in the left subtree are less than the node's value, and the values in the right subtree are greater than the node's value.

At each level: 
* all children in the left sub-tree have value less than root
* all children in the right sub-tree have value greater than root

## Data template in binary search trees
```Lisp
(define-struct node (key value left right))
;; A BST is one of:
;; - false (indicating no BST)
;; - (make-node Number String BST BST)  ; A node with a key, value, left and right child

;; Interpretation:
;; - 'empty' represents an empty BST
;; - `key` is the unique identifier for the node
;; - `value` is the value associated with the key
;; - `left` represents the left child (a BST)
;; - `right` represents the right child (a BST)

;; INVARIANT:
;; - The key of each node is greater than all keys in its left child BST
;; - The key of each node is less than all keys in its right child BST
;; - The same key must not appear more than once in the BST

;; EXAMPLES:

(define BST0 false) ;; no BST
(define BST1 (make-node 1 "abc" false false))  ;; A BST with one node
(define BST2 (make-node 5 "def" (make-node 1 "abc" false false) (make-node 8 "xyz" false false))) ;; A BST with three nodes

```

## Function template in binary search tress

```Lisp
;; Template for functions operating on a BST
(define (fn-for-bst bst)
  (cond
    [(empty? bst) (...)]  ; Handle the empty tree case
    [else
     (... (node-value bst)     ; Process the value of the node
          (fn-for-bst (node-left bst))   ; Recurse on the left subtree
          (fn-for-bst (node-right bst)))]))  ; Recurse on the right subtree
```

Template rules used: 

1. Recursive Structure: Since a BST is recursive, the template must account for each node's structure and its children (left and right subtrees).
2. Empty Tree Handling: The template includes a branch for handling the empty case (empty), as BSTs can be empty.
3. Node Processing: The template indicates where to process the value at the current node (node-value bst).
4. Recurse on Subtrees: The template demonstrates how to recurse on the left and right subtrees (node-left and node-right), maintaining the recursive structure of a BST.
