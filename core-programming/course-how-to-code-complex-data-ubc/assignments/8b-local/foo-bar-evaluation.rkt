;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname foo-bar-evaluation) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define (calculate-result number)
  (local [(define (add-multiple factor) (+ number factor))]
    (+ number (add-multiple (* 2 number)))))

(list (calculate-result 2) (calculate-result 3))

(list
 (local [(define (add-multiple factor) (+ 2 factor))]
    (+ 2 (add-multiple (* 2 2))))
 (calculate-result 3)
 )

(list
 (local [(define (add-multiple factor) (+ 2 factor))]
    (+ 2 (add-multiple 4)))
 (calculate-result 3)
 )

(list
 (local [(define (add-multiple factor) (+ 2 factor))]
    (+ 2 (+ 2 4)))
 (calculate-result 3)
 )

(list
    8
 (calculate-result 3)
 )

(list
    8
 (calculate-result 3)
 )