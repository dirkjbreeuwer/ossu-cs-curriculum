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

(define M1 (make-missile (/ WIDTH 2) 500))  ; missile just shooting from the center of the screen
(define M2 (make-missile (invader-x I1) (+ (invader-y I1) 10)))  
(define M3 (make-missile (invader-x I1) (+ (invader-y I1)  5)))  ;> hit U1
(define M4 (make-missile (/ WIDTH 2) (/ HEIGHT 2))) ; missile in the center of the screen

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
             (advance-missiles (game-missiles s))
             (advance-tank (game-t s))))


;; Game -> Game
;; Render the image of the current world state of the game

(check-expect (render-game (make-game empty empty T0)) (place-image TANK (/ WIDTH 2) (- HEIGHT TANK-HEIGHT/2) BACKGROUND))

;(define (render-game s) BACKGROUND) ;stub

(define (render-game s)
                   (render-missiles (game-missiles s)
                                    (render-tank (game-t s))))


;; ListOfInvader Image -> Image
;; Render invaders into image with background

(check-expect (render-invaders (list (make-invader 150 1 1)) BACKGROUND) (place-image INVADER 150 1 BACKGROUND)) ; one invader in the middle of the screen
(check-expect (render-invaders (list (make-invader 150 1 1) (make-invader WIDTH (/ HEIGHT 2) 1)) BACKGROUND) (place-image INVADER 150 1 (place-image INVADER WIDTH (/ HEIGHT 2) BACKGROUND))) ; two invaders: one begining and middle, one middle right

;; New

;(define (render-invaders loi img) BACKGROUND) ; stub

(define (render-invaders loi img)
  (cond[(empty? loi) img]
       [else
        (place-image INVADER (invader-x (first loi)) (invader-y (first loi))
             (render-invaders (rest loi) img))]))


;; Invader -> Image
;; Render invader into image

(check-expect (render-invader (make-invader (/ WIDTH 2) 0 1)) (place-image INVADER (/ WIDTH 2) 0 BACKGROUND)); Invader appearing at the top of the screen in the center

; (define (render-invader i) BACKGROUND); stub


(define (render-invader i)
  (place-image INVADER (invader-x i) (invader-y i) BACKGROUND))


;; ListOfMissile Image -> Image
;; Render LOM into image with background
(check-expect (render-missiles  (list (make-missile (/ WIDTH 2) (/ HEIGHT 2))) BACKGROUND) (place-image MISSILE (/ WIDTH 2) (/ HEIGHT 2) BACKGROUND ))  ; One missile in the middle of the screen
(check-expect (render-missiles  (list (make-missile (/ WIDTH 2) (/ HEIGHT 2)) (make-missile (/ WIDTH 2) 500 )) BACKGROUND)
              (place-image MISSILE (/ WIDTH 2) (/ HEIGHT 2) (place-image MISSILE (/ WIDTH 2) 500 BACKGROUND )))  ; Two missiles: One begining one middle


;(define (render-missiles lom img) BACKGROUND) ; stub

(define (render-missiles lom img)
  (cond[(empty? lom) img]
       [else
        (place-image MISSILE
                     (missile-x (first lom))
                     (missile-y (first lom))
                     (render-missiles (rest lom) img))]))


;; Missile -> Image
;; Render missile into image

(check-expect (render-missile M1) (place-image MISSILE 150 500 BACKGROUND)) ; Missile just shooting from the bottom of the screen

; (define (render-missile m) BACKGROUND) ; stub

(define (render-missile m)
  (place-image MISSILE (missile-x m) (missile-y m) BACKGROUND))


;; Tank -> Image
;; Place the image of the current tank in the background
(check-expect (render-tank (make-tank (/ WIDTH 2) 1)) (place-image TANK (/ WIDTH 2) (- HEIGHT TANK-HEIGHT/2) BACKGROUND)) ;center

; (define (render-tank t) BACKGROUND) ; stub

(define (render-tank t)
  (place-image TANK (tank-x t) (- HEIGHT TANK-HEIGHT/2) BACKGROUND))

;; Game KeyEvent -> Game
;; !!

(define (handle-key s ke)
  (cond [(key=? ke " ") (make-game (game-invaders s) (fire-missile (game-missiles s) (tank-x (game-t s))) (game-t s))]
        [(key=? ke "left") (make-game (game-invaders s) (game-missiles s) (turn-left (game-t s)))]
        [(key=? ke "right") (make-game (game-invaders s) (game-missiles s) (turn-right (game-t s)))]
        [else 
         s]))


;; ListOfMissile Natural -> ListOfMissile
;; fires a missile
(check-expect (fire-missile empty 150) (cons (make-missile 150 (- HEIGHT TANK-HEIGHT/2)) empty)) ; fires a missile in the center of the screen

;(define (fire-missile lom x) lom)

(define (fire-missile lom x)
  (cond[(empty? lom) (cons (make-missile x (- HEIGHT TANK-HEIGHT/2)) empty)]
       [else
        (cons (make-missile x (- HEIGHT TANK-HEIGHT/2)) lom)]))

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
;; Advance each invader in LOM by one unit of invader speed
;; If any invader reaches bottom of screen game ovver
(check-expect (advance-invaders (list(make-invader 150 1 1))) (list (make-invader 151 2 1))) ; invader in the middle of the screen


(define (advance-invaders loi) empty) ; stub

;; Invader -> Invader
;; Move the invader in the direction its traveling
;; If hits a wall then change the direction in the x-axis


(define (move-invader i) i) ;stub


;; ListOfMissile -> ListOfMissile
;; Advance each missile in LOM by one unit of missile speed

(check-expect (advance-missiles LOM2) (list (advance-missile M1))) ; advance list with one missile
(check-expect (advance-missiles LOM3) (list (advance-missile M1) (advance-missile M2) (advance-missile M3))) ; advance list with three missiles


;(define (advance-missiles lom) empty) ; stub

(define (advance-missiles lom)
  (cond[(empty? lom) empty]
       [else
        (if (< (missile-y (first lom)) 0)
            (advance-missiles (rest lom))
            (cons (advance-missile (first lom))
                  (advance-missiles (rest lom))))]))

;; Missile -> Missile
;; Advance missile by one unit of missile speed

(check-expect (advance-missile M1) (make-missile 150 (- 500 MISSILE-SPEED)))

 
; (define (advance-missile m) empty) ; stub

(define (advance-missile m)
  (make-missile (missile-x m) (- (missile-y m) MISSILE-SPEED)))


;; Tank -> Tank
;; move the tank TANK-SPEED pixels in whichever direction it is moving (left or right); stop when it reaches the edge
(check-expect (advance-tank (make-tank 150 1)) (make-tank (+ 150 TANK-SPEED) 1))  ; Tank moving right from middle.
(check-expect (advance-tank (make-tank WIDTH 1)) (make-tank WIDTH 0))             ; Tank moving right at right edge.
(check-expect (advance-tank (make-tank 0 -1)) (make-tank 0 0))                    ; Tank moving left at left edge.


;(define (advance-tank t) t) ;stub

(define (advance-tank t)
  (cond
    ;; Check if the new position is beyond the left edge of the screen
    [(<= (+ (tank-x t) (* (tank-dx t) TANK-SPEED)) 0)
     (make-tank 0 0)]  ; Stop at the edge with no movement

    ;; Check if the new position is beyond the right edge of the screen
    [(>= (+ (tank-x t) (* (tank-dx t) TANK-SPEED)) WIDTH)
     (make-tank WIDTH 0)]  ; Stop at the edge with no movement

    ;; Default case where the tank is within the bounds
    [else
     (make-tank (+ (tank-x t) (* (tank-dx t) TANK-SPEED)) (tank-dx t))]))
