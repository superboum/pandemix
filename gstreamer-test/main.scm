(load-shared-object "libgstreamer-1.0.so")

(define gst-init (foreign-procedure "gst_init" (ptr void*) void))
(define g-main-loop-new (foreign-procedure "g_main_loop_new" (void* int) void*))
(define g-object-set (foreign-procedure "g_object_set" (void* string string void*) void))
(define gst-element-factory-make (foreign-procedure "gst_element_factory_make" (string string) void*))
(define gst-pipeline-get-bus (foreign-procedure "gst_pipeline_get_bus" (void*) void*))
(define gst-bus-add-watch (foreign-procedure "gst_bus_add_watch" (void* void* void*) void*)) ; @TODO
(define gst-object-unref (foreign-procedure "gst_object_unref" (void*) void))

(gst-init 0 0)
(let*
  ([loop (g-main-loop-new 0 0)]
   [play (gst-element-factory-make "playbin" "play")]
   [bus  (gst-pipeline-get-bus play)])
  (display bus)
  (g-object-set play "uri" "file:////home/quentin/Musique/firewatch/Camp Approach-2120717428.mp3" 0)
  ;(gst-bus-add-watch bus ?? loop)
  (gst-object-unref bus)
)
  
