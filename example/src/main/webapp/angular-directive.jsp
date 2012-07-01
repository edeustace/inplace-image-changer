<!DOCTYPE html>
<html ng-app="ipic-sample">
    <head>
        <meta charset="utf-8" />
        <title>Inplace image changer - Angular directive demo</title>
        <link rel="stylesheet" href="css/styles.css" />
        <script type="text/javascript" src="js/jquery-1.7.1.min.js"></script>
        <script type="text/javascript" src="js/angular-1.0.0.js"></script>
        <script type="text/javascript" src="js/multipart.form.builder.js"></script> 
        <script type="text/javascript" src="js/inplace.image.changer.js"></script>
        <script type="text/javascript" src="js/inplace.image.changer.ng.directive.js"></script>
        <script type="text/javascript">

          var ipicSample = angular.module('ipic-sample', ['ipic']);

          var MainController = function($scope){
            $scope.imageUrl = "img/smiley.png";
          }
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

