(function() {

  angular.module('ipic.directives', []);

  angular.module('ipic', ['ipic.directives']).value('ipic.config', {});

  angular.module('ipic.directives').directive('ipic', function() {
    var definition;
    definition = {
      restrict: 'E',
      replace: false,
      template: "<img/>",
      link: function(scope, element, attrs) {
        var modelName, onUploadComplete, options;
        scope._element = element;
        modelName = attrs['model'];
        $(element).removeAttr('model');
        onUploadComplete = function($element, result) {
          var resultObject;
          console.log("on Upload complete..");
          resultObject = $.parseJSON(result);
          scope.$apply(function() {
            return scope.imageUrl = resultObject.url;
          });
          console.log("scope url :: " + scope.imageUrl);
          return null;
        };
        options = {
          onUploadComplete: onUploadComplete
        };
        scope.$watch(modelName, function(newValue, oldValue, scope) {
          if (!(scope.imageChanger != null)) {
            console.log("init imageChanger");
            $(element).attr('src', newValue);
            return scope.imageChanger = new com.ee.InplaceImageChanger(element, options);
          } else {
            return scope.imageChanger.updateImageSrc(newValue);
          }
        }, true);
        return null;
      }
    };
    return definition;
  });

  /*
  Primitive arrow key handling.
  window.module.directive 'arrows',  ->
    def =
      link: (scope, element, attrs) ->
  
        LEFT = 37
        RIGHT = 39
        UP = 38
        DOWN = 40
  
        methods = {}
        methods[LEFT] = "left"
        methods[RIGHT] = "right"
        methods[UP] = "up"
        methods[DOWN] = "down"
  
        $('body').keydown (event) ->
  
          if [LEFT,RIGHT,UP,DOWN].indexOf(event.keyCode) == -1 
            return
  
          method = methods[event.keyCode]
  
          if scope.hasOwnProperty(method) and typeof(scope[method]) == "function"
            scope[method]() 
          else
            console.log("scope has no function: " + method)
    def
  
  
  InPlace Image changer directive
  See: 
  https://github.com/edeustace/inplace-image-changer
  
  Usage:
  <in-place-image-changer
    url='/waypoints/{{currentWaypoint.id}}' 
    object='waypoint' 
    attribute='img' 
    type='img' 
    custom-response-key='teeny' 
    original-content='{{currentWaypoint.thumb}}'>
   </in-place-image-changer>
  
  window.module.directive 'inplace-image-changer', ->
    definition = 
      restrict: 'E',
      replace: true,
      template: ''
  
  A Google Map
  Usage:
    <map markers="myMarkerList"/>
    Where myMarkerList is an array of objects that contain lat + lng
  
  window.module.directive 'map', -> 
    def = 
      restrict: 'E',
      replace: true,
      template: '<div></div>',
      controller: ($scope, $attrs) ->
        ctrl = this
        $scope['mapInternalController'] = ctrl
  
      # Directive link method - attach scope
      link: (scope, element, attrs) -> 
            
        mapPins = {}
  
        latDirective = attrs.latKey or "lat"
        lngDirective = attrs.lngKey or "lng"
        titleDirective = attrs.markerTitle or "title"
        currentCenterLatLng = null
  
        
        Tidy up a function added as a string attribute
        @param name - the function name to clean
        
        cleanFunction = (name) ->
          cleaned = name.replace("(", "")
          cleaned.replace(")", "")
  
        
        Create latLng from string
        @param string - a lat lng string eg: 45.1,-3.2
        @param defaultString - a default string to use if string is nil
        @return a google.maps.LatLng object.
       
        getLatLng = (string, defaultString) ->
          latLngString = string or defaultString 
          arr = latLngString.split "," 
          lat =  parseFloat(arr[0])
          lng =  parseFloat(arr[1])
          new google.maps.LatLng lat,lng 
  
        
        Get the center latLng or default value
        
        getCenter = (centerString)-> getLatLng centerString, "46.87916,-3.32910"
  
        
        Set the bounds on the google map
        @param map - the google map
        @param nw - the northwest latLng string
        @param se - the southe east latLng string
        @return nil
        
        setBounds = (map, nw, se) ->
          nwLatLng = getLatLng nw 
          seLatLng = getLatLng se
          bounds = new google.maps.LatLngBounds nwLatLng, seLatLng
          map.fitBounds bounds
          null
        
        
        Add a marker to the map
        @param - pos - a marker - the lat is accessed by using the latDirective
        
        addMarker = (pos) ->
  
          if attrs.addMarker?
            fn = cleanFunction attrs.addMarker
            scope[fn].call(this, pos)
            
          lat = eval "pos.#{latDirective}"
          lng = eval "pos.#{lngDirective}"
  
          latLng = new google.maps.LatLng(lat,lng)
  
          opts = 
            position: latLng, 
            map: map,
            title: pos[titleDirective]
  
          if attrs.iconFunction?
            fn = cleanFunction attrs.iconFunction
            opts.icon = scope[fn].call(this, pos) 
  
          marker = new google.maps.Marker opts
          mapPins[pos] = marker
          null
  
        
        Update map center
        
        updateMapCenter = (marker) ->
  
          return if !marker?
  
          lat = eval "marker.#{latDirective}"
          lng = eval "marker.#{lngDirective}"
          latLng = new google.maps.LatLng(lat,lng)
          map.panTo(latLng)
          currentCenterLatLng = latLng
          null
  
        
        Resize the map
        
        resizeMap = -> 
          google.maps.event.trigger map, "resize"
          map.setCenter currentCenterLatLng
  
  
        myOptions = 
          center: getCenter(attrs.center),
          mapTypeId: google.maps.MapTypeId.ROADMAP
        
        map = new google.maps.Map(document.getElementById(attrs.id), myOptions)
        window.googleMap = map
        setBounds map, attrs.nwBound or "46.7,-3.4", attrs.seBound or "46.95,-3.1"
  
  
        # Is the marker already on the map?
        alreadyOnMap = (pin) ->
          for index, existingPin of mapPins 
            if existingPin == pin 
              return true
          false
  
        # Watch the markers
        modelName = attrs['markers']
  
        markersWatcher = (newPins,oldPins) ->
          for index, newPin of newPins 
            if !alreadyOnMap( newPin ) 
                addMarker( newPin )
          null
  
        scope.$watch modelName, markersWatcher, true
  
        # Watch activeMarker if specified
        if attrs.activeMarker?
  
          activeMarkerWatcher = (newMarker, oldMarker) ->
            updateMapCenter newMarker
          
          scope.$watch attrs.activeMarker, activeMarkerWatcher, true
  
        # Watch update triggers
        if attrs.updateTrigger?
          triggerWatch = (newValue, oldValue) ->
            resizeMap()
  
          scope.$watch attrs.updateTrigger, triggerWatch, true
  
  
  
        null
  
  
        #end link
  */

}).call(this);
