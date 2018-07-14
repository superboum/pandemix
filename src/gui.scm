(library (src gui)
  (export gui-main gui-bind-handlers)
  (import (src bindings gtk3) (src bindings gobject) (src bindings glib) (chezscheme))

  (define (gui-bind-handlers builder entry)
    (gtk-builder-add-callback-symbol
      builder
      (car entry)
      (foreign-callable-entry-point
        (foreign-callable (cdr entry) (void* void*) void))))

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
        (g-object-unref builder)))))
