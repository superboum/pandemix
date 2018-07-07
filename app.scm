(load-shared-object "libgtk-3.so.0")

(define g-object-unref (foreign-procedure "g_object_unref" (void*) void))

(define gtk-init (foreign-procedure "gtk_init" (ptr void*) void))
(define gtk-builder-new (foreign-procedure "gtk_builder_new" () void*))
(define gtk-builder-add-from-file (foreign-procedure "gtk_builder_add_from_file" (void* string void*) void))
(define gtk-builder-get-object (foreign-procedure "gtk_builder_get_object" (void* string) void*))
(define gtk-builder-connect-signals (foreign-procedure "gtk_builder_connect_signals" (void* void*) void))
(define gtk-widget-show (foreign-procedure "gtk_widget_show" (void*) void))
(define gtk-builder-add-callback-symbol (foreign-procedure "gtk_builder_add_callback_symbol" (void* string void*) void))
(define gtk-main (foreign-procedure "gtk_main" () void))
(define gtk-main-quit (foreign-procedure "gtk_main_quit" () void))

(define (gui-bind-handlers builder entry)
  (gtk-builder-add-callback-symbol
    builder
    (car entry)
    (foreign-callable-entry-point
      (foreign-callable (cdr entry) () void))))

(define (gui-main gui-handlers)
  (gtk-init 0 0)
  (let ([builder (gtk-builder-new)])
    (gtk-builder-add-from-file builder "interface.glade" 0)
    (let ([window (gtk-builder-get-object builder "window_main")]) 
      (map (lambda (entry) (gui-bind-handlers builder entry)) gui-handlers)
      (gtk-builder-connect-signals builder 0)
      (g-object-unref builder)
      (gtk-widget-show window)
      (gtk-main))))

(gui-main
  (list
    (cons "on_window_main_destroy" (lambda () (gtk-main-quit)))
    (cons "on_play_btn_clicked" (lambda () (display "clicked\n")))))
