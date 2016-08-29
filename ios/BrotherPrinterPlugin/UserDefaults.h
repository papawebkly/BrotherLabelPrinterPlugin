//
//  UserDefaults.h
//  SDK_Sample_Ver2
//
//  Created by Kusumoto Naoki on 2015/04/20.
//  Copyright (c) 2015年 Kusumoto Naoki. All rights reserved.
//

#ifndef ___USER_DEFAULTS___
#define ___USER_DEFAULTS___

#pragma mark - Default Setting

#define kSelectedDevice		@"SelectedDevice"
#define kIPAddress          @"IPAddress"
#define kSerialNumber		@"SerialNumber"

#define kSelectedDeviceFromWiFi         @"SelectedDeviceFromWiFi"
#define kSelectedDeviceFromBluetooth    @"SelectedDeviceFromBluetooth"

#define kIsWiFi                         @"isWiFi"
#define kIsBluetooth                    @"isBluetooth"

#define kPrintResultForWLAN     @"printResultForWLAN"
#define kPrintResultForBT       @"printResultForBT"

#define kPrintStatusBatteryPowerForWLAN     @"printStatusBatteryPowerForWLAN"
#define kPrintStatusBatteryPowerForBT       @"printStatusBatteryPowerForBT"

#define kSelectedSendDataPath       @"selectedSendDataPath"
#define kSelectedSendDataName       @"selectedSendDataName"

#define kSelectedPDFFilePath       @"selectedPDFFilePath"

#pragma mark - Print Settings

// Item 0
#define kExportPrintFileNameKey @"ExportPrintFileNameKey"

#define kPrintNumberOfPaperKey		@"PrintNumberOfPaperKey"

// Item 1
#define kPrintPaperSizeKey		@"PrintPaperSizeKey"
enum PrintPaperSize
{
    A4 = 1,
    Letter,
    Legal
};

// Item 2
#define kPrintOrientationKey		@"PrintOrientationKey"
enum PrintOrientationKey
{
    Landscape   = 0x00,
    Portrate    = 0x01
};

// Item 3
#define kPrintDensityKey		@"PrintDensityKey"
enum PrintDensity
{
    DensityLevel0   = 0x00,
    DensityLevel1   = 0x01,
    DensityLevel2   = 0x02,
    DensityLevel3   = 0x03,
    DensityLevel4   = 0x04,
    DensityLevel5   = 0x05,
    DensityLevel6   = 0x06,
    DensityLevel7   = 0x07,
    DensityLevel8   = 0x08,
    DensityLevel9   = 0x09,
    DensityLevel10  = 0x0A
};

// Item 4
#define kPrintFitKey		@"PrintFitKey"
enum PrintFitKey
{
    Original    = 0x00,
    Fit         = 0x01
};

// Item 5
#define kPrintHalftoneKey		@"PrintHalftoneKey"
enum PrintHalftoneKey
{
    Binary          = 0x00,
    Dither          = 0x01,
    ErrorDiffusion  = 0x02
};

// Item 6
#define kPrintHorizintalAlignKey		@"PrintHorizintalAlignKey"
enum PrintHorizintalAlignKey
{
    Left    = 0x00,
    Center  = 0x01,
    Right   = 0x02
};

// Item 7
#define kPrintVerticalAlignKey		@"PrintVerticalAlignKey"
enum PrintVerticalAlignKey
{
    Top     = 0x00,
    Middle  = 0x01,
    Bottom  = 0x02
};

// Item 8
#define kPrintPaperAlignKey     @"PrintPaperAlignKey"
enum PrintPaperAlignKey
{
    PaperLeft   = 0x00,
    PaperCenter = 0x01,
    PaperRight  = 0x02
};

// Item 9
#define kPrintCodeKey		@"PrintCodeKey"
enum PrintCodeKey
{
    CodeOn  = 0x01,
    CodeOff = 0x00
};

// Item 10
#define kPrintCarbonKey		@"PrintCarbonKey"
enum PrintCarbonKey
{
    CarbonOn  = 0x02,
    CarbonOff = 0x00
};

// Item 11
#define kPrintDashKey		@"PrintDashKey"
enum PrintDashKey
{
    DashOn  = 0x04,
    DashOff = 0x00
};

// Item 12
#define kPrintFeedModeKey		@"PrintFeedModeKey"
enum PrintFeedModeKey
{
    NoFeed              = 0x08,
    EndOfPage           = 0x10,
    EndOfPageRetract    = 0x20,
    FixPage             = 0x40
};

// Item 13
#define kPrintCurlModeKey		@"PrintCurlModeKey"
enum PrintCurlModeKey
{
    CurlModeOff = 0x01,
    CurlModeOn  = 0x02,
    AntiCurl    = 0x03,
};

// Item 14
#define kPrintSpeedKey		@"PrintSpeedKey"
enum PrintSpeed
{
    Faster      = 0x00,
    Fast        = 0x01,
    Slowly      = 0x02,
    MoreSlowly  = 0x03
};

// Item 15
#define kPrintBidirectionKey		@"PrintBidirectionKey"
enum PrintBidirectionKey
{
    BidirectionOn  = 0x01,
    BidirectionOff = 0x00
};

// Item 16
#define kPrintFeedMarginKey		@"PrintFeedMarginKey"

// Item 17
#define kPrintCustomLengthKey		@"PrintCustomLengthKey"

// Item 18
#define kPrintCustomWidthKey		@"PrintCustomWidthKey"

#endif
