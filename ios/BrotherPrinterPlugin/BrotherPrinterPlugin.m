//
//  BrotherPrinterPlugin.m
//  BrotherPrinterPlugin
//
//  Created by Ye Star on 4/9/16.
//
//

#define PRINTER_TESTER 0

#import "UserDefaults.h"
#import "BrotherPrinterPlugin.h"
#import <Cordova/CDVAvailability.h>

@interface BrotherPrinterPlugin ()

@property (retain) NSString* callbackId;

@property(nonatomic, strong) NSOperationQueue           *queueForWLAN;
@property(nonatomic, strong) NSOperationQueue           *queueForBT;

@property(nonatomic, strong) NSString *bytesWrittenMessage;
@property(nonatomic, strong) NSNumber *bytesWritten;
@property(nonatomic, strong) NSNumber *bytesToWrite;

@end

@implementation BrotherPrinterPlugin
{
    BRPtouchNetwork*			ptn;
    BRPtouchNetworkInfo*		pti;
    
    UIBackgroundTaskIdentifier bgTask;

    NSMutableArray *_brotherDeviceList;
    NSMutableArray *_cnbtBrotherDeviceList;
    
    UIActivityIndicatorView	*_indicator;
    UIView *_loadingView;
}

- (void) initWithUserDefault
{
    // "UserDefault" Initialize
    NSUserDefaults *userDefaults    = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *defaults   = [NSMutableDictionary dictionary];
    
    [defaults setObject:@""                                                 forKey:kExportPrintFileNameKey];
    [defaults setObject:@"1"                                                forKey:kPrintNumberOfPaperKey];
    [defaults setObject:[self defaultPaperSize]                             forKey:kPrintPaperSizeKey];
    [defaults setObject:[NSString stringWithFormat:@"%d", Landscape]        forKey:kPrintOrientationKey];
    [defaults setObject:[NSString stringWithFormat:@"%d", DensityLevel6]    forKey:kPrintDensityKey];
    [defaults setObject:[NSString stringWithFormat:@"%d", Original]         forKey:kPrintFitKey];
    [defaults setObject:[NSString stringWithFormat:@"%d", Binary]           forKey:kPrintHalftoneKey];
    [defaults setObject:[NSString stringWithFormat:@"%d", Left]             forKey:kPrintHorizintalAlignKey];
    [defaults setObject:[NSString stringWithFormat:@"%d", Top]              forKey:kPrintVerticalAlignKey];
    //[defaults setObject:[NSString stringWithFormat:@"%d", PaperLeft]        forKey:kPrintPaperAlignKey];
    
    // nExtFlag
    [defaults setObject:[NSString stringWithFormat:@"%d", CodeOff]          forKey:kPrintCodeKey];
    [defaults setObject:[NSString stringWithFormat:@"%d", CarbonOff]        forKey:kPrintCarbonKey];
    [defaults setObject:[NSString stringWithFormat:@"%d", DashOff]          forKey:kPrintDashKey];
    [defaults setObject:[NSString stringWithFormat:@"%d", NoFeed]           forKey:kPrintFeedModeKey];
    
    [defaults setObject:[NSString stringWithFormat:@"%d", CurlModeOff]      forKey:kPrintCurlModeKey];
    [defaults setObject:[NSString stringWithFormat:@"%d", Fast]             forKey:kPrintSpeedKey];
    [defaults setObject:[NSString stringWithFormat:@"%d", BidirectionOn]    forKey:kPrintBidirectionKey];
    [defaults setObject:@"0"                                                forKey:kPrintFeedMarginKey];
    [defaults setObject:@"200"                                              forKey:kPrintCustomLengthKey];
    [defaults setObject:@"80"                                               forKey:kPrintCustomWidthKey];
    
    
    [defaults setObject:@"No Selected"                                      forKey:kSelectedDevice];
    [defaults setObject:@"0"                                                forKey:kIPAddress];
    [defaults setObject:@"0"                                                forKey:kSerialNumber];
    [defaults setObject:@"Search device from Wi-Fi"                         forKey:kSelectedDeviceFromWiFi];
    [defaults setObject:@"Search device from Bluetooth"                     forKey:kSelectedDeviceFromBluetooth];
    
    [defaults setObject:@"0"                                                forKey:kIsWiFi];
    [defaults setObject:@"0"                                                forKey:kIsBluetooth];
    
    [defaults setObject:@"0"                                                forKey:kSelectedPDFFilePath];
    
    [userDefaults registerDefaults:defaults];
}

- (NSString *)defaultPaperSize
{
    NSString *result = nil;
    
#warning Temp "Brother Brother QL-710W"
    NSString *pathInPrintSettings   = [[NSBundle mainBundle] pathForResource:@"PrinterList" ofType:@"plist"];
    if (pathInPrintSettings) {
        NSDictionary *priterListArray = [NSDictionary dictionaryWithContentsOfFile:pathInPrintSettings];
        if (priterListArray) {
            result = [[[priterListArray objectForKey:@"Brother QL-710W"] objectForKey:@"PaperSize"] objectAtIndex:0];
        }
    }
    return result;
}

/*
 *  pluginInitialize
 */
- (void)pluginInitialize
{
    NSLog(@"pluginInitialize");
    
    [self initWithUserDefault];
    
    _brotherDeviceList = [[NSMutableArray alloc] initWithCapacity:0];
    _cnbtBrotherDeviceList = [[NSMutableArray alloc] initWithCapacity:0];
    
    ptn = [[BRPtouchNetwork alloc] init];
    
    //	Set delegate
    ptn.delegate = self;
    
    NSString *	path = [[NSBundle mainBundle] pathForResource:@"PrinterList" ofType:@"plist"];
    if( path )
    {
        NSDictionary *printerDict = [NSDictionary dictionaryWithContentsOfFile:path];
        NSArray *printerList = [[NSArray alloc] initWithArray:printerDict.allKeys];
        [ptn setPrinterNames:printerList];
    }
}

- (void)onAppTerminate
{
}

/*
 *  Return printer list
 *
 * @param {Function} callback
 *      A callback function to be called with the result
 */
- (void)getPrinters:(CDVInvokedUrlCommand*)command
{
    _callbackId = command.callbackId;
    
    //	Start printer search
    if( PRINTER_TESTER == 1 )
    {   //here we run application through xcode (either simulator or device). You usually place some test code here (e.g. hardcoded login-passwords)
        NSLog(@"PRINTER_TESTER");
        [_cnbtBrotherDeviceList removeAllObjects];
        
        NSDictionary *tmpDic = @{
                                     kSelectedDevice : @"Brother QL-710W",
                                     kIPAddress : @"10.1.1.1",
                                     kSerialNumber:@"0",
                                     kIsWiFi:@"1",
                                     kIsBluetooth:@"0",
                                     kSelectedDeviceFromWiFi:@"Brother QL-710W",
                                     kSelectedDeviceFromBluetooth:@"Only Wifi, But not Bluetooth"};
            
        [_cnbtBrotherDeviceList addObject:tmpDic];
        NSLog(@"%@", _cnbtBrotherDeviceList);
        
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:_cnbtBrotherDeviceList];
        
        [self.commandDelegate sendPluginResult:pluginResult callbackId:_callbackId];
    }
    else
    {   //this is a real application downloaded from appStore
        NSLog(@"RELEASE");
        [ptn startSearch: 5.0];
        
        //	Create indicator View
        _loadingView = [[UIView alloc] initWithFrame:[self.webView bounds]];
        [_loadingView setBackgroundColor:[UIColor blackColor]];
        [_loadingView setAlpha:0.5];
        [self.webView addSubview:_loadingView];
        _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _indicator.frame = CGRectMake(_loadingView.frame.size.width/2-20, _loadingView.frame.size.height/2-20, 40.0, 40.0);
        [self.webView addSubview:_indicator];
        
        //	Start indicator animation
        [_indicator startAnimating];
    }
}

/*
 *	BRPtouchNetwork delegate method
 */
-(void)didFinishedSearch:(id)sender
{
    NSLog(@"didFinishedSearch");
    
    [_indicator stopAnimating];          //  stop indicator animation
    [_indicator removeFromSuperview];    //  remove indicator view (indicator)
    [_loadingView removeFromSuperview];  //  remove indicator view (view)
    
    //  get BRPtouchNetworkInfo Class list
    [_brotherDeviceList removeAllObjects];
    _brotherDeviceList = (NSMutableArray*)[ptn getPrinterNetInfo];
    
    NSLog(@"_brotherDeviceList [%@]",_brotherDeviceList);
    
    [_cnbtBrotherDeviceList removeAllObjects];
    
    for(int i=0; i<[_brotherDeviceList count]; i++)
    {
        BRPtouchNetworkInfo *_selectedAccessory = _brotherDeviceList[i];
        NSDictionary *tmpDic = @{
                                 kSelectedDevice : _selectedAccessory.strModelName,
                                 kIPAddress : _selectedAccessory.strIPAddress,
                                 kSerialNumber:@"0",
                                 kIsWiFi:@"1",
                                 kIsBluetooth:@"0",
                                 kSelectedDeviceFromWiFi:_selectedAccessory.strModelName,
                                 kSelectedDeviceFromBluetooth:@"Only Wifi, But not Bluetooth"};
        
        [_cnbtBrotherDeviceList addObject:tmpDic];
    }
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:_cnbtBrotherDeviceList];
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:_callbackId];
    return;
}

/*
 * Print
 *
 * @param {Function} callback
 *      A callback function to be called with the result
 */
- (void)print:(CDVInvokedUrlCommand*)command
{
    _callbackId = command.callbackId;
    
    /*NSDictionary *message = @{
                              @"Return_Type":@"Finished",
                              @"Wifi":@"1",
                              @"Bluetooth":@"0",
                              @"Status":@"OK"
                              };
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:message];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:_callbackId];
    
   
    
    sleep(1000);
    [self.commandDelegate sendPluginResult:pluginResult callbackId:_callbackId];
    return;*/
    
    NSArray *arguments = [command arguments];
    
    NSString *deviceType = [arguments objectAtIndex:0];//[1, params, path], 1:WIFI, 0:Bluetooth
    NSDictionary *settings = [arguments objectAtIndex:1];//[1, params, path]
    NSString *pdfPath = [arguments objectAtIndex:2];
    
    NSLog(@"%@, %@, %@", deviceType, settings, pdfPath);
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    [userDefaults setObject:pdfPath forKey:kSelectedPDFFilePath];

    [userDefaults setObject:[settings objectForKey:kSelectedDevice] forKey:kSelectedDevice];
    [userDefaults setObject:[settings objectForKey:kIPAddress] forKey:kIPAddress];
    [userDefaults setObject:@"0"                            forKey:kSerialNumber];
    
    if([deviceType isEqualToString:@"1"]) //wifi
    {
        [userDefaults setObject:@"1" forKey:kIsWiFi];
        [userDefaults setObject:@"0" forKey:kIsBluetooth];
        [userDefaults setObject:[settings objectForKey:kSelectedDeviceFromWiFi] forKey:kSelectedDeviceFromWiFi];
        [userDefaults setObject:@"Search device from Bluetooth" forKey:kSelectedDeviceFromBluetooth];
    }
    else
    {
        [userDefaults setObject:@"0" forKey:kIsWiFi];
        [userDefaults setObject:@"1" forKey:kIsBluetooth];
        [userDefaults setObject:@"Search device from Wifi" forKey:kSelectedDeviceFromWiFi];
        [userDefaults setObject:[settings objectForKey:kSelectedDeviceFromBluetooth] forKey:kSelectedDeviceFromBluetooth];
    }
    
    [userDefaults synchronize];
    
    [self printStart:pdfPath];
}

/*
 * printStart
 */
-(void)printStart:(NSString*)pdfPath
{
    self.bytesWritten = [NSNumber numberWithInt:0];
    self.bytesToWrite = [NSNumber numberWithInt:0];

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *selectedDevice = nil;
    
    if ([userDefaults integerForKey:kIsWiFi] == 0 && [userDefaults integerForKey:kIsBluetooth] == 1)
    {
        selectedDevice = [NSString stringWithFormat:@"Brother %@",[userDefaults stringForKey:kSelectedDeviceFromBluetooth]];
    }
    else if ([userDefaults integerForKey:kIsWiFi] == 1 && [userDefaults integerForKey:kIsBluetooth] == 0)
    {
        selectedDevice = [NSString stringWithFormat:@"%@", [userDefaults stringForKey:kSelectedDeviceFromWiFi]];
    }
    else
    {
    }
    
    NSString *ipAddress     = [userDefaults stringForKey:kIPAddress];
    NSString *serialNumber  = [userDefaults stringForKey:kSerialNumber];
    
    // PrintInfo
    BRPtouchPrintInfo *printInfo = [[BRPtouchPrintInfo alloc] init];
    
    if ([[userDefaults stringForKey:kExportPrintFileNameKey] isEqualToString:@""]) {
    }
    else {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *directory = [paths objectAtIndex:0];
        NSString *fileName = [[userDefaults stringForKey:kExportPrintFileNameKey] stringByAppendingPathExtension:@"prn"];
        NSString *filePath = [directory stringByAppendingPathComponent:fileName];
    }
    
    NSString *numPaper = [userDefaults stringForKey:kPrintNumberOfPaperKey]; // Item 0
    
    printInfo.strPaperName		= [userDefaults stringForKey:kPrintPaperSizeKey]; // Item 1
    printInfo.nOrientation		= (int)[userDefaults integerForKey:kPrintOrientationKey]; // Item 2
    printInfo.nDensity			= (int)[userDefaults integerForKey:kPrintDensityKey]; // Item 3
    printInfo.nPrintMode		= (int)[userDefaults integerForKey:kPrintFitKey]; // Item 4
    printInfo.nHalftone			= (int)[userDefaults integerForKey:kPrintHalftoneKey]; // Item 5
    printInfo.nHorizontalAlign	= (int)[userDefaults integerForKey:kPrintHorizintalAlignKey]; // Item 6
    printInfo.nVerticalAlign	= (int)[userDefaults integerForKey:kPrintVerticalAlignKey]; // Item 7
    printInfo.nPaperAlign		= (int)[userDefaults integerForKey:kPrintPaperAlignKey]; // Item 8
    
    printInfo.nExtFlag |= (int)[userDefaults integerForKey:kPrintCodeKey]; // Item 9
    printInfo.nExtFlag |= (int)[userDefaults integerForKey:kPrintCarbonKey]; // Item 10
    printInfo.nExtFlag |= (int)[userDefaults integerForKey:kPrintDashKey]; // Item 11
    printInfo.nExtFlag |= (int)[userDefaults integerForKey:kPrintFeedModeKey]; // Item 12
    
    NSLog(@"kSelectedDevice             = %@"   , selectedDevice);
    NSLog(@"kIPAddress                  = %@"   , ipAddress);
    NSLog(@"kSerialNumber               = %d"   , printInfo.nPrintMode);
    NSLog(@"");
    NSLog(@"kPrintNumberOfPaperKey      = %@"   , numPaper);
    NSLog(@"kPrintPaperSizeKey          = %@"   , printInfo.strPaperName);
    NSLog(@"kPrintOrientationKey        = %d"   , printInfo.nOrientation);
    NSLog(@"kPrintDensityKey            = %d"   , printInfo.nDensity);
    NSLog(@"kPrintFitKey                = %d"   , printInfo.nPrintMode);
    NSLog(@"kPrintHalftoneKey           = %d"   , printInfo.nHalftone);
    NSLog(@"kPrintHorizintalAlignKey    = %d"   , printInfo.nHorizontalAlign);
    NSLog(@"kPrintVerticalAlignKey      = %d"   , printInfo.nVerticalAlign);
    NSLog(@"kPrintPaperAlignKey         = %d"   , printInfo.nPaperAlign);
    NSLog(@"");
    NSLog(@"kPrintVerticalAlignKey      = %d"   , printInfo.nExtFlag);
    NSLog(@"");
    
    BRPtouchPrinter* _ptp = [[BRPtouchPrinter alloc] initWithPrinterName:selectedDevice];
    [_ptp setIPAddress:ipAddress];
    [_ptp setPrintInfo:printInfo];
    
    /* Print all pages inside of pdf file */
    NSUInteger length = 0;
    NSUInteger pageIndexes[] = {0};
        
    /* to print part of a pdf file, use the following code instead
        // This is an example for print page.1 and page.2 .(All pages are numbered starting at 1.)
        NSUInteger pageIndexes[] = {1,2};
        NSUInteger length = sizeof(pageIndexes)/sizeof(pageIndexes[0]);
    */
    int copies = 0;
    NSLog(@"Will start to print pdf file...");
    if (copies ==0) { copies = 1; }
            
    if ([_ptp isPrinterReady]) {
        NSLog(@"Printer is ready !");
        [_ptp printPDFAtPath:pdfPath pages:pageIndexes length:length copy:copies timeout:500];
                
        NSDictionary *message = @{
                                        @"Return_Type":@"Finished",
                                        @"Wifi":@"1",
                                        @"Bluetooth":@"0",
                                        @"Status":@"OK"
                                        };
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:message];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:_callbackId];
                
    }
    else{
        NSDictionary *message = @{
                                    @"Return_Type":@"Finished",
                                    @"Wifi":@"1",
                                    @"Bluetooth":@"0",
                                    @"Status":@"Error"
                                    };
                
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:message];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:_callbackId];
    }
}

/*
 * Print
 *
 * @param {Function} callback
 *      A callback function to be called with the result
 */
- (void)cancelPrint:(CDVInvokedUrlCommand *)command
{
    NSLog(@"*** Cancel Print ***");
    //[_ptp cancelPrinting];
}
@end
