//
//  AVFileType+descriptor.swift
//  VisionCamera
//
//  Created by Marc Rousavy on 01.05.21.
//  Copyright © 2021 Facebook. All rights reserved.
//

import Foundation
import AVFoundation

extension AVFileType {
  init(withString string: String) {
    self.init(rawValue: string)
  }
  
  var descriptor: String {
    return self.rawValue
  }
}
