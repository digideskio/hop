;*=====================================================================*/
;*    serrano/prgm/project/hop/2.3.x/scheme2js/module_library.scm      */
;*    -------------------------------------------------------------    */
;*    Author      :  Manuel Serrano                                    */
;*    Creation    :  Wed Nov 23 11:24:26 2011                          */
;*    Last change :  Tue Dec  6 08:39:52 2011 (serrano)                */
;*    Copyright   :  2011 Manuel Serrano                               */
;*    -------------------------------------------------------------    */
;*    Scheme2JS module library                                         */
;*=====================================================================*/

;*---------------------------------------------------------------------*/
;*    The module                                                       */
;*---------------------------------------------------------------------*/
(module module-library
   
   (import module-system
	   export-desc
	   error
	   tools)

   (static (class Lib-Unit
	      (name read-only)
	      (macros::pair-nil read-only)
	      (imports read-only)))

   (export (module-read-libraries! ::WIP-Unit ::obj ::obj ::pair-nil)))

;*---------------------------------------------------------------------*/
;*    *libraries* ...                                                  */
;*---------------------------------------------------------------------*/
(define *libraries*
   (make-hashtable 16))

;*---------------------------------------------------------------------*/
;*    *library-mutex* ...                                              */
;*---------------------------------------------------------------------*/
(define *library-mutex*
   (make-mutex))

;*---------------------------------------------------------------------*/
;*    module-read-libraries! ...                                       */
;*---------------------------------------------------------------------*/
(define (module-read-libraries! m::WIP-Unit module-resolver reader lib-list)
   (when (pair? lib-list)
      (with-access::WIP-Unit m (header imports macros)
	 (unless (every symbol? lib-list)
	    (scheme2js-error "scheme2js-module"
	       "only symbols are allowed in library-list"
	       lib-list
	       header))
	 (for-each (lambda (lib)
		      (with-access::Lib-Unit (scheme2js-get-library m lib)
			    (macros imports)
			 (with-access::WIP-Unit m ((wip-macros macros)
						   (wip-imports imports))
			    (set! wip-macros (append macros wip-macros))
			    (for-each (lambda (wim)
					 (with-access::Compilation-Unit wim
					       (exports name)
					    (set! wip-imports
					       (cons (cons name exports)
						  wip-imports))))
			       imports))))
	    lib-list))))

;*---------------------------------------------------------------------*/
;*    scheme2js-get-library ...                                        */
;*---------------------------------------------------------------------*/
(define (scheme2js-get-library m lib)
   (with-lock *library-mutex*
      (lambda ()
	 (let ((old (hashtable-get *libraries* lib)))
	    (if old
		old
		(let ((lu (scheme2js-load-library m lib)))
		   (hashtable-put! *libraries* lib lu)
		   lu))))))
		   
;*---------------------------------------------------------------------*/
;*    scheme2js-load-library ...                                       */
;*---------------------------------------------------------------------*/
(define (scheme2js-load-library m lib)
   (let ((path (let ((venv (getenv "BIGLOOLIB")))
		  (if (not venv)
		      (bigloo-library-path)
		      (cons "." (unix-path->list venv))))))
      (let ((init (find-file/path (library-init-file lib) path)))
	 (if (string? init)
	     (let ((macros (scheme2js-load-library-init init m)))
		(let ((jsheap (string-append (prefix init) ".jsheap")))
		   (if (file-exists? jsheap)
		       (instantiate::Lib-Unit
			  (name lib)
			  (macros macros)
			  (imports (scheme2js-load-library-jsheap jsheap lib)))
		       (scheme2js-error "schemejs-module"
			  "cannot find library heap"
			  jsheap
			  lib))))
	     (scheme2js-error "schemejs-module"
		"cannot find library init"
		(library-init-file lib)
		lib)))))
   
;*---------------------------------------------------------------------*/
;*    scheme2js-load-library-init ...                                  */
;*---------------------------------------------------------------------*/
(define (scheme2js-load-library-init init m::WIP-Unit)
   (let ((evmod (eval-module))
	 (macros '()))
      (unwind-protect
	 (begin
	    (eval `(module ,(gensym) (static (declare-library! . l))))
	    (eval '(define (declare-library! . l) #f))
	    (eval `(install-eval-expander 'define-expander
		      ,(lambda (x e)
			  (set! macros (cons (list x) macros)))))
	    (loadq init))
	 (when (evmodule? evmod)
	    (eval-module-set! evmod)))
      macros))

;*---------------------------------------------------------------------*/
;*    scheme2js-load-library-jsheap ...                                */
;*---------------------------------------------------------------------*/
(define (scheme2js-load-library-jsheap jsheap lib)
   (let ((heap (with-input-from-file jsheap read)))
      (match-case heap
	 ((heap ?library ?modules ?imports)
	  (map (lambda (i)
		  (let ((m (find (lambda (l) (eq? (cadr l) i)) modules)))
		     (if (pair? m)
			 (parse-imported-module i m (lambda l '()) #f)
			 (scheme2js-error "scheme2js-module"
			    "cannot find library module" i lib))))
	     (cdr imports)))
	 (else
	  (scheme2js-error "scheme2js-module"
	     "illegal jsheap file" jsheap lib)))))

