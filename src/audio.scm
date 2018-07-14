(library (src audio)
  (export sound)
  (import (src bindings gstreamer1) (src bindings gobject) (src bindings glib) (chezscheme))

  (define (wrapper-cb fn) 
    (foreign-callable-entry-point
      (foreign-callable fn (void* (* gst-message) void*) void)))

  (define error-cb (wrapper-cb (lambda (bus msg data) (display "error\n"))))
  (define eos-cb (wrapper-cb (lambda (bus msg data) (display "eos\n"))))
  (define state-changed-cb (wrapper-cb (lambda (bus msg data) (display "state-changed\n"))))
  (define app-cb (wrapper-cb (lambda (bus msg data) (display "app\n"))))

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

)

