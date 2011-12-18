###
from: https://github.com/edeustace/inplace-image-changer
###

###
Add chrome support for sendAsBinary
###
if !XMLHttpRequest.prototype.sendAsBinary
  XMLHttpRequest.prototype.sendAsBinary = (dataStr)->
    byteValue = (x)->
      x.charCodeAt(0) & 0xff

    ords = Array.prototype.map.call dataStr, byteValue
    ui8a = new Uint8Array ords
    @send ui8a.buffer
    null

window.com || (window.com = {})
com.ee || (com.ee = {})


###
requires: "http://fgnass.github.com/spin.js/spin.min.js"
###
  
class @com.ee.InplaceImageChanger

  ###
    Options: 
      maxFileSizeInKB - the max size of files
      onLocalFileTooBig - a call back if the file size is too big
      jsonResponseUrlKey - when reading the json response, it'll use this key to create the img#href
  ###
  constructor: (element, options) ->
    @$element = $(element)

    defaultOptions = 
      maxFileSizeInKB : 2000
      updateProgress : @_updateProgress

    if options? then @options = $.extend defaultOptions, options else @options = defaultOptions

    console.log "maxfile size: #{@options.maxFileSizeInKB}"
    @_createImageTag @$element.attr('data-original-content')
    @_createFileInput()

  uploadCompleted: ($element, resultText) ->
    resultObject = $.parseJSON resultText
    customKey = @$element.attr 'data-custom-response-key'
    key = if customKey? then customKey else "url" 
    @_createImageTag resultObject[key]
    @_createFileInput()

    if @options.uploadCompleted?
      @options.uploadCompleted $element, resultText

  _createImageTag: (url)->
    imageTag = "<img style='cursor:pointer' src='#{url}'/>"
    @$element.html imageTag
    @$element.find('img').click (event) =>
      @$element.find('input').trigger 'click' 
    null
  
  _createFileInput: ->
    fileInput = """<input 
            style="visibility: hidden; width: 1px; height: 1px;" 
            type="file" 
            name="#{@$element.attr('data-form-name')}">
     </input>"""
    @$element.append fileInput
    @$element.find('input').change (event) => @_handleFileSelect(event)
    null
  
  _handleFileSelect: (evt)->
    console.log "_handleFileSelect"
    files = evt.target.files
    @file = evt.target.files[0]
    reader = new FileReader()
    reader.onloadend = (evt) =>
      @_onLocalFileLoadEnd evt
    reader.readAsBinaryString @file
    null

  _onLocalFileLoadEnd: (evt) ->
    
    if @file.size > @options.maxFileSizeInKB * 1024
      if @options.onLocalFileTooBig?
        @options.onLocalFileTooBig @file.size, @options.maxFileSizeInKB
      return

    console.log "_onLocalFileLoadEnd"
    now = new Date().getTime()
    boundary = "------multipartformboundary#{now}"

    formBody = @_buildMultipartFormBody @file, evt.target.result, boundary
    
    xhr = new XMLHttpRequest()
    xhr.upload.index = 0
    xhr.upload.file = @file
    xhr.upload.downloadStartTime = now;
    xhr.upload.currentStart = now;
    xhr.upload.currentProgress = 0;
    xhr.upload.startData = 0;
    
    handler = (e) =>
      @_progress e

    xhr.upload.addEventListener "progress", handler, false

    xhr.open "POST", @$element.attr('data-url'), true
   

    xhr.setRequestHeader 'content-type', "multipart/form-data; boundary=#{boundary}"
    xhr.setRequestHeader "Accept", "application/json"

    xhr.sendAsBinary formBody
    #@_createImage()  
    @_createHoldingBox()
    xhr.onload = =>
      @uploadCompleted @$element, xhr.responseText
 
    null

  _buildMultipartFormBody: (file, fileBinaryData, boundary) ->
    formBuilder = new com.ee.MultipartFormBuilder(boundary)
    params = @options.data
    fileParams = [
      file : file
      data : fileBinaryData
      paramName : @$element.attr 'data-form-name'
    ]
    formBuilder.buildMultipartFormBody params, fileParams, boundary

  _onProgress: (event) ->
    console.log "_onProgress"
    @_progress event
  
  _progress: (event) ->
    if !event.lengthComputable
      return 

    percentage = Math.round((event.loaded * 100) / event.total)
    
    console.log "%: #{percentage}, #{event.loaded}/#{event.total}"

    if @currentProgress == percentage
      return
    
    @currentProgress = percentage
    
    if @options.updateProgress? 
      @options.updateProgress(@$element, @file, @currentProgress);

  _updateProgress: ($element, file, progress) ->
    #$.data(file).find('.progress').width(progress)
    null


  _createHoldingBox: ->

    w = @$element.find('img').width()

    h = @$element.find('img').height()

    @holdingBox = """<div 
                        class='holding_animation'
                        style="width: #{w}px; height: #{h}px"></div>"""
    opts = 
      lines: 14, 
      length: 7, 
      width: 4, 
      radius: 10, 
      color: '#fff', 
      speed: 1, 
      trail: 60, 
      shadow: false 
    @$element.html @holdingBox
    target = @$element.find('.holding_animation')[0];
    spinner = new Spinner(opts).spin(target);
    null

   
###
register with jQuery
###
jQuery.fn.inplaceImageChanger = (options)->
  this.each (index)->
    if !jQuery(this).data('com_ee_inplaceImageChanger')
      jQuery(this).data('com_ee_inplaceImageChanger', new com.ee.InplaceImageChanger(this,options))
  this

