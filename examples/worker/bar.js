/*=====================================================================*/
/*    serrano/prgm/project/hop/3.0.x/examples/worker/bar.js            */
/*    -------------------------------------------------------------    */
/*    Author      :  Manuel Serrano                                    */
/*    Creation    :  Sun Dec 21 10:55:12 2014                          */
/*    Last change :  Sun Aug  2 10:36:54 2015 (serrano)                */
/*    Copyright   :  2014-15 Manuel Serrano                            */
/*    -------------------------------------------------------------    */
/*    Worker misc                                                      */
/*    -------------------------------------------------------------    */
/*    run: hop -v -g worker.js                                         */
/*=====================================================================*/

console.log( "bar.js" );

var count = 0;

function count_inc( v ) {
   count += v;
   return count;
}

exports.count = count_inc;
