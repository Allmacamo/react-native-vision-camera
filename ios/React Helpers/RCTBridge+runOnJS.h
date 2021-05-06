//
//  RCTBridge+runOnJS.h
//  VisionCamera
//
//  Created by Marc Rousavy on 23.03.21.
//  Copyright © 2021 Facebook. All rights reserved.
//

#pragma once

#import <Foundation/Foundation.h>
#import <React/RCTBridge.h>

@interface RCTBridge (RCTBridgeRunOnJS)

- (void) runOnJS:(void (^)(void))block;

@end
