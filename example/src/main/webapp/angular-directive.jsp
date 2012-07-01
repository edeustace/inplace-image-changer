<!-- angular-directive.jsp -->
<!DOCTYPE html>
<html ng-app="ipic-sample">
    <head>
        <meta charset="utf-8" />
        <title>Inplace image changer - Angular directive demo</title>
        <link rel="stylesheet" href="css/styles.css" />
        <script type="text/javascript" src="js/jquery-1.7.1.min.js"></script>
        <script type="text/javascript" src="js/angular-1.0.0.js"></script>
        <!--
        <script type="text/javascript" src="http://fgnass.github.com/spin.js/dist/spin.min.js"></script>
		    -->
        <script type="text/javascript" src="js/multipart.form.builder.js"></script> 
        <script type="text/javascript" src="js/inplace.image.changer.js"></script>
        <script type="text/javascript" src="js/inplace.image.changer.ng.directive.js"></script>
        <script type="text/javascript">


          var ipicSample = angular.module('ipic-sample', ['ipic']);

          var MainController = function($scope){

            $scope.imageUrl = "img/smiley.png";


          }



          /*$(document).ready(function(){

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
          });*/
        </script>
    </head>
    
    <body ng:controller="MainController">
		<header>
			<h1>Inplace Image changer Angular directive example, click on the image to upload a new one</h1>
		</header>

      <ipic
        model="imageUrl"
        form-name="image"
        form-url="/example/UploadImage"/>
    </body>
</html>

