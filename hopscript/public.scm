;*=====================================================================*/
;*    serrano/prgm/project/hop/3.0.x/hopscript/public.scm              */
;*    -------------------------------------------------------------    */
;*    Author      :  Manuel Serrano                                    */
;*    Creation    :  Tue Oct  8 08:10:39 2013                          */
;*    Last change :  Tue Apr 22 11:51:55 2014 (serrano)                */
;*    Copyright   :  2013-14 Manuel Serrano                            */
;*    -------------------------------------------------------------    */
;*    Public (i.e., exported outside the lib) hopscript functions      */
;*=====================================================================*/

;*---------------------------------------------------------------------*/
;*    The module                                                       */
;*---------------------------------------------------------------------*/
(module __hopscript_public
   
   (library hop js2scheme)
   
   (import __hopscript_types
	   __hopscript_object
	   __hopscript_function
	   __hopscript_error
	   __hopscript_string
	   __hopscript_boolean
	   __hopscript_number
	   __hopscript_property
	   __hopscript_private
	   __hopscript_worker)
   
   (export (js-new ::JsGlobalObject f . args)
	   (js-new0 ::JsGlobalObject f)
	   (js-new1 ::JsGlobalObject f a0)
	   (js-new2 ::JsGlobalObject f a0 a1)
	   (js-new3 ::JsGlobalObject f a0 a1 a2)
	   (js-new4 ::JsGlobalObject f a0 a1 a2 a3)
	   
	   (js-object-alloc ::JsFunction ::JsGlobalObject)
	   
	   (js-apply ::JsGlobalObject fun::obj this args)
	   
	   (js-call0 ::JsGlobalObject fun::obj this)
	   (js-call1 ::JsGlobalObject fun::obj this a0)
	   (js-call2 ::JsGlobalObject fun::obj this a0 a1)
	   (js-call3 ::JsGlobalObject fun::obj this a0 a1 a2)
	   (js-call4 ::JsGlobalObject fun::obj this a0 a1 a2 a3)
	   (js-call5 ::JsGlobalObject fun::obj this a0 a1 a2 a3 a4)
	   (js-call6 ::JsGlobalObject fun::obj this a0 a1 a2 a3 a4 a5)
	   (js-call7 ::JsGlobalObject fun::obj this a0 a1 a2 a3 a4 a5 a6)
	   (js-call8 ::JsGlobalObject fun::obj this a0 a1 a2 a3 a4 a5 a6 a7)
	   (js-calln ::JsGlobalObject fun::obj this . args)
	   
	   (js-call0/debug ::JsGlobalObject loc fun::obj this)
	   (js-call1/debug ::JsGlobalObject loc fun::obj this a0)
	   (js-call2/debug ::JsGlobalObject loc fun::obj this a0 a1)
	   (js-call3/debug ::JsGlobalObject loc fun::obj this a0 a1 a2)
	   (js-call4/debug ::JsGlobalObject loc fun::obj this a0 a1 a2 a3)
	   (js-call5/debug ::JsGlobalObject loc fun::obj this a0 a1 a2 a3 a4)
	   (js-call6/debug ::JsGlobalObject loc fun::obj this a0 a1 a2 a3 a4 a5)
	   (js-call7/debug ::JsGlobalObject loc fun::obj this a0 a1 a2 a3 a4 a5 a6)
	   (js-call8/debug ::JsGlobalObject loc fun::obj this a0 a1 a2 a3 a4 a5 a6 a7)
	   (js-calln/debug ::JsGlobalObject loc fun::obj this . args)
	   
	   (js-instanceof?::bool v f ::JsGlobalObject)
	   (js-in?::bool f obj ::JsGlobalObject)
	   (inline js-totest::bool ::obj)
	   (js-toboolean::bool ::obj)
	   (generic js-tonumber ::obj ::JsGlobalObject)
	   (generic js-tointeger ::obj ::JsGlobalObject)
	   (js-touint16::uint16 ::obj ::JsGlobalObject)
	   (js-touint32::uint32 ::obj ::JsGlobalObject)
	   (js-toint32::int32 ::obj ::JsGlobalObject)
	   (js-tostring::bstring ::obj ::JsGlobalObject)
	   (js-toobject::JsObject ::JsGlobalObject ::obj)
	   
	   (inline js-equal? ::obj ::obj ::JsGlobalObject)
	   (js-equality? ::obj ::obj ::JsGlobalObject)
	   (inline js-strict-equal? ::obj ::obj)
	   (js-eq? ::obj ::obj)
	   
	   (make-pcache ::int)
	   (inline pcache-ref ::vector ::int)
	   
	   (%js-eval-strict ::bstring ::JsGlobalObject)
	   (%js-eval-hss ::input-port ::JsGlobalObject ::obj)
	   
	   (js-raise ::JsError)))

;*---------------------------------------------------------------------*/
;*    js-new ...                                                       */
;*    -------------------------------------------------------------    */
;*    http://www.ecma-international.org/ecma-262/5.1/#sec-11.2.2       */
;*---------------------------------------------------------------------*/
(define (js-new %this f . args)
   (if (isa? f JsFunction)
       (with-access::JsFunction f (construct alloc)
	  (let ((o (alloc f)))
	     (let ((r (js-apply% construct (procedure-arity construct)
			 o args)))
		(if (isa? r JsObject) r o))))
       (js-raise-type-error %this
	  "new: object is not a function ~s" f)))

;*---------------------------------------------------------------------*/
;*    js-new-return ...                                                */
;*---------------------------------------------------------------------*/
(define (js-new-return f r o)
   (with-access::JsFunction f (constrsize)
      (if (isa? r JsObject)
	  (with-access::JsObject r (elements)
	     (when (vector? elements)
		(set! constrsize (vector-length elements)))
	     r)
	  (with-access::JsObject o (elements)
	     (when (vector? elements)
		(set! constrsize (vector-length elements)))
	     o))))

;*---------------------------------------------------------------------*/
;*    js-new0 ...                                                      */
;*---------------------------------------------------------------------*/
(define (js-new0 %this f)
   (if (isa? f JsFunction)
       (with-access::JsFunction f (construct alloc name constrsize)
	  (let ((o (alloc f)))
	     (let ((r (js-call0% %this construct (procedure-arity construct) o)))
		(js-new-return f r o))))
       (js-raise-type-error %this "new: object is not a function ~s" f)))

(define (js-new1 %this f a0)
   (if (isa? f JsFunction)
       (with-access::JsFunction f (construct alloc name)
	  (let ((o (alloc f)))
	     (let ((r (js-call1% %this construct (procedure-arity construct) o a0)))
		(js-new-return f r o))))
       (js-raise-type-error %this "new: object is not a function ~s" f)))

(define (js-new2 %this f a0 a1)
   (if (isa? f JsFunction)
       (with-access::JsFunction f (construct alloc)
	  (let ((o (alloc f)))
	     (let ((r (js-call2% %this construct (procedure-arity construct)
			 o a0 a1)))
		(js-new-return f r o))))
       (js-raise-type-error %this "new: object is not a function ~s" f)))

(define (js-new3 %this f a0 a1 a2)
   (if (isa? f JsFunction)
       (with-access::JsFunction f (construct alloc name)
	  (let ((o (alloc f)))
	     (let ((r (js-call3% %this construct (procedure-arity construct)
			 o a0 a1 a2)))
		(js-new-return f r o))))
       (js-raise-type-error %this "new: object is not a function ~s" f)))

(define (js-new4 %this f a0 a1 a2 a3)
   (if (isa? f JsFunction)
       (with-access::JsFunction f (construct alloc)
	  (let ((o (alloc f)))
	     (let ((r (js-call4% %this construct (procedure-arity construct)
			 o a0 a1 a2 a3)))
		(js-new-return f r o))))
       (js-raise-type-error %this "new: object is not a function ~s" f)))

;*---------------------------------------------------------------------*/
;*    js-object-alloc ...                                              */
;*---------------------------------------------------------------------*/
(define (js-object-alloc constructor::JsFunction %this::JsGlobalObject)
   (with-access::JsFunction constructor (constrsize constrmap)
      (let ((cproto (js-get constructor 'prototype %this)))
	 (instantiate::JsObject
	    (cmap constrmap)
	    (elements (make-vector constrsize (js-undefined)))
	    (__proto__ (if (isa? cproto JsObject)
			   cproto
			   (with-access::JsGlobalObject %this (__proto__)
			      __proto__)))))))

;*---------------------------------------------------------------------*/
;*    js-apply ...                                                     */
;*---------------------------------------------------------------------*/
(define (js-apply %this fun obj args)
   (if (not (isa? fun JsFunction))
       (js-raise-type-error %this "apply: argument not a function ~s" fun)
       (with-access::JsFunction fun (procedure)
	  (js-apply% procedure (procedure-arity procedure) obj args))))

;*---------------------------------------------------------------------*/
;*    js-apply% ...                                                    */
;*---------------------------------------------------------------------*/
(define (js-apply% proc::procedure arity::int obj args)
   (let ((len (+fx 1 (length args))))
      (if (<fx arity 0)
	  (let ((-arity (-fx (negfx arity) 1)))
	     (if (<=fx -arity len)
		 (apply proc obj args)
		 (let ((rest (make-list (-fx -arity len) (js-undefined))))
		    (apply proc obj (append args rest)))))
	  (cond
	     ((=fx arity len)
	      (apply proc obj args))
	     ((<fx arity len)
	      (apply proc obj (take args (-fx arity 1))))
	     (else
	      (let ((rest (make-list (-fx arity len) (js-undefined))))
		 (apply proc obj (append args rest))))))))

;*---------------------------------------------------------------------*/
;*    gen-calln ...                                                    */
;*---------------------------------------------------------------------*/
(define-macro (gen-calln . args)
   (let ((n (+fx 1 (length args))))
      `(case arity
	  ((-1)
	   (proc this ,@args))
	  ,@(map (lambda (i)
		    `((,i) 
		      ,(cond
			  ((=fx i n)
			   `(proc this ,@args))
			  ((<fx i n)
			   `(proc this ,@(take args (-fx i 1))))
			  (else
			   `(proc this ,@args
			       ,@(make-list (-fx i n)
				    '(js-undefined)))))))
	     (iota 8 1))
	  (else
	   (if (<fx arity 0)
	       (let ((min (-fx (negfx arity) 1)))
		  (apply proc this ,@args
		     (make-list (-fx min ,n) (js-undefined))))
	       (apply proc this ,@args
		  (make-list (-fx arity 8) (js-undefined))))))))

;*---------------------------------------------------------------------*/
;*    js-calln ...                                                     */
;*---------------------------------------------------------------------*/
(define (js-call0% %this proc::procedure arity::int this)
   (gen-calln))
(define (js-call1% %this proc::procedure arity::int this a0)
   (gen-calln a0))
(define (js-call2% %this proc::procedure arity::int this a0 a1)
   (gen-calln a0 a1))
(define (js-call3% %this proc::procedure arity::int this a0 a1 a2)
   (gen-calln a0 a1 a2))
(define (js-call4% %this proc::procedure arity::int this a0 a1 a2 a3)
   (gen-calln a0 a1 a2 a3))
(define (js-call5% %this proc::procedure arity::int this a0 a1 a2 a3 a4)
   (gen-calln a0 a1 a2 a3 a4))
(define (js-call6% %this proc::procedure arity::int this a0 a1 a2 a3 a4 a5)
   (gen-calln a0 a1 a2 a3 a4 a5))
(define (js-call7% %this proc::procedure arity::int this a0 a1 a2 a3 a4 a5 a6)
   (gen-calln a0 a1 a2 a3 a4 a5 a6))
(define (js-call8% %this proc::procedure arity::int this a0 a1 a2 a3 a4 a5 a6 a7)
   (gen-calln a0 a1 a2 a3 a4 a5 a6 a7))

(define (js-call0 %this fun this)
   (if (not (isa? fun JsFunction))
       (js-raise-type-error %this
	  "call: not a function ~s" fun)
       (with-access::JsFunction fun (procedure)
	  (js-call0% %this procedure (procedure-arity procedure)
	     this))))
(define (js-call1 %this fun this a0)
   (if (not (isa? fun JsFunction))
       (js-raise-type-error %this
	  "call: not a function ~s" fun)
       (with-access::JsFunction fun (procedure)
	  (js-call1% %this procedure (procedure-arity procedure)
	     this a0))))
(define (js-call2 %this fun this a0 a1)
   (if (not (isa? fun JsFunction))
       (js-raise-type-error %this
	  "call: not a function ~s" fun)
       (with-access::JsFunction fun (procedure)
	  (js-call2% %this procedure (procedure-arity procedure)
	     this a0 a1))))
(define (js-call3 %this fun this a0 a1 a2)
   (if (not (isa? fun JsFunction))
       (js-raise-type-error %this
	  "call: not a function ~s" fun)
       (with-access::JsFunction fun (procedure)
	  (js-call3% %this procedure (procedure-arity procedure)
	     this a0 a1 a2))))
(define (js-call4 %this fun this a0 a1 a2 a3)
   (if (not (isa? fun JsFunction))
       (js-raise-type-error %this
	  "call: not a function ~s" fun)
       (with-access::JsFunction fun (procedure)
	  (js-call4% %this procedure (procedure-arity procedure)
	     this a0 a1 a2 a3))))
(define (js-call5 %this fun this a0 a1 a2 a3 a4)
   (if (not (isa? fun JsFunction))
       (js-raise-type-error %this
	  "call: not a function ~s" fun)
       (with-access::JsFunction fun (procedure)
	  (js-call5% %this procedure (procedure-arity procedure)
	     this a0 a1 a2 a3 a4))))
(define (js-call6 %this fun this a0 a1 a2 a3 a4 a5)
   (if (not (isa? fun JsFunction))
       (js-raise-type-error %this
	  "call: not a function ~s" fun)
       (with-access::JsFunction fun (procedure)
	  (js-call6% %this procedure (procedure-arity procedure)
	     this a0 a1 a2 a3 a4 a5))))
(define (js-call7 %this fun this a0 a1 a2 a3 a4 a5 a6)
   (if (not (isa? fun JsFunction))
       (js-raise-type-error %this
	  "call: not a function ~s" fun)
       (with-access::JsFunction fun (procedure)
	  (js-call7% %this procedure (procedure-arity procedure)
	     this a0 a1 a2 a3 a4 a5 a6))))
(define (js-call8 %this fun this a0 a1 a2 a3 a4 a5 a6 a7)
   (if (not (isa? fun JsFunction))
       (js-raise-type-error %this
	  "call: not a function ~s" fun)
       (with-access::JsFunction fun (procedure arity)
	  (js-call8% %this procedure (procedure-arity procedure)
	     this a0 a1 a2 a3 a4 a5 a6 a7))))

(define (js-calln %this fun this . args)
   (if (not (isa? fun JsFunction))
       (js-raise-type-error %this "call: not a function ~s" fun)
       (with-access::JsFunction fun (procedure)
	  (let ((arity (procedure-arity procedure)))
	     (if (<fx arity 0)
		 (apply procedure this args)
		 (let ((len (length args)))
		    (cond
		       ((=fx arity len)
			(apply procedure this args))
		       ((<fx arity len)
			(apply procedure this (take args (-fx arity len))))
		       (else
			(apply procedure this
			   (append args
			      (make-list (-fx arity len))
			      (js-undefined)))))))))))

(define (js-call0/debug %this loc fun this)
   (if (not (isa? fun JsFunction))
       (js-raise-type-error/loc %this
	  loc "call: not a function ~s" fun)
       (with-access::JsFunction fun (procedure (fname name))
	  (let ((env (current-dynamic-env))
		(name fname))
	     ($env-push-trace env name loc)
	     (let ((aux (js-call0% %this procedure (procedure-arity procedure)
			   this)))
		($env-pop-trace env)
		aux)))))
(define (js-call1/debug %this loc fun this a0)
   (if (not (isa? fun JsFunction))
       (js-raise-type-error/loc %this
	  loc "call: not a function ~s" fun)
       (with-access::JsFunction fun (procedure (fname name))
	  (let ((env (current-dynamic-env))
		(name fname))
	     ($env-push-trace env name loc)
	     (let ((aux (js-call1% %this procedure (procedure-arity procedure)
			   this a0)))
		($env-pop-trace env)
		aux)))))

(define (js-call2/debug %this loc fun this a0 a1)
   (if (not (isa? fun JsFunction))
       (js-raise-type-error/loc %this
	  loc "call: not a function ~s" fun)
       (with-access::JsFunction fun (procedure (fname name))
	  (let ((env (current-dynamic-env))
		(name fname))
	     ($env-push-trace env name loc)
	     (let ((aux (js-call2% %this procedure (procedure-arity procedure)
			   this a0 a1)))
		($env-pop-trace env)
		aux)))))
(define (js-call3/debug %this loc fun this a0 a1 a2)
   (if (not (isa? fun JsFunction))
       (js-raise-type-error/loc %this
	  loc "call: not a function ~s" fun)
       (with-access::JsFunction fun (procedure (fname name))
	  (let ((env (current-dynamic-env))
		(name fname))
	     ($env-push-trace env name loc)
	     (let ((aux (js-call3% %this procedure (procedure-arity procedure)
			   this a0 a1 a2)))
		($env-pop-trace env)
		aux)))))
(define (js-call4/debug %this loc fun this a0 a1 a2 a3)
   (if (not (isa? fun JsFunction))
       (js-raise-type-error/loc %this
	  loc "call: not a function ~s" fun)
       (with-access::JsFunction fun (procedure (fname name))
	  (let ((env (current-dynamic-env))
		(name fname))
	     ($env-push-trace env name loc)
	     (let ((aux (js-call4% %this procedure (procedure-arity procedure)
			   this a0 a1 a2 a3)))
		($env-pop-trace env)
		aux)))))
(define (js-call5/debug %this loc fun this a0 a1 a2 a3 a4)
   (if (not (isa? fun JsFunction))
       (js-raise-type-error/loc %this
	  loc "call: not a function ~s" fun)
       (with-access::JsFunction fun (procedure (fname name))
	  (let ((env (current-dynamic-env))
		(name fname))
	     ($env-push-trace env name loc)
	     (let ((aux (js-call5% %this procedure (procedure-arity procedure)
			   this a0 a1 a2 a3 a4)))
		($env-pop-trace env)
		aux)))))
(define (js-call6/debug %this loc fun this a0 a1 a2 a3 a4 a5)
   (if (not (isa? fun JsFunction))
       (js-raise-type-error/loc %this
	  loc "call: not a function ~s" fun)
       (with-access::JsFunction fun (procedure (fname name))
	  (let ((env (current-dynamic-env))
		(name fname))
	     ($env-push-trace env name loc)
	     (let ((aux (js-call6% %this procedure (procedure-arity procedure)
			   this a0 a1 a2 a3 a4 a5)))
		($env-pop-trace env)
		aux)))))
(define (js-call7/debug %this loc fun this a0 a1 a2 a3 a4 a5 a6)
   (if (not (isa? fun JsFunction))
       (js-raise-type-error/loc %this
	  loc "call: not a function ~s" fun)
       (with-access::JsFunction fun (procedure (fname name))
	  (let ((env (current-dynamic-env))
		(name fname))
	     ($env-push-trace env name loc)
	     (let ((aux (js-call7% %this procedure (procedure-arity procedure)
			   this a0 a1 a2 a3 a4 a5 a6)))
		($env-pop-trace env)
		aux)))))
(define (js-call8/debug %this loc fun this a0 a1 a2 a3 a4 a5 a6 a7)
   (if (not (isa? fun JsFunction))
       (js-raise-type-error/loc %this
	  loc "call: not a function ~s" fun)
       (with-access::JsFunction fun (procedure (fname name))
	  (let ((env (current-dynamic-env))
		(name fname))
	     ($env-push-trace env name loc)
	     (let ((aux (js-call8% %this procedure (procedure-arity procedure)
			   this a0 a1 a2 a3 a4 a5 a6 a7)))
		($env-pop-trace env)
		aux)))))
(define (js-calln/debug %this loc fun this . args)
   (if (not (isa? fun JsFunction))
       (js-raise-type-error/loc %this
	  loc "call: not a function ~s" fun)
       (with-access::JsFunction fun (procedure (fname name))
	  (let ((env (current-dynamic-env))
		(name fname)
		(arity (procedure-arity procedure)))
	     ($env-push-trace env name loc)
	     (let ((aux (if (<fx arity 0)
			   (apply procedure this args)
			   (let ((len (length args)))
			      (cond
				 ((=fx arity len)
				  (apply procedure this args))
				 ((<fx arity len)
				  (apply procedure this
				     (take args (-fx arity len))))
				 (else
				  (apply procedure this
				     (append args
					(make-list (-fx arity len))
					(js-undefined)))))))))
		($env-pop-trace env)
		aux)))))

;*---------------------------------------------------------------------*/
;*    js-instanceof? ...                                               */
;*    -------------------------------------------------------------    */
;*    http://www.ecma-international.org/ecma-262/5.1/#sec-11.8.6       */
;*    http://www.ecma-international.org/ecma-262/5.1/#sec-15.3.4.5.3   */
;*    http://www.ecma-international.org/ecma-262/5.1/#sec-15.3.5.3     */
;*---------------------------------------------------------------------*/
(define (js-instanceof? v f %this)
   (if (not (isa? f JsFunction))
       (js-raise-type-error %this
	  "instanceof: not a function ~s" f)
       (when (isa? v JsObject)
	  (let ((o (js-getvalue f f 'prototype #f %this)))
	     (if (not (isa? o JsObject))
		 (js-raise-type-error %this
		    "instanceof: no prototype ~s" v)
		 (let loop ((v v))
		    (with-access::JsObject v ((v __proto__))
		       (cond
			  ((eq? o v) #t)
			  ((eq? v (js-null)) #f)
			  (else (loop v))))))))))

;*---------------------------------------------------------------------*/
;*    js-in? ...                                                       */
;*    -------------------------------------------------------------    */
;*    http://www.ecma-international.org/ecma-262/5.1/#sec-11.8.7       */
;*---------------------------------------------------------------------*/
(define (js-in? field obj %this)
   (if (not (isa? obj JsObject))
       (js-raise-type-error %this "in: not a object ~s" obj)
       (js-has-property obj (js-toname field %this))))

;*---------------------------------------------------------------------*/
;*    js-totest ...                                                    */
;*    -------------------------------------------------------------    */
;*    http://www.ecma-international.org/ecma-262/5.1/#sec-12.5         */
;*---------------------------------------------------------------------*/
(define-inline (js-totest obj)
   (if (boolean? obj) obj (js-toboolean obj)))
      
;*---------------------------------------------------------------------*/
;*    js-toboolean ...                                                 */
;*    -------------------------------------------------------------    */
;*    http://www.ecma-international.org/ecma-262/5.1/#sec-9.2          */
;*---------------------------------------------------------------------*/
(define (js-toboolean obj)
   (cond
      ((boolean? obj) obj)
      ((eq? obj (js-undefined)) #f)
      ((eq? obj (js-null)) #f)
      ((number? obj) (not (or (= obj 0) (and (flonum? obj) (nanfl? obj)))))
      ((string? obj) (>fx (string-length obj) 0))
      (else #t)))

;*---------------------------------------------------------------------*/
;*    js-tonumber ::obj ...                                            */
;*    -------------------------------------------------------------    */
;*    http://www.ecma-international.org/ecma-262/5.1/#sec-9.3          */
;*---------------------------------------------------------------------*/
(define-generic (js-tonumber obj %this::JsGlobalObject)
   (let loop ((obj obj))
      (cond
	 ((number? obj)
	  obj)
	 ((eq? obj (js-undefined))
	  +nan.0)
	 ((eq? obj (js-null))
	  0)
	 ((eq? obj #t)
	  1)
	 ((eq? obj #f)
	  0)
	 ((string? obj)
	  (let ((str (trim-whitespaces+ obj :left #t :right #t :plus #t)))
	     (cond
		((string=? str "Infinity")
		 +inf.0)
		((string=? str "+Infinity")
		 +inf.0)
		((string=? str "-Infinity")
		 -inf.0)
		((string=? str "NaN")
		 +nan.0)
		((string-null? str)
		 0)
		((or (string-prefix? "0x" str) (string-prefix? "0X" str))
		 (js-parseint str 16 #t %this))
		((string-index str "eE.")
		 (js-parsefloat str #t %this))
		(else
		 (js-parseint str 10 #t %this)))))
	 ((symbol? obj)
	  (loop (symbol->string! obj)))
	 (else
	  (bigloo-type-error "toNumber" "JsObject" obj)))))

;*---------------------------------------------------------------------*/
;*    js-tointeger ::obj ...                                           */
;*    -------------------------------------------------------------    */
;*    http://www.ecma-international.org/ecma-262/5.1/#sec-9.4          */
;*---------------------------------------------------------------------*/
(define-generic (js-tointeger obj %this::JsGlobalObject)
   (cond
      ((fixnum? obj)
       obj)
      ((flonum? obj)
       (cond
	  ((nanfl? obj) 0)
	  ((or (=fl obj +inf.0) (=fl obj -inf.0))
	   obj)
	  ((<fl obj 0.)
	   (*fl -1. (floor (abs obj))))
	  (else
	   (floor obj))))
      ((or (string? obj) (symbol? obj))
       (js-tointeger (js-tonumber obj %this) %this))
      ((eq? obj #t)
       1)
      (else 0)))

;*---------------------------------------------------------------------*/
;*    js-touint16 ::obj ...                                            */
;*    -------------------------------------------------------------    */
;*    http://www.ecma-international.org/ecma-262/5.1/#sec-9.7          */
;*---------------------------------------------------------------------*/
(define (js-touint16::uint16 obj %this)
   
   (define 2^16 (exptfl 2. 16.))
   
   (define (uint32->uint16 o)
      (fixnum->uint16 (uint32->fixnum o)))
   
   (define (positive-double->uint16::uint16 obj::double)
      (uint32->uint16
	 (if (<fl obj 2^16)
	     (flonum->uint32 obj)
	     (flonum->uint32 (remainderfl obj 2^16)))))
   
   (define (double->uint16::uint16 obj::double)
      (cond
	 ((or (= obj +inf.0) (= obj -inf.0) (not (= obj obj)))
	  #u16:0)
	 ((<fl obj 0.)
	  (positive-double->uint16 (+fl 2^16 (*fl -1. (floor (abs obj))))))
	 (else
	  (positive-double->uint16 obj))))
   
   (cond
      ((fixnum? obj) (modulofx obj (bit-lsh 1 16)))
      ((flonum? obj) (double->uint16 obj))
      (else (js-touint16 (js-tointeger obj %this) %this))))

;*---------------------------------------------------------------------*/
;*    js-touint32 ::obj ...                                            */
;*    -------------------------------------------------------------    */
;*    http://www.ecma-international.org/ecma-262/5.1/#sec-9.6          */
;*---------------------------------------------------------------------*/
(define (js-touint32::uint32 obj %this)
   
   (define 2^32 (exptfl 2. 32.))
   
   (define (positive-double->uint32::uint32 obj::double)
      (if (<fl obj 2^32)
	  (flonum->uint32 obj)
	  (flonum->uint32 (remainderfl obj 2^32))))

   (define (double->uint32::uint32 obj::double)
      (cond
	 ((or (= obj +inf.0) (= obj -inf.0) (not (= obj obj)))
	   #u32:0)
	 ((<fl obj 0.)
	  (positive-double->uint32 (+fl 2^32 (*fl -1. (floor (abs obj))))))
	 (else
	  (positive-double->uint32 obj))))
   
   (cond
      ((uint32? obj)
       (let ((r::uint32 obj)) r))
      ((int32? obj)
       (int32->uint32 obj))
      ((fixnum? obj)
       (cond-expand
	  (bint30
	   (fixnum->uint32 obj))
	  (bint32
	   (int32->uint32 (fixnum->int32 obj)))
	  (else
	   (if (<=fx obj (-fx (bit-lsh 1 32) 1))
	       (fixnum->uint32 obj)
	       (let* ((^31 (bit-lsh 1 31))
		      (^32 (bit-lsh 1 32))
		      (posint (if (<fx obj 0) (+fx ^32 obj) obj))
		      (int32bit (modulofx posint ^32)))
		  (fixnum->uint32 int32bit))))))
      ((flonum? obj)
       (double->uint32 obj))
      (else
       (js-touint32 (js-tointeger obj %this) %this))))
		  
;*---------------------------------------------------------------------*/
;*    js-toint32 ::obj ...                                             */
;*    -------------------------------------------------------------    */
;*    http://www.ecma-international.org/ecma-262/5.1/#sec-9.5          */
;*---------------------------------------------------------------------*/
(define (js-toint32::int32 obj %this)

   (define (int64->int32::int32 obj::int64)
      (cond-expand
	 ((or bint30 bint32)
	  (let* ((i::llong (int64->llong obj))
		 (^31 (*llong #l8 (fixnum->llong (bit-lsh 1 28))))
		 (^32 (*llong #l2 ^31))
		 (posint (if (<llong i #l0) (+llong ^32 i) i))
		 (int32bit (modulollong posint ^32))
		 (n (if (>=llong int32bit ^31)
			(-llong int32bit ^32)
			int32bit)))
	     (llong->int32 n)))
	 (else
	  (let* ((i::elong (int64->elong obj))
		 (^31 (fixnum->elong (bit-lsh 1 31)))
		 (^32 (fixnum->elong (bit-lsh 1 32)))
		 (posint (if (<elong i #e0) (+elong ^32 i) i))
		 (int32bit (moduloelong posint ^32))
		 (n (if (>=elong int32bit ^31)
			(-elong int32bit ^32)
			int32bit)))
	     (elong->int32 n)))))

   (cond
      ((int32? obj)
       obj)
      ((uint32? obj)
       (uint32->int32 obj))
      ((fixnum? obj)
       (cond-expand
	  ((or bint30 bint32)
	   (fixnum->int32 obj))
	  (bint61
	   (if (and (<=fx obj (-fx (bit-lsh 1 31) 1))
		    (>=fx obj (negfx (bit-lsh 1 31))))
	       (fixnum->int32 obj)
	       (let* ((^31 (bit-lsh 1 31))
		      (^32 (bit-lsh 1 32))
		      (posint (if (<fx obj 0) (+fx ^32 obj) obj))
		      (int32bit (modulofx posint ^32))
		      (n (if (>=fx int32bit ^31)
			     (-fx int32bit ^32)
			     int32bit)))
		  (fixnum->int32 n))))
	  (else
	   (int64->int32 (fixnum->int64 obj)))))
      ((flonum? obj)
       (cond
	  ((or (= obj +inf.0) (= obj -inf.0) (nanfl? obj))
	   (fixnum->int32 0))
	  ((<fl obj 0.)
	   (let ((i (*fl -1. (floor (abs obj)))))
	      (if (>=fl i (negfl (exptfl 2. 31.)))
		  (fixnum->int32 (flonum->fixnum i))
		  (int64->int32 (flonum->int64 i)))))
	  (else
	   (let ((i (floor obj)))
	      (if (<=fl i (-fl (exptfl 2. 31.) 1.))
		  (fixnum->int32 (flonum->fixnum i))
		  (int64->int32 (flonum->int64 i)))))))
      (else
       (js-toint32 (js-tonumber obj %this) %this))))

;*---------------------------------------------------------------------*/
;*    js-tostring ...                                                  */
;*    -------------------------------------------------------------    */
;*    http://www.ecma-international.org/ecma-262/5.1/#sec-9.8          */
;*---------------------------------------------------------------------*/
(define (js-tostring obj %this::JsGlobalObject)
   (cond
      ((isa? obj JsObject)
       (js-tostring (js-toprimitive obj 'string %this) %this))
      ((string? obj)
       obj)
      ((eq? obj (js-undefined))
       "undefined")
      ((eq? obj #t)
       "true")
      ((eq? obj #f)
       "false")
      ((eq? obj (js-null))
       "null")
      ((number? obj)
       (js-number->string obj))
      ((symbol? obj)
       (symbol->string! obj)) 
      (else
       (typeof obj))))

;*---------------------------------------------------------------------*/
;*    js-toobject ...                                                  */
;*    -------------------------------------------------------------    */
;*    http://www.ecma-international.org/ecma-262/5.1/#sec-9.9          */
;*---------------------------------------------------------------------*/
(define (js-toobject %this::JsGlobalObject o)
   (cond
      ((string? o)
       (with-access::JsGlobalObject %this (js-string)
	  (js-new1 %this js-string o)))
      ((number? o)
       (with-access::JsGlobalObject %this (js-number)
	  (js-new1 %this js-number o)))
      ((boolean? o)
       (with-access::JsGlobalObject %this (js-boolean)
	  (js-new1 %this js-boolean o)))
      ((isa? o JsObject)
       o)
      (else
       (js-raise-type-error %this "toObject: cannot convert ~s" o))))

;*---------------------------------------------------------------------*/
;*    js-equal? ...                                                    */
;*    -------------------------------------------------------------    */
;*    http://www.ecma-international.org/ecma-262/5.1/#sec-11.9.1       */
;*---------------------------------------------------------------------*/
(define-inline (js-equal? o1 o2 %this::JsGlobalObject)
   (or (and (not (flonum? o1)) (eq? o1 o2)) (js-equality? o1 o2 %this)))

;*---------------------------------------------------------------------*/
;*    js-equality? ...                                                 */
;*    -------------------------------------------------------------    */
;*    http://www.ecma-international.org/ecma-262/5.1/#sec-11.9.3       */
;*---------------------------------------------------------------------*/
(define (js-equality? x y %this::JsGlobalObject)
   (let equality? ((x x)
		   (y y))
      (cond
	 ((eq? x y)
	  (not (and (flonum? x) (nanfl? x))))
	 ((eq? x (js-null))
	  (eq? y (js-undefined)))
	 ((eq? x (js-undefined))
	  (eq? y (js-null)))
	 ((number? x)
	  (cond
	     ((number? y)
	      (= x y))
	     ((string? y)
	      (if (= x 0)
		  (or (string-null? y) (equality? x (js-tonumber y %this)))
		  (equality? x (js-tonumber y %this))))
	     ((isa? y JsObject)
	      (equality? x (js-toprimitive y 'any %this)))
	     ((boolean? y)
	      (equality? x (js-tonumber y %this)))
	     (else #f)))
	 ((string? x)
	  (cond
	     ((string? y)
	      (string=? x y))
	     ((number? y)
	      (if (= y 0)
		  (or (string-null? x) (equality? (js-tonumber x %this) y))
		  (equality? (js-tonumber x %this) y)))
	     ((isa? y JsObject)
	      (equality? x (js-toprimitive y 'any %this)))
	     ((eq? y #f)
	      (string-null? x))
	     ((boolean? y)
	      (equality? x (js-tonumber y %this)))
	     (else #f)))
	 ((boolean? x)
	  (cond
	     ((boolean? y)
	      #f)
	     (else
	      (equality? (js-tonumber x %this) y))))
	 ((boolean? y)
	  (equality? x (js-tonumber y %this)))
	 ((isa? x JsObject)
	  (cond
	     ((string? y) (equality? (js-toprimitive x 'any %this) y))
	     ((number? y) (equality? (js-toprimitive x 'any %this) y))
	     (else #f)))
	 (else
	  #f))))

;*---------------------------------------------------------------------*/
;*    js-strict-equal?                                                 */
;*    -------------------------------------------------------------    */
;*    http://www.ecma-international.org/ecma-262/5.1/#sec-11.9.4       */
;*---------------------------------------------------------------------*/
(define-inline (js-strict-equal? o1 o2)
   (or (and (eq? o1 o2) (not (flonum? o1))) (js-eq? o1 o2)))

;*---------------------------------------------------------------------*/
;*    js-eq? ...                                                       */
;*---------------------------------------------------------------------*/
(define (js-eq? x y)
   (cond
      ((number? x) (and (number? y) (= x y)))
      ((string? x) (and (string? y) (string=? x y)))
      (else #f)))

;*---------------------------------------------------------------------*/
;*    make-pcache ...                                                  */
;*---------------------------------------------------------------------*/
(define (make-pcache len)
   (let ((pcache ($make-vector-uncollectable len #unspecified)))
      (let loop ((i 0))
	 (if (=fx i len)
	     pcache
	     (begin
		(vector-set-ur! pcache i (instantiate::JsPropertyCache))
		(loop (+fx i 1)))))))
      
;*---------------------------------------------------------------------*/
;*    pcache-ref ...                                                   */
;*---------------------------------------------------------------------*/
(define-inline (pcache-ref pcache index)
   (vector-ref-ur pcache index))

;*---------------------------------------------------------------------*/
;*    %js-eval-strict ...                                              */
;*---------------------------------------------------------------------*/
(define (%js-eval-strict string %this)
   (call-with-input-string (string-append "\"use strict\";\n" string)
      (lambda (ip)
	 (%js-eval ip 'eval %this))))

;*---------------------------------------------------------------------*/
;*    %js-hss ...                                                      */
;*---------------------------------------------------------------------*/
(define (%js-eval-hss ip::input-port %this %worker)
;*    (%js-eval ip 'repl %this))                                       */
   (js-worker-exec %worker
      (lambda ()
	 (%js-eval ip 'repl %this))))

;*---------------------------------------------------------------------*/
;*    js-raise ...                                                     */
;*---------------------------------------------------------------------*/
(define (js-raise err)
   (with-access::JsError err (stack)
      (set! stack (get-trace-stack))
      (raise err)))
