(load-shared-object "libgstreamer-1.0.so")

(define (gst-state->int symbol) 
  (case symbol
    ((void-pending) 0)
    ((null)         1)
    ((ready)        2)
    ((paused)       3)
    ((playing)      4)))

(define g-main-loop-new (foreign-procedure "g_main_loop_new" (void* boolean) void*))
(define g-object-set (foreign-procedure "g_object_set" (void* string string void*) void))
(define g-main-loop-run (foreign-procedure "g_main_loop_run" (void*) void))

(define gst-init (foreign-procedure "gst_init" (ptr void*) void))
(define gst-element-factory-make (foreign-procedure "gst_element_factory_make" (string string) void*))
(define gst-pipeline-get-bus (foreign-procedure "gst_pipeline_get_bus" (void*) void*))
(define gst-bus-add-watch (foreign-procedure "gst_bus_add_watch" (void* void* void*) void))
(define gst-object-unref (foreign-procedure "gst_object_unref" (void*) void))
(define gst-element-set-state (foreign-procedure "gst_element_set_state" (void* int) void))
(define gst-filename-to-uri (foreign-procedure "gst_filename_to_uri" (string void*) string))

(gst-init 0 0)
(let*
  ([loop (g-main-loop-new 0 #f)]
   [play (gst-element-factory-make "playbin" "play")]
   [bus  (gst-pipeline-get-bus play)]
   [control (foreign-callable (lambda (bus2 msg loop2) #t) (void* void* void*) boolean)]
   [control2 (foreign-callable-entry-point control)])
  (g-object-set play "uri" (gst-filename-to-uri "loop.mp3" 0) 0)
  (gst-bus-add-watch bus control2 loop)
  (gst-object-unref bus)
  (gst-element-set-state play (gst-state->int 'playing))
  (g-main-loop-run loop)
  (display "done")
)
  
