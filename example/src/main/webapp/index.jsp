<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8" />
        <title>Inplace image changer demo</title>
        <link rel="stylesheet" href="css/styles.css" />
        <script type="text/javascript" src="js/jquery-1.7.1.min.js"></script>
		    <script type="text/javascript" src="js/multipart.form.builder.js"></script> 
        <script type="text/javascript" src="js/inplace.image.changer.js"></script>
        <script type="text/javascript">
          $(document).ready(function(){

            var onLocalFileTooBig = function( fileSize, maxSize )
            {
              alert('too big: file size: ' + fileSize + ' max: '+ maxSize * 1024 );
              }

            $(".inplace_image").inplaceImageChanger({
                maxFileSizeInKB: 80,
                onLocalFileTooBig: onLocalFileTooBig
            });
          });
        </script>
    </head>
    
    <body>
		<header>
			<h1>Inplace Image changer example, click on the image to upload a new one</h1>
		</header>
    <div id="dropbox">

      <span class="inplace_image"
        data-original-content="img/smiley.png"
        data-form-name="image"
        data-url="/example/UploadImage">
      </span>
		</div>
    <footer>
    </footer>
    </body>
</html>

