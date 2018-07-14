(import (src gui) (src audio) (src bindings gobject) (src bindings glib) (src bindings gtk3) (src bindings gstreamer1))

(sound (lambda (play)
  (gui-main (lambda (builder)
    (list
      (cons "on_window_main_destroy" (lambda (window data) (gtk-main-quit)))
      (cons "on_add_music_btn_clicked" (lambda (window data) (display "add music button clicked \n")))
      (cons
        "on_pause_btn_clicked"
        (lambda (window data)
          (gtk-widget-set-visible (gtk-builder-get-object builder "pause_btn") #f)
          (gtk-widget-set-visible (gtk-builder-get-object builder "play_btn") #t)
          (gst-element-set-state play (gst-state->int 'null))))

      (cons
        "on_play_btn_clicked"
        (lambda (window data)
          (gtk-widget-set-visible (gtk-builder-get-object builder "pause_btn") #t)
          (gtk-widget-set-visible (gtk-builder-get-object builder "play_btn") #f)
          (g-object-set play "uri" (gst-filename-to-uri "loop.mp3" 0))
          (gst-element-set-state play (gst-state->int 'playing))          
          (display "clicked\n"))))))))
(exit)
