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
###
  
class @com.ee.InplaceImageChanger

  ###
    Options: 
      maxFileSizeInKB - the max size of files
      onLocalFileTooBig - a call back if the file size is too big
      jsonResponseUrlKey - when reading the json response, it'll use this key to create the img#href
  ###
  constructor: (imgElement, options) ->
    #@$element = $(element)

    empty = ->

    defaultOptions = 
      maxFileSizeInKB : 2000
      onProgressUpdate : empty
      onLoadStart : empty
      onLocalFileTooBig : empty
      onUploadComplete : ($element, result) => @onUploadComplete($element, result)

    if options? then @options = $.extend defaultOptions, options else @options = defaultOptions

    @$element = $("""<span></span>""")
    @$element.insertAfter $(imgElement)
    @_copyAttributes $(imgElement), @$element
    $(imgElement).remove()
    
    @_createImageTag @$element.attr 'href'
    @_createFileInput()

  _copyAttributes: ($sourceNode, $destNode) ->
    attributes = $sourceNode[0].attributes
    
    for index, attr of attributes
      if !attr.name? || !attr.nodeValue? 
        continue
      console.log "#{attr.name} : #{attr.nodeValue}"
      $destNode.attr(attr.name, attr.nodeValue)
    null

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
            name="#{@$element.attr('form-name')}">
     </input>"""
    @$element.append fileInput
    @$element.find('input').change (event) => @_handleFileSelect event
    null
  
  _handleFileSelect: (evt)->
    files = evt.target.files
    @file = evt.target.files[0]
    reader = new FileReader()
    reader.onloadend = (evt) => @_onLocalFileLoadEnd evt
    reader.readAsBinaryString @file
    null

  _onLocalFileLoadEnd: (evt) ->
    
    if @file.size > @options.maxFileSizeInKB * 1024
      if @options.onLocalFileTooBig?
        @options.onLocalFileTooBig @file.size, @options.maxFileSizeInKB
      return

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
    xhr.upload.addEventListener "progress", ((e) => @_progress e), false
    xhr.open "POST", @$element.attr('form-url'), true

    xhr.setRequestHeader 'content-type', "multipart/form-data; boundary=#{boundary}"
    xhr.setRequestHeader "Accept", "application/json"
    xhr.sendAsBinary formBody
    
    @options.onLoadStart @$element

    xhr.onload = =>
      @options.onUploadComplete @$element, xhr.responseText
 
    null

  _buildMultipartFormBody: (file, fileBinaryData, boundary) ->
    formBuilder = new com.ee.MultipartFormBuilder(boundary)
    params = @options.data
    fileParams = [
      file : file
      data : fileBinaryData
      paramName : @$element.attr 'form-name'
    ]
    formBuilder.buildMultipartFormBody params, fileParams, boundary

 
  _progress: (event) ->
    if !event.lengthComputable
      return 

    percentage = Math.round((event.loaded * 100) / event.total)

    if @currentProgress == percentage
      return
    
    @currentProgress = percentage
    @options.onProgressUpdate @$element, @file, @currentProgress
    null

  ###
  Default upload complete handler
  ###
  onUploadComplete: ($element, resultText) ->
    resultObject = $.parseJSON resultText
    customKey = @$element.attr 'custom-response-key'
    key = if customKey? then customKey else "url" 
    @_createImageTag resultObject[key]
    @_createFileInput()
    null


     
###
register with jQuery
###
jQuery.fn.inplaceImageChanger = (options)->
  this.each (index)->
    if !jQuery(this).data('com_ee_inplaceImageChanger')
      jQuery(this).data('com_ee_inplaceImageChanger', new com.ee.InplaceImageChanger(this,options))
  this

