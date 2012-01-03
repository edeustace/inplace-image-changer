<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8" />
        <title>Inplace image changer demo</title>
        <link rel="stylesheet" href="css/styles.css" />
        <script type="text/javascript" src="js/jquery-1.7.1.min.js"></script>
		    <script type="text/javascript" src="js/multipart.form.builder.js"></script> 
        <script type="text/javascript" src="js/inplace.image.changer.js"></script>
        <script type="text/javascript" src="http://fgnass.github.com/spin.js/spin.min.js"></script>
        <script type="text/javascript">
          $(document).ready(function(){

            $(".inplace_image").inplaceImageChanger({
                  onLocalFileTooBig: function( fileSize, maxSize){ alert('too big')}, 
                  onLoadStart : function( $element ){
                  var w = $element.find('img').width();
                  var h = $element.find('img').height();
                  var box = "<div style='background-color: #ff00ff; width: "+w+"px; height: "+ h +"px;'>";

                  var opts = {
                      lines: 14, 
                      length: 7, 
                      width: 4, 
                      radius: 10, 
                      color: '#fff', 
                      speed: 1, 
                      trail: 60, 
                      shadow: false 
                      };
                   $element.html( box );
                   var target = $element.find('div')[0];

                   if( typeof(Spinner) != "undefined")
                   {
                      new Spinner(opts).spin(target);
                   }
                }
            });
          });
        </script>
    </head>
    
    <body>
		<header>
			<h1>Inplace Image changer example, click on the image to upload a new one</h1>
		</header>

      <img class="inplace_image"
        href="img/smiley.png"
        form-name="image"
        form-url="/example/UploadImage">

      <br/>
      <br/>
      <div>Won't auto save because no form-url is specified</div>
      <img class="inplace_image"
        href="img/smiley.png">

    </body>
</html>

