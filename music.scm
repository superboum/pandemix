(import (src gstreamer1) (src glib) (src gobject))

(define (wrapper-cb fn) 
  (foreign-callable-entry-point
    (foreign-callable fn (void* (* gst-message) void*) void)))

(define error-cb (wrapper-cb (lambda (bus msg data) (display "error\n") (g-main-loop-quit data))))
(define eos-cb (wrapper-cb (lambda (bus msg data) (display "eos\n") (g-main-loop-quit data))))
(define state-changed-cb (wrapper-cb (lambda (bus msg data) (display "state-changed\n"))))
(define app-cb (wrapper-cb (lambda (bus msg data) (display "app\n"))))

(gst-init 0 0)
(let*
  ([loop (g-main-loop-new 0 #f)]
   [play (gst-element-factory-make "playbin" "play")]
   [bus  (gst-pipeline-get-bus play)])
  (g-object-set play "uri" (gst-filename-to-uri "loop.mp3" 0))
  (gst-bus-add-signal-watch bus)
  (g-signal-connect bus "message::error" error-cb loop)
  (g-signal-connect bus "message::eos" eos-cb loop)
  (g-signal-connect bus "message::state-changed" state-changed-cb loop)
  (g-signal-connect bus "message::application" app-cb loop)
  (gst-object-unref bus)
  (gst-element-set-state play (gst-state->int 'playing))
  (g-main-loop-run loop)
  (gst-element-set-state play (gst-state->int 'null))
  (gst-object-unref play)
  (display "done")
)
