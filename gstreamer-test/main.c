#include <gst/gst.h>

static gboolean control(GstBus *bus, GstMessage *msg, gpointer data) {
  GMainLoop *loop = (GMainLoop*)data;
  
  switch (GST_MESSAGE_TYPE(msg)) {
    case GST_MESSAGE_EOS:
      /* End Of Stream - the song is terminated */
      g_print("That's all folks!\n");
      g_main_loop_quit(loop);
      break;

    case GST_MESSAGE_ERROR: {
      gchar *debug;
      GError *error;

      gst_message_parse_error(msg, &error, &debug);
      g_free(debug); /* we don't use debug */

      g_printerr("Ooops: %s\n", error->message);
      g_error_free(error);

      g_main_loop_quit(loop);
      break;
    }
    default:
      break;
  }

  return TRUE;
}

int main(int argc, char **argv) {
  GMainLoop *loop;
  GstElement *play;
  GstBus *bus;

  /* gstreamer initialization */
  gst_init(&argc,&argv);
  loop = g_main_loop_new(NULL, FALSE);

  /* check that we passed a file as parameter */
  if (argc != 2) {
    g_print("Usage: %s filename\n", argv[0]);
    return -1;
  }

  /* init playbin and prepare path */
  play = gst_element_factory_make("playbin", "play");
  g_object_set(G_OBJECT(play), "uri", argv[1], NULL); /* play.uri = argv[1] */

  /* Create pipeline and get corresponding bus */
  bus = gst_pipeline_get_bus(GST_PIPELINE(play));
  
  /* Add our callback that allow to control the playing */
  gst_bus_add_watch(bus, control, loop);

  /* We don't need the bus anymore */
  gst_object_unref(bus);

  /* Let's start the music! */
  gst_element_set_state(play, GST_STATE_PLAYING);
  g_main_loop_run(loop);

  /* And clean everything up */
  gst_element_set_state(play, GST_STATE_NULL);
  gst_object_unref(GST_OBJECT(play));

  return 0;
}
