window.com || (window.com = {})
com.ee || (com.ee = {})

class @com.ee.MultipartFormBuilder

  constructor: (@boundary) ->
    @dashdash = "--"
    @crlf = "\r\n"

  ###
    fileParams = [
       
        {file : file (File)
        data : fileBinaryData
        paramName : name of request parameter}
      
        ...
        ]
  ###
  buildMultipartFormBody: (params, fileParams)->
    output = ""

    if params?
      $.each params, (i, val) =>
        console.log ".."
        if (typeof(val) ) == 'function' 
          val = val()
        output += @buildFormSegment i, val
    
    if fileParams?
      $.each fileParams, (i,val) =>
        output += @buildFileFormSegment val.paramName, val.file, val.data
        null
   
    output += @dashdash
    output += @boundary
    output += @dashdash
    output += @crlf
    output

  buildFormSegment: (key, value ) ->
    contentDisposition =  """Content-Disposition: form-data name='#{key}'"""
    @_buildFormSegment contentDisposition, value
  
  _buildFileContentDisposition: (formName, fileName ) ->
    @template = """Content-Disposition: form-data; name="${formName}"; filename="${fileName}" """
    out = @template.replace "${formName}", formName 
    out = out.replace "${fileName}", fileName 
    out

  buildFileFormSegment: ( formName, file, binaryData ) ->
    contentDisposition = @_buildFileContentDisposition formName, file.name 
    contentDisposition += @crlf
    contentDisposition += "Content-Type: #{file.type}"
    @_buildFormSegment contentDisposition, binaryData 

  _buildFormSegment : ( contentDisposition, value) ->
    output = ''
    output += @dashdash
    output += @boundary
    output += @crlf
    output += contentDisposition
    output += @crlf
    output += @crlf
    output += value
    output += @crlf
    output

