/**
 * @author Christian Wygoda
 */
(function($, undefined){
  $.widget("ks.spinner", {
    options: {
      title: "Spinner",
      message: undefined,
      markup: '<div id="spinner"><img src="../pc/media/spinner.gif"/></div>{{html message}}',
      modal: true,
      error: undefined,
      success: undefined,
      timer: 0,
      error_message: "Ein Fehler ist aufgetreten."
    },

    _dialog: undefined,
    _close_button: undefined,
    _timeout: false,

    _create: function() {       
      this._dialog = $('<div/>')
      .hide()
      .addClass("ks-spinner")
      .append(
        $.tmpl(this.options.markup, {
        message: this.options.message}))
        .appendTo(this.element)
        .dialog({
          autoOpen: false,
          title: this.options.title,
          modal: this.options.modal,
          closeOnEscape: false,
          width: 500,
          height: 200,
          buttons: {
            "schließen": function() { $(this).dialog("close"); }
          }
        });
        $(".ui-dialog-titlebar-close", this._dialog.parent()).hide();
        this._close_button = $(".ui-button", this._dialog.parent())
        .button("disable");
    },

    destroy: function() {       
      this._dialog.dialog("destroy");
      this._dialog.remove();
      this.element.removeData("spinner");
    },

    show: function() {
      var self = this;
      this._dialog.dialog("open");        
      setTimeout(function() {
        self._timeout = true;
      }, this.options.timer * 1000);
    },

    error: function(message) {
      var self = this;
      var errorAction = function() {
        self._exitHandler(self.options.error, message, self.options.error_message);
      };

      if(this._timeout) {
        errorAction();
      } else {
        var timerId;
        timerId = setInterval(function() {
          if(self._timeout) {
            clearInterval(timerId);
            errorAction();
          }
        }, 250);
      }
    },

    success: function(message) {
      var self = this;
      var successAction = function() {
        if(message) {
          self._exitHandler(self.options.success, message);
        } else {
          self.options.success(); 
        }
      };

      if(this._timeout) {
        successAction();
      } else {
        var timerId;
        timerId = setInterval(function() {
          if(self._timeout) {
            clearInterval(timerId);
            successAction();
          }
        }, 250);
      }
    },

    _exitHandler: function(callback, message, default_message) {
      var self = this;        
      this._dialog.empty()
      .append(
        $.tmpl(this.options.markup, {message: message ? message : default_message}));

        var s = self._dialog.find('#spinner');
        s.hide();

        setTimeout(function(){
          self._close_button.button("enable");
          self._dialog.dialog("option", "closeOnEscape", true);
          if(typeof(callback) == "function") {
            self._dialog.bind("dialogclose", callback);
          }
        }, this.options.timer * 1000);      
    }
  });
}(jQuery));

