(import (src gobject) (src glib) (src gtk3) (src gstreamer1))

(define (wrapper-cb fn) 
  (foreign-callable-entry-point
    (foreign-callable fn (void* (* gst-message) void*) void)))

(define error-cb (wrapper-cb (lambda (bus msg data) (display "error\n"))))
(define eos-cb (wrapper-cb (lambda (bus msg data) (display "eos\n"))))
(define state-changed-cb (wrapper-cb (lambda (bus msg data) (display "state-changed\n"))))
(define app-cb (wrapper-cb (lambda (bus msg data) (display "app\n"))))

(define (gui-bind-handlers builder entry)
  (gtk-builder-add-callback-symbol
    builder
    (car entry)
    (foreign-callable-entry-point
      (foreign-callable (cdr entry) (void* void*) void))))

(define (sound body)
  (gst-init 0 0)
  (let*
    ([play (gst-element-factory-make "playbin" "play")]
     [bus  (gst-pipeline-get-bus play)])

    (gst-bus-add-signal-watch bus)
  
    (g-signal-connect bus "message::error" error-cb play)
    (g-signal-connect bus "message::eos" eos-cb play)
    (g-signal-connect bus "message::state-changed" state-changed-cb play)
    (g-signal-connect bus "message::application" app-cb play)
  
    (gst-object-unref bus)

    (body play)
    
    (gst-element-set-state play (gst-state->int 'null))
    (gst-object-unref play)))

(define (gui-main body)
  (gtk-init 0 0)
  (let
    ([builder (gtk-builder-new)])
    (gtk-builder-add-from-file builder "interface.glade" 0)

    (let*
      ([window (gtk-builder-get-object builder "window_main")]
       [gui-handlers (body builder)])

      (map (lambda (entry) (gui-bind-handlers builder entry)) gui-handlers)
      (gtk-builder-connect-signals builder 0)
      (gtk-widget-show window)
      (gtk-main)
      (g-object-unref builder)
)))

(sound (lambda (play)
  (gui-main (lambda (builder)
    (list
      (cons "on_window_main_destroy" (lambda (window data) (gtk-main-quit)))
      (cons "on_add_music_btn_clicked" (lambda (window data) (display "add music button clicked \n")))
      (cons
        "on_pause_btn_clicked"
        (lambda (window data)
          (gtk-widget-set-visible (gtk-builder-get-object builder "pause_btn") #f)
          (gtk-widget-set-visible (gtk-builder-get-object builder "play_btn") #t)
          (gst-element-set-state play (gst-state->int 'null))))

      (cons
        "on_play_btn_clicked"
        (lambda (window data)
          (gtk-widget-set-visible (gtk-builder-get-object builder "pause_btn") #t)
          (gtk-widget-set-visible (gtk-builder-get-object builder "play_btn") #f)
          (g-object-set play "uri" (gst-filename-to-uri "loop.mp3" 0))
          (gst-element-set-state play (gst-state->int 'playing))          
          (display "clicked\n"))))))))
(exit)
