# How To Design Data (HTDD)

Data definitions are a driving element in the design recipes.

A data definition establishes the represent/interpret relationship between information and data:

* Information in the program's domain is represented by data in the program.
* Data in the program can be interpreted as information in the program's domain.

A data definition must describe how to form (or make) data that satisfies the data definition and also how to tell whether a data value satisfies the data definition. It must also describe how to represent information in the program's domain as data and interpret a data value as information.

Once that is done, a data definition consists of four or five elements:

1. A possible structure definition (only when using compound data)
2. A type comment that defines a new type name and describes how to form data of that type.
3. An interpretation that describes the correspondence between information and data.
4. One or more examples of the data.
5. A template for a 1 argument function operating on data of this type.

## Simple atomic data

```Lisp
;; Time is Natural
;; interp. number of clock ticks since start of game

(define START-TIME 0)
(define OLD-TIME 1000)

#;
(define (fn-for-time t)
  (... t))

;; Template rules used:
;;  - atomic non-distinct: Natural
```

## Intervals

```Lisp
;; Countdown is Integer[0, 10]
;; interp. the number of seconds remaining to liftoff
(define C1 10)  ; start
(define C2 5)   ; middle
(define C3 0)   ; end
 
#;
(define (fn-for-countdown cd)
  (... cd))

;; Template rules used:
;;  - atomic non-distinct: Integer[0, 10]
```

## Enumerations

```Lisp
;; LightState is one of:
;;  - "red"
;;  - "yellow"
;;  - "green"
;; interp. the color of a traffic light

;; <examples are redundant for enumerations>
 
#;
(define (fn-for-light-state ls)
  (cond [(string=? "red" ls) (...)]
        [(string=? "yellow" ls) (...)]
        [(string=? "green" ls) (...)]))
;; Template rules used:
;;  - one of: 3 cases
;;  - atomic distinct: "red"
;;  - atomic distinct: "yellow"
;;  - atomic distinct: "green"
```

## Itemizations

```Lisp
;; Bird is one of:
;;  - false
;;  - Number
;; interp. false means no bird, number is x position of bird

(define B1 false)
(define B2 3) 

#;
(define (fn-for-bird b)
  (cond [(false? b) (...)]
        [(number? b) (... b)]))
;; Template rules used:
;;  - one of: 2 cases
;;  - atomic distinct: false
;;  - atomic non-distinct: Number
```

## Comound data (structures)

```Lisp
(define-struct ball (x y))
;; Ball is (make-ball Number Number)
;; interp. a ball at position x, y 

(define BALL-1 (make-ball 6 10))

#;
(define (fn-for-ball b)
  (... (ball-x b)     ;Number
       (ball-y b)))   ;Number
;; Template rules used:
;;  - compound: 2 fields
```

## Reference

```Lisp
---assume Ball is as defined above---

(define-struct game (ball score))
;; Game is (make-game Ball Number) 

;; interp. the current ball and score of the game

(define GAME-1 (make-game (make-ball 1 5) 2))

#;
(define (fn-for-game g)
  (... (fn-for-ball (game-ball g))
       (game-score g)))      ;Number
;; Template rules used:
;;  - compound: 2 fields
;;  - reference: ball field is Ball
```

## Self reference

```Lisp
;; ListOfString is one of:
;;  - empty
;;  - (cons String ListOfString)
;; interp. a list of strings

(define LOS-1 empty)
(define LOS-2 (cons "a" empty))
(define LOS-3 (cons "b" (cons "c" empty)))

#;
(define (fn-for-los los)
  (cond [(empty? los) (...)]                   ;BASE CASE
        [else (... (first los)                 ;String
                   (fn-for-los (rest los)))])) ;NATURAL RECURSION
;;             /
;;            /
;;       COMBINATION
;; Template rules used:
;;  - one of: 2 cases
;;  - atomic distinct: empty
;;  - compound: (cons String ListOfString)
;;  - self-reference: (rest los) is ListOfString
```

## Mutual reference

```Lisp
(define-struct dot (x y))
;; Dot is (make-dot Integer Integer)
;; interp. A dot on the screen, w/ x and y coordinates.
(define D1 (make-dot 10 30))
#;
(define (fn-for-dot d)
  (... (dot-x d)   ;Integer
       (dot-y d))) ;Integer
;; Template rules used:
;;  - compound: 2 fields

;; ListOfDot is one of:
;;  - empty
;;  - (cons Dot ListOfDot)
;; interp. a list of Dot
(define LOD1 empty)
(define LOD2 (cons (make-dot 10 20) (cons (make-dot 3 6) empty)))
#;
(define (fn-for-lod lod)
  (cond [(empty? lod) (...)]
        [else
         (... (fn-for-dot (first lod))
              (fn-for-lod (rest lod)))]))

;; Template rules used:
;;  - one of: 2 cases
;;  - atomic distinct: empty
;;  - compound: (cons Dot ListOfDot)
;;  - reference: (first lod) is Dot 
;;  - self-reference: (rest lod) is ListOfDot

```

