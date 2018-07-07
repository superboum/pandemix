(load-shared-object "libgstreamer-1.0.so")

(define (gst-message->symbol int)
  (case int
    ((1) 'eos)
    ((2) 'error)))

(define (gst-state->int symbol) 
  (case symbol
    ((void-pending) 0)
    ((null)         1)
    ((ready)        2)
    ((paused)       3)
    ((playing)      4)))

(define-ftype gst-mini-object
  (struct
    [type unsigned-long]
    [refcount int]
    [lockstate int]
    [flags unsigned-int]
    [copy void*]
    [dispose void*]
    [free void*]
    [n-qdata unsigned-int]
    [qdata void*]))

(define-ftype gst-message
  (struct
    [mini-object gst-mini-object]
    [type int]
    [timestamp unsigned-64]
    [src void*]
    [seqnum unsigned-32]
    [lock void*]
    [cond void*]))

(define g-main-loop-new (foreign-procedure "g_main_loop_new" (void* boolean) void*))
(define g-object-set (foreign-procedure "g_object_set" (void* string string void*) void))
(define g-main-loop-run (foreign-procedure "g_main_loop_run" (void*) void))
(define g-main-loop-quit (foreign-procedure "g_main_loop_quit" (void*) void))

(define gst-init (foreign-procedure "gst_init" (ptr void*) void))
(define gst-element-factory-make (foreign-procedure "gst_element_factory_make" (string string) void*))
(define gst-pipeline-get-bus (foreign-procedure "gst_pipeline_get_bus" (void*) void*))
(define gst-bus-add-watch (foreign-procedure "gst_bus_add_watch" (void* void* void*) void))
(define gst-bus-add-signal-watch (foreign-procedure "gst_bus_add_signal_watch" (void*) void))
(define gst-object-unref (foreign-procedure "gst_object_unref" (void*) void))
(define gst-element-set-state (foreign-procedure "gst_element_set_state" (void* int) void))
(define gst-filename-to-uri (foreign-procedure "gst_filename_to_uri" (string void*) string))
(define g-signal-connect-data (foreign-procedure "g_signal_connect_data" (void* string void* void* void* int) void))
(define (g-signal-connect instance detailed-signal handler data)
  (g-signal-connect-data instance detailed-signal handler data 0 0))

(define (control-loop bus msg loop)
  (case (gst-message->symbol (ftype-ref gst-message (type) msg))
    ((eos) (display "that's all folks") (g-main-loop-quit loop))
    ((error) (display "an error occured in gstreamer") (g-main-loop-quit loop)))
  #t)

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
  (g-object-set play "uri" (gst-filename-to-uri "loop.mp3" 0) 0)
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
  
