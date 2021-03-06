;*=====================================================================*/
;*    serrano/prgm/project/hop/3.0.x/js2scheme/property.scm            */
;*    -------------------------------------------------------------    */
;*    Author      :  Manuel Serrano                                    */
;*    Creation    :  Tue Oct  8 09:03:28 2013                          */
;*    Last change :  Fri Jul  3 16:15:50 2015 (serrano)                */
;*    Copyright   :  2013-15 Manuel Serrano                            */
;*    -------------------------------------------------------------    */
;*    Init the this variable of all function in non-strict mode        */
;*=====================================================================*/

;*---------------------------------------------------------------------*/
;*    The module                                                       */
;*---------------------------------------------------------------------*/
(module __js2scheme_property

   (import __js2scheme_ast
	   __js2scheme_dump
	   __js2scheme_compile
	   __js2scheme_stage
	   __js2scheme_utils)

   (export j2s-property-stage
	   (generic j2s-property ::obj ::obj)))

;*---------------------------------------------------------------------*/
;*    j2s-property-stage ...                                           */
;*---------------------------------------------------------------------*/
(define j2s-property-stage
   (instantiate::J2SStageProc
      (name "property")
      (comment "Add a cache to each object property lookup")
      (proc j2s-property)
      (optional #t)))

;*---------------------------------------------------------------------*/
;*    j2s-property ...                                                 */
;*---------------------------------------------------------------------*/
(define-generic (j2s-property this args)
   this)

;*---------------------------------------------------------------------*/
;*    j2s-property ::J2SProgram ...                                    */
;*---------------------------------------------------------------------*/
(define-method (j2s-property this::J2SProgram args)
   (with-access::J2SProgram this (nodes headers decls loc pcache-size)
      (let* ((count (make-counter 0))
	     (caches (append
			(append-map (lambda (s) (property* s count)) headers)
			(append-map (lambda (s) (property* s count)) decls)
			(append-map (lambda (s) (property* s count)) nodes))))
	 (set! pcache-size (get count))))
   this)

;*---------------------------------------------------------------------*/
;*    make-counter ...                                                 */
;*---------------------------------------------------------------------*/
(define (make-counter val)
   (make-cell val))

;*---------------------------------------------------------------------*/
;*    inc! ...                                                         */
;*---------------------------------------------------------------------*/
(define (inc! count)
   (let ((c (cell-ref count)))
      (cell-set! count (+fx c 1))
      c))

;*---------------------------------------------------------------------*/
;*    get ...                                                          */
;*---------------------------------------------------------------------*/
(define (get count)
   (cell-ref count))

;*---------------------------------------------------------------------*/
;*    property* ::J2SNode ...                                          */
;*---------------------------------------------------------------------*/
(define-walk-method (property* this::J2SNode count)
   (call-default-walker))

;*---------------------------------------------------------------------*/
;*    property* ::J2SAccess ...                                        */
;*---------------------------------------------------------------------*/
(define-walk-method (property* this::J2SAccess count)
   (with-access::J2SAccess this (cache)
      (set! cache (inc! count))
      (cons cache (call-default-walker))))

;*---------------------------------------------------------------------*/
;*    property* ::J2SUnresolvedRef ...                                 */
;*---------------------------------------------------------------------*/
(define-walk-method (property* this::J2SUnresolvedRef count)
   (with-access::J2SUnresolvedRef this (cache)
      (set! cache (inc! count))
      (cons cache (call-default-walker))))
