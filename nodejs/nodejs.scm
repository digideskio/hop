;*=====================================================================*/
;*    serrano/prgm/project/hop/3.0.x/nodejs/nodejs.scm                 */
;*    -------------------------------------------------------------    */
;*    Author      :  Manuel Serrano                                    */
;*    Creation    :  Wed Sep 18 16:19:42 2013                          */
;*    Last change :  Wed Apr 16 14:14:08 2014 (serrano)                */
;*    Copyright   :  2013-14 Manuel Serrano                            */
;*    -------------------------------------------------------------    */
;*    nodejs boot                                                      */
;*=====================================================================*/

;*---------------------------------------------------------------------*/
;*    The module                                                       */
;*---------------------------------------------------------------------*/
(module __nodejs

   (option (set! *warning-overriden-variables* #f))
   
   (library hopscript)

   (import __nodejs_require
	   __nodejs_process
	   (__nodejs_console "| echo \"(module __nodejs_console (library hop hopscript js2scheme) (export (hopscript ::JsGlobalObject)))\"")
	   (__nodejs_constants "| echo \"(module __nodejs_constants (library hop hopscript js2scheme) (export (hopscript ::JsGlobalObject)))\"")
	   (__nodejs_util "| echo \"(module __nodejs_util (library hop hopscript js2scheme) (export (hopscript ::JsGlobalObject)))\"")
	   (__nodejs_sys "| echo \"(module __nodejs_sys (library hop hopscript js2scheme) (export (hopscript ::JsGlobalObject)))\"")
	   (__nodejs_path "| echo \"(module __nodejs_path (library hop hopscript js2scheme) (export (hopscript ::JsGlobalObject)))\"")
	   (__nodejs__linklist "| echo \"(module __nodejs__linklist (library hop hopscript js2scheme) (export (hopscript ::JsGlobalObject)))\"")
	   (__nodejs_events "| echo \"(module __nodejs_events (library hop hopscript js2scheme) (export (hopscript ::JsGlobalObject)))\"")
	   (__nodejs_assert "| echo \"(module __nodejs_assert (library hop hopscript js2scheme) (export (hopscript ::JsGlobalObject)))\"")
	   (__nodejs__stream_readable "| echo \"(module __nodejs__stream_readable (library hop hopscript js2scheme) (export (hopscript ::JsGlobalObject)))\"")
	   (__nodejs__stream_writable "| echo \"(module __nodejs__stream_writable (library hop hopscript js2scheme) (export (hopscript ::JsGlobalObject)))\"")
	   (__nodejs__stream_duplex "| echo \"(module __nodejs__stream_duplex (library hop hopscript js2scheme) (export (hopscript ::JsGlobalObject)))\"")
	   (__nodejs__stream_transform "| echo \"(module __nodejs__stream_transform (library hop hopscript js2scheme) (export (hopscript ::JsGlobalObject)))\"")
	   (__nodejs__stream_passthrough "| echo \"(module __nodejs__stream_passthrough (library hop hopscript js2scheme) (export (hopscript ::JsGlobalObject)))\"")
	   (__nodejs_stream "| echo \"(module __nodejs_stream (library hop hopscript js2scheme) (export (hopscript ::JsGlobalObject)))\"")
	   (__nodejs_fs "| echo \"(module __nodejs_fs (library hop hopscript js2scheme) (export (hopscript ::JsGlobalObject)))\"")
	   (__nodejs_punycode "| echo \"(module __nodejs_punycode (library hop hopscript js2scheme) (export (hopscript ::JsGlobalObject)))\"")
	   (__nodejs_buffer "| echo \"(module __nodejs_buffer (library hop hopscript js2scheme) (export (hopscript ::JsGlobalObject)))\"")
	   (__nodejs_dgram "| echo \"(module __nodejs_dgram (library hop hopscript js2scheme) (export (hopscript ::JsGlobalObject)))\"")
	   (__nodejs_vm "| echo \"(module __nodejs_vm (library hop hopscript js2scheme) (export (hopscript ::JsGlobalObject)))\"")
	   (__nodejs_timers "| echo \"(module __nodejs_timers (library hop hopscript js2scheme) (export (hopscript ::JsGlobalObject)))\"")
	   (__nodejs_net "| echo \"(module __nodejs_net (library hop hopscript js2scheme) (export (hopscript ::JsGlobalObject)))\"")
	   (__nodejs_querystring "| echo \"(module __nodejs_querystring (library hop hopscript js2scheme) (export (hopscript ::JsGlobalObject)))\"")
	   (__nodejs_string_decoder "| echo \"(module __nodejs_string_decoder (library hop hopscript js2scheme) (export (hopscript ::JsGlobalObject)))\"")
	   (__nodejs_child_process "| echo \"(module __nodejs_child_process (library hop hopscript js2scheme) (export (hopscript ::JsGlobalObject)))\"")
	   (__nodejs_cluster "| echo \"(module __nodejs_cluster (library hop hopscript js2scheme) (export (hopscript ::JsGlobalObject)))\"")
	   (__nodejs_crypto "| echo \"(module __nodejs_crypto (library hop hopscript js2scheme) (export (hopscript ::JsGlobalObject)))\"")
	   (__nodejs_dns "| echo \"(module __nodejs_dns (library hop hopscript js2scheme) (export (hopscript ::JsGlobalObject)))\"")
	   (__nodejs_domain "| echo \"(module __nodejs_domain (library hop hopscript js2scheme) (export (hopscript ::JsGlobalObject)))\"")
	   (__nodejs_freelist "| echo \"(module __nodejs_freelist (library hop hopscript js2scheme) (export (hopscript ::JsGlobalObject)))\"")
	   (__nodejs_url "| echo \"(module __nodejs_url (library hop hopscript js2scheme) (export (hopscript ::JsGlobalObject)))\"")
	   (__nodejs_tls "| echo \"(module __nodejs_tls (library hop hopscript js2scheme) (export (hopscript ::JsGlobalObject)))\"")
	   (__nodejs_http "| echo \"(module __nodejs_http (library hop hopscript js2scheme) (export (hopscript ::JsGlobalObject)))\"")
	   (__nodejs_https "| echo \"(module __nodejs_https (library hop hopscript js2scheme) (export (hopscript ::JsGlobalObject)))\"")
	   (__nodejs_zlib "| echo \"(module __nodejs_zlib (library hop hopscript js2scheme) (export (hopscript ::JsGlobalObject)))\"")
	   (__nodejs_hop "| echo \"(module __nodejs_hop (library hop hopscript js2scheme) (export (hopscript ::JsGlobalObject)))\""))

   (export (core-module-table)))

;*---------------------------------------------------------------------*/
;*    make-core-module-table :: ...                                    */
;*---------------------------------------------------------------------*/
(define-macro (make-core-module-table . modules)
   `(list
       ,@(map (lambda (m)
		 (let ((s (string->symbol (format "__nodejs_~a" m))))
		    `(cons ',m (@ hopscript ,s))))
	    modules)))

;*---------------------------------------------------------------------*/
;*    module-table ...                                                 */
;*---------------------------------------------------------------------*/
(define module-table
   (make-core-module-table
      "console"
      "constants"
      "util"
      "sys"
      "path"
      "_linklist"
      "events"
      "assert"
      "_stream_readable"
      "_stream_writable"
      "_stream_duplex"
      "_stream_transform"
      "_stream_passthrough"
      "stream"
      "fs"
      "punycode"
      "buffer"
      "dgram"
      "vm"
      "timers"
      "net"
      "querystring"
      "string_decoder"
      "child_process"
      "cluster"
      "crypto"
      "dns"
      "domain"
      "freelist"
      "url"
      "tls"
      "http"
      "https"
      "zlib"
      "hop"))

;*---------------------------------------------------------------------*/
;*    core-module-table ...                                            */
;*---------------------------------------------------------------------*/
(define (core-module-table)
   module-table)