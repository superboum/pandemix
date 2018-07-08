(import (src gobject) (src glib) (src gtk3))

(define (gui-bind-handlers builder entry)
  (gtk-builder-add-callback-symbol
    builder
    (car entry)
    (foreign-callable-entry-point
      (foreign-callable (cdr entry) (void* void*) void))))

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
    (cons "on_window_main_destroy" (lambda (window data) (gtk-main-quit) (exit)))
    (cons "on_play_btn_clicked" (lambda (window data) (display "clicked\n")))))
