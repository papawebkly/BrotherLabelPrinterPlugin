//
//  BrotherPrinterPlugin.h
//  BrotherPrinterPlugin
//
//  Created by Ye Star on 4/9/16.
//
//

#import <Cordova/CDVPlugin.h>
#import <BRPtouchPrinterKit/BRPtouchPrinterKit.h>

@protocol BRPrintResultViewControllerDelegate <NSObject>
- (void) showPrintResultForWLAN;
- (void) showPrintResultForBluetooth;
@end

@interface BrotherPrinterPlugin : CDVPlugin<BRPtouchNetworkDelegate>
    - (void)getPrinters:(CDVInvokedUrlCommand*)command;
    - (void)print:(CDVInvokedUrlCommand*)command;
    - (void)cancelPrint:(CDVInvokedUrlCommand*)command;

@end
