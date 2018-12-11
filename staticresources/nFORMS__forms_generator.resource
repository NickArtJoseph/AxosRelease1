var Forms = Forms || {};
(function() {
  var Generator = function() {
    var HOST_NAME = window.location.hostname;
    var DOCUMENT_XML_FILE = 'word/document.xml';
    var DOWNLOAD_URL = '/servlet/servlet.FileDownload?file=';
    var UPLOAD_ERROR = 'An error occurred uploading the document.';
    var CONTENT_PDF_DOWNLOAD_PART_ONE =
      'https://' + HOST_NAME + '/sfc/servlet.shepherd/version/download/';
    var CONTENT_PDF_DOWNLOAD_PART_TWO = '?asPdf=true&';
    var CONTENT_PREVIEW =
      '/sfc/servlet.shepherd/version/renditionDownload?rendition=THUMB720BY480&versionId=';
    var CONTENT_PREVIEW_DECACHE_SUFFIX='&decacheInterval='
    var WORD_DOC_DOWNLOAD = 'https://' + HOST_NAME + '/sfc/servlet.shepherd/version/download/';
    var OUTPUT_TYPE_PDF = 'PDF';
    var HIDDEN_MODAL_CLASS = 'hiddenModal';
    var self = this;
    self.contentVersionId = '';

    var config = {
      objectId: '',
      objectType: '',
      saveAttachment: true,
      remoteActions: { }
    };

    self.endPreviewRender = function(previewIsRendered){
      self.modalViewAction(config.loadingModalPDF, true);
      self.modalViewAction(config.loadingModalWord, true);
      clearInterval(Forms.Generator.imagePreviewLoadingInterval);

      if(previewIsRendered){
        location.href =
          CONTENT_PDF_DOWNLOAD_PART_ONE +
          self.contentVersionId +
          CONTENT_PDF_DOWNLOAD_PART_TWO;
      } else {
        self.modalViewAction(config.errorModal, false);
      }

      setTimeout(function(){
        document.getElementById(config.imageId).src = '';
      }, 1000);
    };
    self.modalViewAction = function(modalId, isHidden){
      document.getElementById(modalId).className = isHidden ? HIDDEN_MODAL_CLASS : '';
    };
    self.setModalHeader = function(headerText){
      document.getElementById(config.loadingModalPDF).querySelector('.formsHeader').innerHTML = headerText;
      document.getElementById(config.loadingModalWord).querySelector('.formsHeader').innerHTML = headerText;
    };

    function generateForm(templateId, docId, isPDF, saveToDocman) {
      remoteGenerateForm(docId, templateId, saveToDocman, function(formId) {
        if (formId) {
          if(isPDF){
            self.contentVersionId = formId;
            var previewLink = CONTENT_PREVIEW + formId;
            var previewElement = document.getElementById(config.imageId);
            renderContentPreview(previewElement, previewLink, 60);
          } else {
            self.modalViewAction(config.loadingModalWord, true);
            location.href = WORD_DOC_DOWNLOAD + formId;
          }
        }
      },
      showMessage);
    }
    function renderContentPreview(previewElement, previewLink, durationInSeconds){
      var x = 0;
      self.imagePreviewLoadingInterval = setInterval(function(){
        if(x < durationInSeconds){
          previewElement.src = previewLink+CONTENT_PREVIEW_DECACHE_SUFFIX+x;
        } else {
          self.endPreviewRender(false);
        }
        x++;
      },1000);
    }
    function getDocumentXml(archive) {
      if (archive != undefined) {
        var docFile = archive.files[DOCUMENT_XML_FILE];
        if (docFile != undefined) {
          return docFile.asBinary();
        }
      }
      return null;
    }
    function processTemplate(templateId, docId, zip, isPDF, saveToDocman, enforceMasking) {
      remoteProcessTemplate(docId, enforceMasking, function(formXml) {
        setDocumentXml(zip, formXml);
        if(config.saveAttachment) {
          var bodyEnc = zip.generate({type:'base64'});
          upload(bodyEnc, function(docId) {
            if (docId) {
              generateForm(templateId, docId, isPDF, saveToDocman);
            } else {
              showMessage(UPLOAD_ERROR);
            }
          });
        } else {
          var bodyEnc = zip.generate({type:'blob'});
          saveAs(bodyEnc, config.fileName);
          if(isPDF){
            self.modalViewAction(config.loadingModalPDF, true);
          } else {
            self.modalViewAction(config.loadingModalWord, true);
          }
        }
      },
      showMessage);
    }
    function remoteGenerateForm(docId, templateId, saveToDocman, success, failure) {
      Visualforce.remoting.Manager.invokeAction(
        config.remoteActions.generateForm,
        docId,
        templateId,
        config.objectId,
        saveToDocman,
        function(formId, event) {
          if (event.status) {
            success(formId);
          } else {
            failure(event.message);
          }
        }
      );
    }
    function remoteProcessTemplate(docId, enforceMasking, success, failure) {
      Visualforce.remoting.Manager.invokeAction(
        config.remoteActions.processTemplate,
        docId,
        config.objectId,
        config.objectType,
        enforceMasking,
        function(formEnc, event) {
          if (event.status) {
            var formXml = JSZip.base64.decode(formEnc);
            success(formXml);
          } else {
            failure(event.message);
          }
        }
      );
    }
    function remoteRetrieveTemplate(templateId, success, failure) {
      Visualforce.remoting.Manager.invokeAction(
        config.remoteActions.retrieveTemplate,
        templateId,
        function(blob, event) {
          if (event.status) {
            var zip = new JSZip(blob, {base64:true});
            zip.remove('undefined');
            success(zip);
          } else {
            failure(event.message);
          }
        }
      );
    }
    function setDocumentXml(archive, docXml) {
      archive.file(DOCUMENT_XML_FILE,docXml,{binary:true});
    }
    function showMessage(message) {
      self.modalViewAction(config.loadingModalPDF, true);
      self.modalViewAction(config.loadingModalWord, true);
      alert(message);
    }
    function upload(content, callback) {
      self.callback = function(id) {
        callback(id);
      };
      af_upload(content);
    }
    self.configure = function(options) {
      jQuery.extend(true, config, options);
    };
    self.invoke = function(templateId, outputType, saveToDocman,enforceMasking) {
      var isPDF = outputType == OUTPUT_TYPE_PDF;
      var header = saveToDocman == 'true' ? config.generatingDocmanLabel : config.generatingDocumentLabel;
      self.setModalHeader(header);
      if(isPDF){
        self.modalViewAction(config.loadingModalPDF, false);
      } else {
        self.modalViewAction(config.loadingModalWord, false);
      }

      remoteRetrieveTemplate(templateId, function(zip) {
        var templateXml = getDocumentXml(zip);
        var templateEnc = JSZip.base64.encode(templateXml);
        upload(templateEnc, function(docId) {
          if (docId) {
            processTemplate(templateId, docId, zip, isPDF, saveToDocman, enforceMasking);
          } else {
            showMessage(UPLOAD_ERROR);
          }
        });
      },
      showMessage);
    };
    return self;
  };
  Forms.Generator = Forms.Generator || new Generator();
})();
