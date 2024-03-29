;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname space-invaders) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(require 2htdp/universe)

;; Space invaders

;; =================
;; Constants:


(define ALIEN-IMG
  (overlay/xy (ellipse 10 15 "outline" "blue")              ;cockpit cover
              -5 6
              (ellipse 20 10 "solid"   "blue")))            ;saucer

(define SHIP-IMG
  (overlay/xy (overlay (ellipse 28 8 "solid" "black")       ;tread center
                       (ellipse 30 10 "solid" "green"))     ;tread outline
              5 -14
              (above (rectangle 5 10 "solid" "black")       ;gun
                     (rectangle 20 10 "solid" "black"))))   ;main body

(define SHIP-HEIGHT/2 (/ (image-height SHIP-IMG) 2))

(define MISSILE-IMG (ellipse 5 15 "solid" "red"))

(define SHIP-SPEED 5)
(define MISSILE-SPEED 5)
(define ALIEN-SPEED 3)

(define MTS-HEIGHT 400)
(define MTS-WIDTH 400)

(define MTS (empty-scene MTS-HEIGHT MTS-WIDTH))


;; =================
;; Data definitions:


;; Game is (make-game  (listof Alien) (listof Missile) Ship)
;; interp. the current state of a space invaders game
;;         with the current invaders, missiles and tank position
(define-struct game (alien missiles ship))

#;
(define (fn-for-game s)
  (... (fn-for-loinvader (game-invaders s))
       (fn-for-lom (game-missiles s))
       (fn-for-tank (game-tank s))))



;; Ship is (make-ship Number Integer[-1, 1])
;; interp. the ship location is x, HEIGHT - ship-HEIGHT in screen coordinates
;;         the ship moves ship-SPEED pixels per clock tick left if dir -1, right if dir 1
(define-struct ship (x dx))

(define S0 (make-ship (/ MTS-WIDTH 2) 1))   ;center going right
(define S1 (make-ship 50 1))            ;going right
(define S2 (make-ship 50 -1))           ;going left

#;
(define (fn-for-ship s)
  (... (ship-x s) (ship-dx s)))


;; Missile is (make-missile Number Number)
;; interp. a missile at position x, y
(define-struct missile (x y))

(define MISSILE-1 (make-missile (/ MTS-HEIGHT 2) (/ MTS-WIDTH 2))) ; Missile in the middle of the MTS

#;
(define (fn-for-missile s)
  (... (missile-x m)     ;Number
       (missile-y m)))   ;Number
;; Template rules used:
;;  - compound: 2 fields


(define-struct alien (x y))
;; Missile is (make-missile Number Number)
;; interp. a missile at position x, y

(define ALIEN-1 (make-alien (- MTS-HEIGHT 100) (/ MTS-WIDTH 2))) ; Missile in the middle of the MTS

#;
(define (fn-for-alien s)
  (... (alien-x a)     ;Number
       (alien-y a)))   ;Number
;; Template rules used:
;;  - compound: 2 fields


; ListOfAlien is one of:
;;  - empty
;;  - (cons Alien ListOfAlien)
;; interp. a list of Alien
(define LOA1 empty)
(define LOA2 (cons (make-alien (- MTS-HEIGHT 100) (/ MTS-WIDTH 2)) (cons (make-alien (- MTS-HEIGHT 200) (/ MTS-WIDTH 4)) empty)))
#;
(define (fn-for-loa loa)
  (cond [(empty? loa) (...)]
        [else
         (... (fn-for-alien (first loa))
              (fn-for-loa (rest loa)))]))

;; Template rules used:
;;  - one of: 2 cases
;;  - atomic distinct: empty
;;  - compound: (cons Alien ListOfAlien)
;;  - reference: (first loa) is Alien
;;  - self-reference: (rest loa) is ListOfAlien


; ListOfMissile is one of:
;;  - empty
;;  - (cons Missile ListOfMissile)
;; interp. a list of Missile
(define LOM1 empty)
(define LOM2 (cons (make-missile (- MTS-HEIGHT 100) (/ MTS-WIDTH 2)) (cons (make-missile (- MTS-HEIGHT 200) (/ MTS-WIDTH 4)) empty)))
#;
(define (fn-for-lom lom)
  (cond [(empty? lom) (...)]
        [else
         (... (fn-for-missile (first lom))
              (fn-for-lom (rest lom)))]))

;; Template rules used:
;;  - one of: 2 cases
;;  - atomic distinct: empty
;;  - compound: (cons Alien ListOfAlien)
;;  - reference: (first loa) is Alien
;;  - self-reference: (rest loa) is ListOfAlien


;; =================
;; Functions:

;; WS -> WS
;; start the world with (main 0)
;; 
(define (main ws)
  (big-bang ws                   ; WS
            ;;(on-tick   tock)     ; WS -> WS
            (to-draw   render-ship-on)   ; WS -> Image
           ;; (stop-when ...)      ; WS -> Boolean
            (on-key    handle-key)))    ; WS KeyEvent -> WS

;; WS -> WS
;; produce the next ...
;; !!!
(define (tock ws) ...)

;; Ship -> Ship
;; move the ship on the x axis towards the direction at ship-speed

(check-expect (move-ship (make-ship 5 0) -1) (make-ship (+ 5 (* -1 SHIP-SPEED)) 0))
(check-expect (move-ship (make-ship 5 0) 1) (make-ship (+ 5 (* 1 SHIP-SPEED)) 0))

; (define (move-ship s direction) (make-ship 0 0)) ; stub

(define (move-ship t)
  (cond[(> (ship-x t) MTS-WIDTH)
        (make-ship MTS-WIDTH 0)]
       [(< (ship-x t) 0)
        (make-ship 0 0)]
       [else
        (make-ship (+ (ship-x t) (* (ship-dx t) SHIP-SPEED)) (ship-dx t))]))

;; Ship -> Ship
;; move the ship with keyboard

(define (handle-key s ke)
  (cond [(key=? ke "left") (move-ship -1)]
        [(key=? ke "right") (move-ship 1)]
        [else 
         s]))




;; Ship -> Image
;; produce image with CAT-IMG placed on MTS at proper x, y position
;; !!!
(check-expect (render-ship-on (make-ship (* MTS-WIDTH 0.5) (* MTS-HEIGHT 0.98))) (place-image SHIP-IMG (* MTS-WIDTH 0.5) (* MTS-HEIGHT 0.98) MTS)) ; middle
(check-expect (render-ship-on (make-ship (* MTS-WIDTH 0) (* MTS-HEIGHT 0.98))) (place-image SHIP-IMG (* MTS-WIDTH 0) (* MTS-HEIGHT 0.98) MTS)) ; left
(check-expect (render-ship-on (make-ship (* MTS-WIDTH 1) (* MTS-HEIGHT 0.98))) (place-image SHIP-IMG (* MTS-WIDTH 1) (* MTS-HEIGHT 0.98) MTS)) ; right


;(define (render-ship s img) MTS); stub

(define (render-ship-on s)
  (place-image SHIP-IMG (ship-x s) (* MTS-HEIGHT 0.98) MTS))


;; Image -> Image
;; produce word state

(define (render b) MTS) ; stub



