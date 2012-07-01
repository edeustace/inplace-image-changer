## Introduction


A jquery plugin that allows you to change images 'in place', aka you click the image and you get a file chooser, and once you've selected something it gets uploaded.
Inspired by [best_in_place](https://github.com/bernat/best_in_place).


[here's a demo](http://edeustace.com/inplace/)

## Usage

    <script type="text/javascript" src="js/inplace.image.changer-with.min.js"></script>
    <script type="text/javascript">
      $(document).ready(function(){
        $(".inplace_image").inplaceImageChanger();
      });
    </script>

    ...
    
    <body>
      <img class="inplace_image"
        src="img/smiley.png"
        form-name="image"
        form-url="/example/UploadImage"/>
    </bod>
    
The img tag requires the following 3 attributes:

* href: the url to the initial image to show
* form-name: the name of the image within the post request
* form-url: the url to post the image to

The following attribute is optional: 

* custom-response-key: the key to use when reading the json response. If you use the default handler it expects the JSON response to look like: 
    { "url" : "myNewImge.png", ...}

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
    
