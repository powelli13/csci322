#lang racket
;; Geoffrey Matthews
;; 2013

;; Building gui's with racket
(require racket/gui)

(define frame (new frame% 
                   (label "Example")
                   (min-width 120)
                   (min-height 80)
                   ))
(send frame create-status-line)
(send frame show #t)

(define h-panel
  (new horizontal-panel%
       (parent frame)
       (stretchable-height #f)
       (style '(border))
       (border 2)))

(define drawing-choice
  (new choice%
       (parent h-panel)
       (label "Draw a")
       (choices '("Circle" "Square" "Triangle"))
       (callback (lambda (c e) (send canvas refresh)))))

;; Let's add our own canvas by subclassing canvas,
;; and overriding on-event as well as on-paint.
;; We also move the code for overridden methods inside
;; the object.

(define my-canvas%
  (class canvas%
    (override on-paint on-event)
    (define (on-paint)
      (let ((dc (send this get-dc)))
        (case (send drawing-choice get-selection)
          ((0)
           (send dc draw-ellipse
                 10 10 
                 (- (send this get-width) 20) (- (send this get-height) 20)
                 ))
          ((1)
           (send dc draw-rectangle 
                 10 10 
                 (- (send this get-width) 20) (- (send this get-height) 20)))
          ((2)
           (send dc draw-lines
                 (list
                  (make-object point% (/ (send this get-width) 2) 10)
                  (make-object point% (- (send this get-width) 10)
                    (- (send canvas get-height) 10))
                  (make-object point% 10 (- (send this get-height) 10))
                  (make-object point% (/ (send this get-width) 2) 10)
                  ))))))
    (define (on-event event)
      (when (send event button-down?)
        (send frame set-status-text (format "Mouse at ~a ~a"
                                            (send event get-x)
                                            (send event get-y)))
        (send (send this get-dc) draw-ellipse
              (- (send event get-x) 5)
              (- (send event get-y) 5)
              10 10 
             )))
              
    (super-new)))

(define canvas
  (new my-canvas%
       (parent frame)
       (style '(border))
       (min-width 300)
       (min-height 200)))
       
             
       
