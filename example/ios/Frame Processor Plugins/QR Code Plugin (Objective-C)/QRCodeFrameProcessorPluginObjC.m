//
//  QRCodeFrameProcessorPluginObjC.m
//  VisionCameraExample
//
//  Created by Marc Rousavy on 01.05.21.
//

#import <Foundation/Foundation.h>
#import <VisionCamera/FrameProcessorPlugin.h>
#import <Vision/VNDetectBarcodesRequest.h>
@import AVFoundation;
@import MLKitVision;
@import MLKit;
@import MLKitImageLabeling;
@import MLKitImageLabelingCommon;

// Example for an Objective-C Frame Processor plugin

@interface QRCodeFrameProcessorPluginObjC : NSObject

+ (MLKImageLabeler*) labeler;

@end

@implementation QRCodeFrameProcessorPluginObjC

+ (MLKImageLabeler*) labeler {
  static MLKImageLabeler* labeler = nil;
  if (labeler == nil) {
    MLKImageLabelerOptions* options = [[MLKImageLabelerOptions alloc] init];
    labeler = [MLKImageLabeler imageLabelerWithOptions:options];
  }
  return labeler;
}

static inline id exampleObjC___scanQRCodes(CMSampleBufferRef buffer, NSArray* arguments) {
  CFTimeInterval startTime = CACurrentMediaTime();

  MLKVisionImage *image = [[MLKVisionImage alloc] initWithBuffer:buffer];
  image.orientation = [QRCodeFrameProcessorPluginObjC imageOrientationFromDeviceOrientation:UIDevice.currentDevice.orientation
                                                                             cameraPosition:AVCaptureDevicePositionBack];
  
  NSError* error;
  NSArray<MLKImageLabel*>* labels = [[QRCodeFrameProcessorPluginObjC labeler] resultsInImage:image error:&error];
  
  NSMutableArray* results = [NSMutableArray arrayWithCapacity:labels.count];
  for (MLKImageLabel* label in labels) {
    [results addObject:@{ @"label": label.text, @"confidence": [NSNumber numberWithFloat:label.confidence] }];
  }
  
  CFTimeInterval elapsedTime = CACurrentMediaTime() - startTime;
  NSLog(@"Native took: %fms", elapsedTime * 1000.0);
  return results;
}

+ (UIImageOrientation) imageOrientationFromDeviceOrientation:(UIDeviceOrientation)deviceOrientation
                                              cameraPosition:(AVCaptureDevicePosition)cameraPosition {
  switch (deviceOrientation) {
    case UIDeviceOrientationPortrait:
      return cameraPosition == AVCaptureDevicePositionFront ? UIImageOrientationLeftMirrored
      : UIImageOrientationRight;
      
    case UIDeviceOrientationLandscapeLeft:
      return cameraPosition == AVCaptureDevicePositionFront ? UIImageOrientationDownMirrored
      : UIImageOrientationUp;
    case UIDeviceOrientationPortraitUpsideDown:
      return cameraPosition == AVCaptureDevicePositionFront ? UIImageOrientationRightMirrored
      : UIImageOrientationLeft;
    case UIDeviceOrientationLandscapeRight:
      return cameraPosition == AVCaptureDevicePositionFront ? UIImageOrientationUpMirrored
      : UIImageOrientationDown;
    case UIDeviceOrientationUnknown:
    case UIDeviceOrientationFaceUp:
    case UIDeviceOrientationFaceDown:
      return UIImageOrientationUp;
  }
}

VISION_EXPORT_FRAME_PROCESSOR(exampleObjC___scanQRCodes)

@end
