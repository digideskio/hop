;*=====================================================================*/
;*    .../prgm/project/hop/2.2.x/arch/android/hopdroid/contact.scm     */
;*    -------------------------------------------------------------    */
;*    Author      :  Manuel Serrano                                    */
;*    Creation    :  Mon Oct 25 09:16:32 2010                          */
;*    Last change :  Mon Oct 25 12:20:59 2010 (serrano)                */
;*    Copyright   :  2010 Manuel Serrano                               */
;*    -------------------------------------------------------------    */
;*    Android contact binding                                          */
;*=====================================================================*/

;*---------------------------------------------------------------------*/
;*    The module                                                       */
;*---------------------------------------------------------------------*/
(module __hopdroid-contact

   (library mail phone hop)

   (import  __hopdroid-phone)

   (export (concat-get-list::obj ::phone)))

;*---------------------------------------------------------------------*/
;*    Contact plugin                                                   */
;*---------------------------------------------------------------------*/
(define contact-plugin #f)

;*---------------------------------------------------------------------*/
;*    concat-get-list ...                                              */
;*---------------------------------------------------------------------*/
(define (concat-get-list p::phone)
   (unless contact-plugin
      (set! contact-plugin (android-load-plugin p "contact")))
   (when contact-plugin
      (android-send-command/result contact-plugin #\l))) 