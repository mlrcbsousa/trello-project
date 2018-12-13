//= require rails-ujs
// = require_tree .

$('document').ready(function(){
  var count = 0;
  $('.step').each(function(){
    count++;

  });

  var i = 0;
  //NEXT
  $('#next').on('click', function(){
    if(count > i +1 ){
        i++;
        $('.active').removeClass('active');
        $('.step').eq(i).addClass('active');
       }
  });
    //PREV
  $('#prev').on('click', function(){
   if(i > 0 ){
    i--;
    $('.active').removeClass('active');
    $('.step').eq(i).addClass('active');
   }
  });
});
