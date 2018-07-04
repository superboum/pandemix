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
(define gst-object-unref (foreign-procedure "gst_object_unref" (void*) void))
(define gst-element-set-state (foreign-procedure "gst_element_set_state" (void* int) void))
(define gst-filename-to-uri (foreign-procedure "gst_filename_to_uri" (string void*) string))

(define (control-loop bus msg loop)
  (case (gst-message->symbol (ftype-ref gst-message (type) msg))
    ((eos) (display "that's all folks") (g-main-loop-quit loop))
    ((error) (display "an error occured in gstreamer") (g-main-loop-quit loop)))
  #t)

(gst-init 0 0)
(let*
  ([loop (g-main-loop-new 0 #f)]
   [play (gst-element-factory-make "playbin" "play")]
   [bus  (gst-pipeline-get-bus play)]
   [control (foreign-callable control-loop (void* (* gst-message) void*) boolean)]
   [control2 (foreign-callable-entry-point control)])
  (g-object-set play "uri" (gst-filename-to-uri "loop.mp3" 0) 0)
  (gst-bus-add-watch bus control2 loop)
  (gst-object-unref bus)
  (gst-element-set-state play (gst-state->int 'playing))
  (g-main-loop-run loop)
  (gst-element-set-state play (gst-state->int 'null))
  (gst-object-unref play)
  (display "done")
)
  
