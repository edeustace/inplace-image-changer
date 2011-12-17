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

  constructor: (element, options) ->
    @$element = $(element)

    defaultOptions = 
      jsonResponseUrlKey : "url"

    if options? then @options = $.extend defaultOptions, options else @options = defaultOptions

    @_createImageTag @$element.attr('data-original-content')
    @_createFileInput()

  uploadCompleted: ($element, resultText) ->
    resultObject = $.parseJSON resultText
    @_createImageTag resultObject[@options.jsonResponseUrlKey]
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
    f = evt.target.files[0]
    reader = new FileReader()
    reader.onloadend = (evt) =>
      @_onLocalFileLoadEnd evt, f
    reader.readAsBinaryString f
    null

  _onLocalFileLoadEnd: (evt, file) ->
    console.log "_onLocalFileLoadEnd"
    now = new Date().getTime()
    boundary = "------multipartformboundary#{now}"

    xhr = new XMLHttpRequest()
    xhr.open "POST", @$element.attr('data-url'), true
    xhr.setRequestHeader 'content-type', "multipart/form-data; boundary=#{boundary}"
    xhr.setRequestHeader "Accept", "application/json"
    formBody = @_buildMultipartFormBody file, evt.target.result, boundary
    xhr.sendAsBinary formBody
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

###
register with jQuery
###
jQuery.fn.inplaceImageChanger = (options)->
  this.each (index)->
    if !jQuery(this).data('com_ee_inplaceImageChanger')
      jQuery(this).data('com_ee_inplaceImageChanger', new com.ee.InplaceImageChanger(this,options))
  this

