
  /*
  from: https://github.com/edeustace/inplace-image-changer
  */

  /*
  Add chrome support for sendAsBinary
  */

  if (!XMLHttpRequest.prototype.sendAsBinary) {
    XMLHttpRequest.prototype.sendAsBinary = function(dataStr) {
      var byteValue, ords, ui8a;
      byteValue = function(x) {
        return x.charCodeAt(0) & 0xff;
      };
      ords = Array.prototype.map.call(dataStr, byteValue);
      ui8a = new Uint8Array(ords);
      this.send(ui8a.buffer);
      return null;
    };
  }

  window.com || (window.com = {});

  com.ee || (com.ee = {});

  this.com.ee.FileUploader = (function() {

    function FileUploader(file, binaryData, url, name, options) {
      var boundary, formBody, now, xhr;
      var _this = this;
      this.file = file;
      this.binaryData = binaryData;
      this.url = url;
      this.name = name;
      this.options = options;
      now = new Date().getTime();
      boundary = "------multipartformboundary" + now;
      formBody = this._buildMultipartFormBody(this.file, this.binaryData, boundary);
      xhr = new XMLHttpRequest();
      xhr.upload.index = 0;
      xhr.upload.file = this.file;
      xhr.upload.downloadStartTime = now;
      xhr.upload.currentStart = now;
      xhr.upload.currentProgress = 0;
      xhr.upload.startData = 0;
      xhr.open("POST", this.url, true);
      xhr.setRequestHeader('content-type', "multipart/form-data; boundary=" + boundary);
      xhr.setRequestHeader("Accept", "application/json");
      xhr.sendAsBinary(formBody);
      if (this.options.onLoadStart != null) this.options.onLoadStart();
      xhr.onload = function() {
        if (_this.options.onUploadComplete != null) {
          return _this.options.onUploadComplete(xhr.responseText);
        }
      };
    }

    FileUploader.prototype._buildMultipartFormBody = function(file, fileBinaryData, boundary) {
      var fileParams, formBuilder, params;
      formBuilder = new com.ee.MultipartFormBuilder(boundary);
      params = this.options.additionalData;
      fileParams = [
        {
          file: file,
          data: fileBinaryData,
          paramName: this.name
        }
      ];
      return formBuilder.buildMultipartFormBody(params, fileParams, boundary);
    };

    return FileUploader;

  })();

  /*
  Performs the upload of the image.
  */

  this.com.ee.InplaceImageUploader = (function() {

    function InplaceImageUploader(imageChanger) {
      this.options = imageChanger.options;
      this.$element = imageChanger.$element;
    }

    InplaceImageUploader.prototype.handleFileSelect = function(evt) {
      var files, reader;
      var _this = this;
      files = evt.target.files;
      this.file = evt.target.files[0];
      reader = new FileReader();
      reader.onloadend = function(evt) {
        return _this._onLocalFileLoadEnd(evt);
      };
      reader.readAsBinaryString(this.file);
      return null;
    };

    InplaceImageUploader.prototype._onLocalFileLoadEnd = function(evt) {
      var name, options, uploader, url;
      var _this = this;
      if (this.file.size > this.options.maxFileSizeInKB * 1024) {
        if (this.options.onLocalFileTooBig != null) {
          this.options.onLocalFileTooBig(this.file.size, this.options.maxFileSizeInKB);
        }
        return;
      }
      url = this.$element.attr('form-url');
      name = this.$element.attr('form-name');
      options = {
        onLoadStart: function() {
          return _this.options.onLoadStart(_this.$element);
        },
        onUploadComplete: function(responseText) {
          return _this.options.onUploadComplete(_this.$element, responseText);
        },
        additionalData: this.options.data
      };
      uploader = new com.ee.FileUploader(this.file, evt.target.result, url, name, options);
      return null;
    };

    InplaceImageUploader.prototype._progress = function(event) {
      var percentage;
      if (!event.lengthComputable) return;
      percentage = Math.round((event.loaded * 100) / event.total);
      if (this.currentProgress === percentage) return;
      this.currentProgress = percentage;
      this.options.onProgressUpdate(this.$element, this.file, this.currentProgress);
      return null;
    };

    return InplaceImageUploader;

  })();

  this.com.ee.InplaceImageChanger = (function() {

    /*
        Options: 
          maxFileSizeInKB - the max size of files
          onLocalFileTooBig - a call back if the file size is too big
          jsonResponseUrlKey - when reading the json response, it'll use this key to create the img#href
    */

    function InplaceImageChanger(imgElement, options) {
      var defaultOptions, empty;
      var _this = this;
      empty = function() {};
      defaultOptions = {
        maxFileSizeInKB: 2000,
        onProgressUpdate: empty,
        onLoadStart: empty,
        onLocalFileTooBig: empty,
        onUploadComplete: function($element, result) {
          return _this.onUploadComplete($element, result);
        }
      };
      if (options != null) {
        this.options = $.extend(defaultOptions, options);
      } else {
        this.options = defaultOptions;
      }
      this.$element = $("<span></span>");
      this.$element.insertAfter($(imgElement));
      this._copyAttributes($(imgElement), this.$element);
      if (typeof (this.$element.attr('form-url')) !== "undefined") {
        this.uploader = new com.ee.InplaceImageUploader(this);
      }
      $(imgElement).remove();
      this._createImageTag(this.$element.attr('href'));
      this._createFileInput();
    }

    InplaceImageChanger.prototype._copyAttributes = function($sourceNode, $destNode) {
      var attr, attributes, index;
      attributes = $sourceNode[0].attributes;
      for (index in attributes) {
        attr = attributes[index];
        if (!(attr.name != null) || !(attr.nodeValue != null)) continue;
        $destNode.attr(attr.name, attr.nodeValue);
      }
      return null;
    };

    InplaceImageChanger.prototype._createImageTag = function(url) {
      var imageTag;
      var _this = this;
      imageTag = "<img style='cursor:pointer' src='" + url + "'/>";
      this.$element.html(imageTag);
      this.$element.find('img').click(function(event) {
        return _this.$element.find('input').trigger('click');
      });
      return null;
    };

    InplaceImageChanger.prototype._createFileInput = function() {
      var fileInput;
      var _this = this;
      fileInput = "<input \n       style=\"visibility: hidden; width: 1px; height: 1px;\" \n       type=\"file\" \n       name=\"" + (this.$element.attr('form-name')) + "\">\n</input>";
      this.$element.append(fileInput);
      if (this.uploader != null) {
        this.$element.find('input').change(function(event) {
          return _this.uploader.handleFileSelect(event);
        });
      }
      return null;
    };

    /*
      Default upload complete handler
    */

    InplaceImageChanger.prototype.onUploadComplete = function($element, resultText) {
      var customKey, key, resultObject;
      resultObject = $.parseJSON(resultText);
      customKey = this.$element.attr('custom-response-key');
      key = customKey != null ? customKey : "url";
      this._createImageTag(resultObject[key]);
      this._createFileInput();
      return null;
    };

    return InplaceImageChanger;

  })();

  /*
  register with jQuery
  */

  jQuery.fn.inplaceImageChanger = function(options) {
    this.each(function(index) {
      if (!jQuery(this).data('com_ee_inplaceImageChanger')) {
        return jQuery(this).data('com_ee_inplaceImageChanger', new com.ee.InplaceImageChanger(this, options));
      }
    });
    return this;
  };

  window.com || (window.com = {});

  com.ee || (com.ee = {});

  this.com.ee.MultipartFormBuilder = (function() {

    function MultipartFormBuilder(boundary) {
      this.boundary = boundary;
      this.dashdash = "--";
      this.crlf = "\r\n";
    }

    /*
        fileParams = [
           
            {file : file (File)
            data : fileBinaryData
            paramName : name of request parameter}
          
            ...
            ]
    */

    MultipartFormBuilder.prototype.buildMultipartFormBody = function(params, fileParams) {
      var output;
      var _this = this;
      output = "";
      if (params != null) {
        $.each(params, function(i, val) {
          if ((typeof val) === 'function') val = val();
          return output += _this.buildFormSegment(i, val);
        });
      }
      if (fileParams != null) {
        $.each(fileParams, function(i, val) {
          output += _this.buildFileFormSegment(val.paramName, val.file, val.data);
          return null;
        });
      }
      output += this.dashdash;
      output += this.boundary;
      output += this.dashdash;
      output += this.crlf;
      return output;
    };

    MultipartFormBuilder.prototype.buildFormSegment = function(key, value) {
      var contentDisposition;
      contentDisposition = this._buildContentDisposition(key);
      return this._buildFormSegment(contentDisposition, value);
    };

    MultipartFormBuilder.prototype._buildContentDisposition = function(name) {
      var template;
      template = "Content-Disposition: form-data; name=\"${name}\" ";
      return template.replace("${name}", name);
    };

    MultipartFormBuilder.prototype._buildFileContentDisposition = function(formName, fileName) {
      var out;
      this.template = "Content-Disposition: form-data; name=\"${formName}\"; filename=\"${fileName}\" ";
      out = this.template.replace("${formName}", formName);
      out = out.replace("${fileName}", fileName);
      return out;
    };

    MultipartFormBuilder.prototype.buildFileFormSegment = function(formName, file, binaryData) {
      var contentDisposition;
      contentDisposition = this._buildFileContentDisposition(formName, file.name);
      contentDisposition += this.crlf;
      contentDisposition += "Content-Type: " + file.type;
      return this._buildFormSegment(contentDisposition, binaryData);
    };

    MultipartFormBuilder.prototype._buildFormSegment = function(contentDisposition, value) {
      var output;
      output = '';
      output += this.dashdash;
      output += this.boundary;
      output += this.crlf;
      output += contentDisposition;
      output += this.crlf;
      output += this.crlf;
      output += value;
      output += this.crlf;
      return output;
    };

    return MultipartFormBuilder;

  })();
