//
//  MicroBlink.h
//  MicroBlinkFramework
//
//  Created by Jurica Cerovec on 3/29/12.
//  Copyright (c) 2015 MicroBlink Ltd. All rights reserved.
//

#ifndef PhotoPayFramework_MicroBlink_h
#define PhotoPayFramework_MicroBlink_h

// Include Common API
#import "MBMicroblinkApp.h"
#import "MBViewControllerFactory.h"
#import "MBMicroblinkSDK.h"
#import "MBException.h"

// Settings
#import "MBCameraSettings.h"

// Delegates
#import "MBRecognizerRunnerViewControllerMetadataDelegates.h"
#import "MBRecognizerRunnerViewControllerDelegate.h"
#import "MBScanningRecognizerRunnerViewControllerDelegate.h"

// Overlay delegates
#import "MBBarcodeOverlayViewControllerDelegate.h"

#import "MBRecognizerRunner.h"
#import "MBRecognizerRunnerMetadataDelegates.h"
#import "MBScanningRecognizerRunnerDelegate.h"

// Frame Grabbers
#import "MBFrameGrabberRecognizer.h"
#import "MBSuccessFrameGrabberRecognizer.h"
#import "MBSuccessFrameGrabberRecognizerResult.h"

/*  UI  */
// Overlays
#import "MBBarcodeOverlayViewController.h"
#import "MBBarcodeOverlaySettings.h"

#import "MBFieldByFieldOverlayViewController.h"

#import "MBCustomOverlayViewController.h"

#import "MBBaseOcrOverlaySettings.h"
#import "MBDocumentOverlaySettings.h"

// Overlay subviews
#import "MBDotsSubview.h"
#import "MBDotsResultSubview.h"
#import "MBModernViewfinderSubview.h"
#import "MBTapToFocusSubview.h"
#import "MBOcrResultSubview.h"
#import "MBResultSubview.h"
#import "MBOcrLayoutSubview.h"

// Recognizers
#import "PPBlinkInputRecognizers.h"

#endif
