 var showMe = function(logo){
   $(logo).fadeIn();
 };
 
 
 $(function(){   
   var $prompt = $('.prompt'),
       $input = $('input');
   
   if($input.val() === ''){
     $prompt.show();
   }
      
      
   $input.focus(function(){
     $prompt.hide();
   }).blur(function(){
     if($input.val() === ''){
       $prompt.show();
     }

   });

  $('form').submit(function(){
    $('body').addClass('blue');
    $('button').attr("disabled", "true");
    $('form').attr("disabled", "true");
    $('div#form').fadeOut();
  });
   
});


function sendName(name){
  $.post('/check_name', {username: name}, function(data){
    console.log('boo', data);
    location.href = "/?username=" + name;
  });
}