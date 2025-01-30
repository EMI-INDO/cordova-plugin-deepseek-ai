var exec = require('cordova/exec');

exports.sendRequest = function (options, success, error) {
    exec(success, error, 'CordovaDeepSeekPlugin', 'sendRequest', [options]);
};

exports.sendRequestAdvanced = function (options, success, error) {
    exec(success, error, 'CordovaDeepSeekPlugin', 'sendRequestAdvanced', [options]);
};
