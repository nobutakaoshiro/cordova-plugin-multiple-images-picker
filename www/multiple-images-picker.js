module.exports = {
  hello: function(title, message, buttonLabel, successCallback, failureCallback) {
    // [Usage] cordova.exec(successCallback, failureCallback, service, action, [args]);
    cordova.exec(successCallback,
                 null, // No failure callback
                 "MultipleImagesPicker",
                 "hello",
                 [title, message, buttonLabel]);
  }
};