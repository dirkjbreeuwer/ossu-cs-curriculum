;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname space-invaders-v2) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/universe)
(require 2htdp/image)

;; Space Invaders


;; Constants:

(define WIDTH  300)
(define HEIGHT 500)

(define INVADER-X-SPEED 1.5)  ;speeds (not velocities) in pixels per tick
(define INVADER-Y-SPEED 1.5)
(define TANK-SPEED 2)
(define MISSILE-SPEED 10)

(define HIT-RANGE 10)

(define INVADE-RATE 2) ;increase this number to increase the number of invading...invaders

(define BACKGROUND (empty-scene WIDTH HEIGHT))
(define GAME-OVER (place-image (text "GAME-OVER" 45 "black") (/ WIDTH 2) (/ HEIGHT 2) BACKGROUND))

(define INVADER
  (overlay/xy (ellipse 10 15 "outline" "blue")              ;cockpit cover
              -5 6
              (ellipse 20 10 "solid"   "blue")))            ;saucer

(define TANK
  (overlay/xy (overlay (ellipse 28 8 "solid" "black")       ;tread center
                       (ellipse 30 10 "solid" "green"))     ;tread outline
              5 -14
              (above (rectangle 5 10 "solid" "black")       ;gun
                     (rectangle 20 10 "solid" "black"))))   ;main body

(define TANK-HEIGHT/2 (/ (image-height TANK) 2))

(define MISSILE (ellipse 5 15 "solid" "red"))



;; Data Definitions:

(define-struct game (invaders missiles t))
;; Game is (make-game  (listof Invader) (listof Missile) Tank)
;; interp. the current state of a space invaders game
;;         with the current invaders, missiles and tank position

;; Game constants defined below Missile data definition

#;
(define (fn-for-game s)
  (... (fn-for-loinvader (game-invaders s))
       (fn-for-lom (game-missiles s))
       (fn-for-tank (game-t s))))



(define-struct tank (x dx))
;; Tank is (make-tank Number Integer[-1, 1])
;; interp. the tank location is x, HEIGHT - TANK-HEIGHT in screen coordinates
;;         the tank moves TANK-SPEED pixels per clock tick left if dir -1, right if dir 1

(define T0 (make-tank (/ WIDTH 2) 1))   ;center going right
(define T1 (make-tank 50 1))            ;going right
(define T2 (make-tank 50 -1))           ;going left

#;
(define (fn-for-tank t)
  (... (tank-x t) (tank-dx t)))



(define-struct invader (x y dx))
;; Invader is (make-invader Number Number Number)
;; interp. the invader is at (x, y) in screen coordinates
;;         the invader along x by dx pixels per clock tick

(define I1 (make-invader 150 100 1))           ;not landed, moving right
(define I2 (make-invader 150 HEIGHT -1))       ;exactly landed, moving left
(define I3 (make-invader 150 (+ HEIGHT 1) 1)) ;> landed, moving right


#;
(define (fn-for-invader i)
  (... (invader-x i) (invader-y i) (invader-dx i)))


(define-struct missile (x y))
;; Missile is (make-missile Number Number)
;; interp. the missile's location is x y in screen coordinates

(define M1 (make-missile 150 300))                       ;not hit U1
(define M2 (make-missile (invader-x I1) (+ (invader-y I1) 10)))  ;exactly hit U1
(define M3 (make-missile (invader-x I1) (+ (invader-y I1)  5)))  ;> hit U1
(define M4 (make-missile 150 100))

#;
(define (fn-for-missile m)
  (... (missile-x m) (missile-y m)))



(define G0 (make-game empty empty T0))
(define G1 (make-game empty empty T1))
(define G2 (make-game (list I1) (list M1) T1))
(define G3 (make-game (list I1 I2) (list M1 M2) T1))

;; ListOfMissile is one of:
;; - empty
;; (cons missile ListOfMissile)
;;interp. a list of missiles that exist in the game

(define LOM1 empty)
(define LOM2 (list M1))
(define LOM3 (list M1 M2 M3))
(define LOM4 (list M4))
#;
(define (fn-for-lom lom)
  (cond[(empty? lom) (...)]
       [else
        (... (fn-for-missile (first lom))
             (fn-for-lom (rest lom)))]))

;;ListOfInvader is one of:
;; - empty
;; - (cons invader ListOfInvader)
;; interp. a list of invaders

(define LOI1 empty)
(define LOI2 (list I1))
(define LOI3 (list I1 I2 I3))
#;
(define (fn-for-loi loi)
  (cond[(empty? loi) (...)]
       [else
        (... (fn-for-invader (first loi))
             (fn-for-loi (rest loi)))]))

;; FUNCTIONS:
;; begin game with (main 0)
(define (main s)
  (big-bang (make-game empty empty (make-tank (/ WIDTH 2) s)) ;Game
            (on-tick   advance-game) ;Game -> Game
            (to-draw   render-game)  ;Game -> Image
            (stop-when game-over gos)    ;Game -> Boolean
            (on-key    handle-key))) ;Game KeyEvent -> Game

;; Game -> Game
;; Advances the game forward by one tick
;; This will:
;; - move the tank
;; - move the missiles
;; - advance the invaders
;; - periodically create new invaders

; (define (advance-game s) s) ;stub
(define (advance-game s)
  (make-game empty
             empty
             (advance-tank (game-t s))))


;; Game -> Game
;; Render the image of the current world state of the game

(check-expect (render-game (make-game empty empty T0)) (place-image TANK (/ WIDTH 2) (- HEIGHT TANK-HEIGHT/2) BACKGROUND))

;(define (render-game s) BACKGROUND) ;stub

(define (render-game s)
       (render-tank (game-t s)))


;; ListOfInvader -> ListOfInvader
;; !!

(define (render-invaders loi img) BACKGROUND) ; stub

;; ListOfMissile -> ListOfMissile
;; !!

(define (render-missiles lom img) BACKGROUND) ; stub

;; Tank -> Tank
;; Place the image of the current tank in the background
(check-expect (render-tank (make-tank (/ WIDTH 2) 1)) (place-image TANK (/ WIDTH 2) (- HEIGHT TANK-HEIGHT/2) BACKGROUND)) ;center

; (define (render-tank t) BACKGROUND) ; stub

(define (render-tank t)
  (place-image TANK (tank-x t) (- HEIGHT TANK-HEIGHT/2) BACKGROUND))

;; Game KeyEvent -> Game
;; !!

(define (handle-key s ke)
  (cond 
        [(key=? ke "left") (make-game (game-invaders s) (game-missiles s) (turn-left (game-t s)))]
        [(key=? ke "right") (make-game (game-invaders s) (game-missiles s) (turn-right (game-t s)))]
        [else 
         s]))

;; Tank -> Tank
;; turns the tank left

;(define (turn-left t) t)

(define (turn-left t)
  (make-tank (tank-x t) -1))

;; Tank -> Tank
;; turns the tank right

;(define (turn-right t) t)

(define (turn-right t)
  (make-tank (tank-x t) 1))



(define (game-over s) false) ; stub

(define (gos s) BACKGROUND) ; stub

;; ListOfMissile ListOfInvader -> ListOfInvader
;; !!

(define (destroy-invaders lm loi) empty) ; stub

;; ListOfInvader -> ListOfInvader
;; !!

(define (create-invaders loi) empty) ; stub

;; ListOfInvader -> ListOfInvader
;; !!

(define (advance-invaders loi) empty) ; stub

;; ListOfMissile -> ListOfMissile
;; !!

(define (advance-missiles lom) empty) ; stub

;; Tank -> Tank
;; move the tank TANK-SPEED pixels in whichever direction it is moving (left or right); stop when it reaches the edge
(check-expect (advance-tank (make-tank 150 1)) (make-tank (+ 150 TANK-SPEED) 1))
(check-expect (advance-tank (make-tank WIDTH 1)) (make-tank WIDTH 0))
(check-expect (advance-tank (make-tank 0 -1)) (make-tank 0 0))

;(define (advance-tank t) t) ;stub

(define (advance-tank t)
  (cond[(> (tank-x t) WIDTH)
        (make-tank WIDTH 0)]
       [(< (tank-x t) 0)
        (make-tank 0 0)]
       [else
        (make-tank (+ (tank-x t) (* (tank-dx t) TANK-SPEED)) (tank-dx t))]))