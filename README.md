## Introduction
A jquery plugin that allows you to change images 'in place', aka you click the image and you get a file chooser, and once you've selected something it gets uploaded.
Inspired by [best_in_place](https://github.com/bernat/best_in_place).

## Usage

    <script type="text/javascript" src="js/inplace.image.changer-with.min.js"></script>
    <script type="text/javascript">
      $(document).ready(function(){
        $(".inplace_image").inplaceImageChanger();
      });
    </script>

    ...
    
    <body>
      
      <span class="inplace_image"
        data-original-content="img/smiley.png"
        data-form-name="image"
        data-url="/example/UploadImage">
      </span>
    </bod>
    
The element that you create should be a span and requires the following 3 attributes:

* data-original-content: the url to the initial image to show
* data-form-name: the name of the image within the post request
* data-url: the url to post the image to

Note: the naming and span may change in the near future.

### building from source (java and coffeescript on your path)
    $ cd inplace-image-changer
    $ ./create_js_libs


### Running the example (needs maven)
The example is a self-contained webapp that runs on the jetty server.

    $ cd inplace-image-changer
    $ ./run_example
    
### Browser support

* Chrome
* Firefox
* Safari - not yet
    
