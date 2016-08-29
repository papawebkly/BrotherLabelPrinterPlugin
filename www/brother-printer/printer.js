/**
 * @constructor
 */


var BrotherPrinterPlugin = function () {
    this.GET_PRINTERS_METHOD = 'getPrinters';
    this.PRINT_METHOD = 'print';
    this.CANCEL_PRINT_METHOD = 'cancelPrint';
    this.CLASS = 'BrotherPrinterPlugin';
};

BrotherPrinterPlugin.prototype.getPrinters = function(callback, errorc) {
    // make the call
    var successCallback = (callback && typeof(callback) === 'function') ? callback : this.defaultCallback;
    var errorCallback = (errorc && typeof(errorc) === 'function') ? errorc : this.defaultCallback;

    cordova.exec(successCallback, errorCallback, this.CLASS, this.GET_PRINTERS_METHOD, []);
};

/*
 NSInteger deviceType = (NSInteger)[arguments objectAtIndex:0];//[1, params, path], 1:WIFI, 0:Bluetooth
 NSDictionary *settings = [arguments objectAtIndex:1];//[1, params, path]
 NSString *pdfPath = [arguments objectAtIndex:2];
 */
BrotherPrinterPlugin.prototype.print = function(options) {

    // make the call
    var device = options.device;//1:WIFI, 0:Bluetooth
    var settings = options.settings;
    var pdfPath = options.pdfPath;
    
    var args = [device];
    args.push(settings);
    args.push(pdfPath);

    var successCallback = (options.success && typeof(options.success) === 'function') ? options.success : this.defaultCallback;
    
    var errorCallback = (options.error && typeof(options.error) === 'function') ? options.error : this.defaultCallback;
    
    cordova.exec(successCallback, errorCallback, this.CLASS, this.PRINT_METHOD, args);
};

BrotherPrinterPlugin.prototype.cancelPrint = function () {
        cordova.exec(null, null, this.CLASS, this.CANCEL_PRINT_METHOD, []);
};

BrotherPrinterPlugin.prototype.defaultCallback = null;

// Plug in to Cordova
cordova.addConstructor(function () {
        if (!window.Cordova) {
            window.Cordova = cordova;
        };
                       
        if (!window.plugins) window.plugins = {};
            window.plugins.BrotherPrinterPlugin = new BrotherPrinterPlugin();
});