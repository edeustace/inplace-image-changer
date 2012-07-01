# inplace.image.changer.ng.directive.coffee
# @module ipic
# Bind Angular.js modules
# Depeneds on inplace image changer
angular.module( 'ipic.directives', [])
angular.module( 'ipic', [ 'ipic.directives'] )
.value('ipic.config', {})

angular.module('ipic.directives').directive 'ipic',  ->
  definition =
    restrict: 'E'
    replace: false 
    template: """<img/>"""

    link: (scope, element, attrs) ->

      scope._element = element
      modelName = attrs['model']
      $(element).removeAttr('model');

      onUploadComplete = ($element, result) ->
        console.log "on Upload complete.."
        resultObject = $.parseJSON result

        scope.$apply ->
          scope.imageUrl = resultObject.url

        console.log "scope url :: #{scope.imageUrl}"
        null


      options = 
        onUploadComplete: onUploadComplete

      scope.$watch( modelName, (newValue, oldValue, scope) ->
        
        if !scope.imageChanger?
          $(element).attr 'src', newValue
          scope.imageChanger = new com.ee.InplaceImageChanger element, options
        else
          # TODO: should just be an update of img.src here
          scope.imageChanger.updateImageSrc newValue
      , true
      )
     
      null

  definition
