(load-shared-object "libgtk-3.so.0")

(define gtk-init (foreign-procedure "gtk_init" (ptr void*) void))
(define gtk-builder-new (foreign-procedure "gtk_builder_new" () void*))
(define gtk-builder-add-from-file (foreign-procedure "gtk_builder_add_from_file" (void* string void*) void))
(define gtk-builder-get-object (foreign-procedure "gtk_builder_get_object" (void* string) void*))

(gtk-init 0 0)
(let ([builder (gtk-builder-new)])
  (gtk-builder-add-from-file builder "interface.glade" 0)
  (let ([window (gtk-builder-get-object builder "window_main")]) 
    (display 0)))
