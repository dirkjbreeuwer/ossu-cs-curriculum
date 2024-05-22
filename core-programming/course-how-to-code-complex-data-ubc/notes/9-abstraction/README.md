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

