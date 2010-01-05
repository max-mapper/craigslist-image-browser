$(document).ready(function() {
  $('p').css('float', 'left');
  $.getJSON('/listings', function(data) {
    jQuery.each(data, function(i, val) {
      $('#articles').append('<p style="float: left;" id='+val+'><img src="loading.gif"/></p>');
    });
    $('p').each(function() {
      var id = $(this).attr('id');
      var p = this;
      $.getJSON('/images/' + id, function(image_data){
        jQuery.each(image_data, function(date, val) {
          $(p).html('<a href="http://portland.craigslist.org/mlt/zip/'+id+'.html"<img src='+ val +'/><br/>'+date+'</a>');
        });
      });
    });
  });
});