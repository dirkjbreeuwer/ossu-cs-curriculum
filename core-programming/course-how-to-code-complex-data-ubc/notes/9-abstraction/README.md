# Abstraction

When our data definitions and/or function definitions look alike (i.e. they only change in one or two places) we can use abstraction 

## Closures

A closure is a function defined within another function that retains access to the outer function’s environment, even after the outer function has finished executing. This allows the inner function to use the variables from the outer function anytime it is called.

```Lisp
; Example of using the function
(check-expect (wider-than-only 40 LOI1) (list I4 I5))  ; Expected result with images I4, I5 being wider than 40 units

; Function to filter images by width
(define (wider-than-only w loi)
  (local [(define (wider-than? i)
            (> (image-width i) w))]  ; Checks if image width is greater than w
    (filter wider-than? loi)))      ; Filters the list of images using wider-than?
```

## Abstract fold functions 

An abstract fold function, often simply called a fold, is a fundamental concept in functional programming that provides a powerful way to process and combine all the elements of a list (or other data structure) into a single result. 

```Lisp
(@signature (X Y -> Y) Y (listof X) -> Y)
;; (foldr f base (list x-1 ... x-n)) = (f x-1 ... (f x-n base))
(define (foldr f base lox) ...)
```

* (X Y -> Y): This represents the type of the function that is passed to the fold function. This function takes two arguments: the first of type X, which corresponds to the type of elements in the list, and the second of type Y, which is the type of the accumulator. The function returns a value of type Y. This aligns with the common pattern in fold functions where an operation is applied between an accumulator and each element of the list. 

* Y: This is the type of the initial value of the accumulator. It's also the type of the result produced by the fold function. The initial accumulator is crucial as it acts as the base value from which the folding operation begins.

* (listof X): This specifies that the function takes a list of elements where each element is of type X. This is the list that will be processed by the fold function.

* -> Y: This indicates the return type of the entire fold function, which is Y. After processing all elements in the list through the provided function, the final result of the fold function is a single value of type Y.

The signature (X Y -> Y) Y (listof X) -> Y for a fold function where the type of the elements in the list (X) and the type of the accumulator (Y) are different is very powerful because it enables a wide range of applications beyond simple aggregation tasks. 

We can create an abstract fold function using the template for procesing lists:

```Lisp
;; ListOfX is one of:
;; - empty
;; - (cons X ListOfX)
;; interp. a list of X

;; and the template for (listof X) is:

;#
(define (fn-for-lox lox)
  (cond [(empty? lox) (...)]
        [else
         (... (first lox)
              (fn-for-lox (rest lox)))]))

(define (fold fn b lox)
  (cond [(empty? lox) b]
        [else
         (fn (first lox)
              (fold fn b (rest lox)))]))
```

All we had to do is replace the two sets of dots with parameters. 

* First we replace the base case result with a parameter called b. 
* Next we replace the function that takes the first of the list and combines it with the results of the natural recursion with fn. 
* Finally we also rename the recursion and replace the parameters in the natural recurssion.


## Process for designing an abstract fold function

Step 1: Begin with the function templates 

```Lisp
;; =================
;; Data definitions:

(define-struct dir (name sub-dirs images))
;; Dir is (make-dir String ListOfDir ListOfImage)
;; interp. An directory in the organizer, with a name, a list
;;         of sub-dirs and a list of images.

(define (fn-for-dir d)
  (...
   (dir-name d) ; String
   (fn-for-lod (dir-sub-dirs d)) ; ListOfDir
   (fn-for-loi (dir-images d))) ;ListOfImage
  )

;; ListOfDir is one of:
;;  - empty
;;  - (cons Dir ListOfDir)
;; interp. A list of directories, this represents the sub-directories of
;;         a directory.

(define (fn-for-lod lod)
  (cond
    [(empty? lod) ...]
    [else
     (...(fn-for-dir (first lod)) ; Dir
         (fn-for-lod (rest lod)))  ; ListOfDir
     ]))

;; ListOfImage is one of:
;;  - empty
;;  - (cons Image ListOfImage)
;; interp. a list of images, this represents the sub-images of a directory.
;; NOTE: Image is a primitive type, but ListOfImage is not.


(define (fn-for-loi loi)
  (cond
    [(empty? loi) ...]
    [else
     (... (first loi) ; Image
         (fn-for-loi (rest loi)))  ; ListOfImage
     ]))
```

Step 2: Combine them into one abstract function using local:

```
(define (fold-dir ... ... ... ... ... d)
  (local [
          (define (fn-for-dir d) ; Dir -> X
            (...
             (dir-name d) ; String
             (fn-for-lod (dir-sub-dirs d)) ; ListOfDir
             (fn-for-loi (dir-images d))) ;ListOfImage
            )
          (define (fn-for-lod lod) ; (list of dir) -> Y
            (cond
              [(empty? lod) ...]
              [else
               (... (fn-for-dir (first lod)) ; Dir
                  (fn-for-lod (rest lod)))  ; ListOfDir
               ]))
          
          (define (fn-for-loi loi) ; (list of image) -> Z
            (cond
              [(empty? loi) ...]
              [else
               (... (first loi) ; Image
                   (fn-for-loi (rest loi)))  ; ListOfImage
               ]))
          ]
    (fn-for-dir d)))
```

Step 3: Replace the combinatins and the base case templates

```
(define (fold-dir c1 c2 c3 b1 b2 d)
  (local [
          (define (fn-for-dir d) ; Dir -> X
            (c1
             (dir-name d) ; String
             (fn-for-lod (dir-sub-dirs d)) ; ListOfDir
             (fn-for-loi (dir-images d))) ;ListOfImage
            )
          (define (fn-for-lod lod) ; (list of dir) -> Y
            (cond
              [(empty? lod) b1]
              [else
               (c2 (fn-for-dir (first lod)) ; Dir
                  (fn-for-lod (rest lod)))  ; ListOfDir
               ]))
          
          (define (fn-for-loi loi) ; (list of image) -> Z
            (cond
              [(empty? loi) b2]
              [else
               (c3 (first loi) ; Image
                   (fn-for-loi (rest loi)))  ; ListOfImage
               ]))
          ]
    (fn-for-dir d)))

```

Step 4: Design the signature

```
;; (String Y Z -> X) (X Y -> Y) (Image Z -> Z) Y Z Dir -> X 
;; Process fold-dir

```

Step 5: Test the abstract fold function

```
(check-expect (local
                [
                 (define (c1 s rlod rloi) (+ rlod rloi))
                 (define (c2 rlod rdir) (+ rlod rdir))
                 (define (c3 i rloi) (+ 1 rloi))]
                (fold-dir c1 c2 c3 0 0 D6)) 3)
```