module.exports = {
  hello: function(title, message, buttonLabel, successCallback, failureCallback) {
    // [Usage] cordova.exec(successCallback, failureCallback, service, action, [args]);
    cordova.exec(successCallback,
                 null, // No failure callback
                 "MultipleImagesPicker",
                 "hello",
                 [title, message, buttonLabel]);
  },
  getPictures: function(successCallback, failureCallback, options) {
    // [Usage] cordova.exec(successCallback, failureCallback, service, action, [args]);
    if (!options) {
      options = {};
    }

    var params = {
      maximumNumberOfSelectionPhoto: options.maximumNumberOfSelectionPhoto ? options.maximumNumberOfSelectionPhoto : 5,
      maximumNumberOfSelectionVideo: options.maximumNumberOfSelectionVideo ? options.maximumNumberOfSelectionVideo : 0,
      maximumNumberOfSelectionMedia: options.maximumNumberOfSelectionMedia ? options.maximumNumberOfSelectionMedia : 0
    }

    cordova.exec(successCallback,
                 failureCallback,
                 "MultipleImagesPicker",
                 "getPictures",
                 [params]);
  }
};