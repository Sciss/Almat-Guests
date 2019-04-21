#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <float.h>
#include <jack/jack.h>
#include <unistd.h>

#include <caml/mlvalues.h>
#include <caml/memory.h> 
#include <caml/alloc.h>
#include <caml/custom.h>
#include <caml/callback.h>
#include <caml/fail.h>
#include <caml/bigarray.h>
#include <caml/threads.h>


jack_port_t *output_port1, *output_port2;
jack_client_t *client;




/* static void signal_handler(int sig) */
/* { */
/* 	jack_client_close(client); */
/* 	fprintf(stderr, "signal received, exiting ...\n"); */
/* 	exit(0); */
/* } */

/**
 * The process callback for this JACK application is called in a
 * special realtime thread once for each audio cycle.
 *
 * This client follows a simple rule: when the JACK transport is
 * running, copy the input port to the output.  When it stops, exit.
 */

/* float random_float(const float min, const float max) */
/* { */
/*     if (max == min) return min; */
/*     else if (min < max) return (max - min) * ((float)rand() / RAND_MAX) + min; */

/*     // return 0 if min > max */
/*     return 0; */
/* } */



double (*callback_fun)(void);

double init_callback(void) {
    return 0.0;
}



CAMLprim value set_callback(value cb){
  CAMLparam1(cb);
  callback_fun = (double (*)(void)) Nativeint_val(cb);
  CAMLreturn(Val_unit);
}

CAMLprim value set_init_callback(value cb){
  CAMLparam1(cb);
  callback_fun = &init_callback;
  CAMLreturn(Val_unit);
}


int process (jack_nframes_t nframes, void *arg)
{
	jack_default_audio_sample_t *out1, *out2;
	double sample;
	unsigned int i;
	    
	out1 = (jack_default_audio_sample_t*)jack_port_get_buffer (output_port1, nframes);
	out2 = (jack_default_audio_sample_t*)jack_port_get_buffer (output_port2, nframes);

	for( i=0; i<nframes; i++ )
	{

	  //	  sample = Double_field(res,i);
	  //	  sample = random_float(-1.0, 1.0);
	  sample = (*callback_fun)() ;
	  out1[i] = sample;  /* left */
	  out2[i] = sample;  /* right */
	}
    
	return 0;      
}




/**
 * JACK calls this shutdown_callback if the server ever shuts down or
 * decides to disconnect the client.
 */
/* void */
/* jack_shutdown (void *arg) */
/* { */
/* 	exit (1); */
/* } */

CAMLprim value open_stream (value unit)
{
  CAMLparam1(unit);

  const char **ports;
  const char *client_name = "wreck";
  const char *server_name = NULL;
  jack_options_t options = JackNullOption;
  jack_status_t status;

  /* caml_register_generational_global_root(&array); */
  	
  /* open a client connection to the JACK server */

  client = jack_client_open (client_name, options, &status, server_name);
  if (client == NULL) {
    fprintf (stderr, "jack_client_open() failed, "
	     "status = 0x%2.0x\n", status);
    if (status & JackServerFailed) {
      fprintf (stderr, "Unable to connect to JACK server\n");
    }
    exit (1);
  }
  if (status & JackServerStarted) {
    fprintf (stderr, "JACK server started\n");
  }
  if (status & JackNameNotUnique) {
    client_name = jack_get_client_name(client);
    fprintf (stderr, "unique name `%s' assigned\n", client_name);
  }
  
  /* tell the JACK server to call `process()' whenever
     there is work to be done.
	*/
  callback_fun = &init_callback;
  
  jack_set_process_callback (client, process, 0);
  
  /* tell the JACK server to call `jack_shutdown()' if
     it ever shuts down, either entirely, or if it
     just decides to stop calling us.
  */
  
  //	jack_on_shutdown (client, jack_shutdown, 0);

	/* create two ports */

  output_port1 = jack_port_register (client, "output1",
				     JACK_DEFAULT_AUDIO_TYPE,
				     JackPortIsOutput, 0);
  
  output_port2 = jack_port_register (client, "output2",
				     JACK_DEFAULT_AUDIO_TYPE,
				     JackPortIsOutput, 0);
  
  if ((output_port1 == NULL) || (output_port2 == NULL)) {
    fprintf(stderr, "no more JACK ports available\n");
    exit (1);
  }
  
  /* Tell the JACK server that we are ready to roll.  Our
   * process() callback will start running now. */
  
  caml_enter_blocking_section();

  if (jack_activate (client)) {
    fprintf (stderr, "cannot activate client");
    exit (1);
  }
  
  /* Connect the ports.  You can't do this before the client is
   * activated, because we can't make connections to clients
   * that aren't running.  Note the confusing (but necessary)
   * orientation of the driver backend ports: playback ports are
   * "input" to the backend, and capture ports are "output" from
   * it.
   */
  
  ports = jack_get_ports (client, NULL, NULL,
			  JackPortIsPhysical|JackPortIsInput);
  if (ports == NULL) {
    fprintf(stderr, "no physical playback ports\n");
    exit (1);
  }
  
  if (jack_connect (client, jack_port_name (output_port1), ports[0])) {
    fprintf (stderr, "cannot connect output ports\n");
  }

  if (jack_connect (client, jack_port_name (output_port2), ports[1])) {
    fprintf (stderr, "cannot connect output ports\n");
  }
  
  jack_free (ports);
	
    /* install a signal handler to properly quits jack client */
/* #ifdef WIN32 */
/* 	signal(SIGINT, signal_handler); */
/* 	signal(SIGABRT, signal_handler); */
/* 	signal(SIGTERM, signal_handler); */
/* #else */
/* 	signal(SIGQUIT, signal_handler); */
/* 	signal(SIGTERM, signal_handler); */
/* 	signal(SIGHUP, signal_handler); */
/* 	signal(SIGINT, signal_handler); */
/* #endif */

	/* keep running until the Ctrl+C */

  while (1) {
    sleep (1);
  }
  
  caml_leave_blocking_section();
  
  
  jack_client_close (client);
  
  CAMLreturn(Val_unit);
}
