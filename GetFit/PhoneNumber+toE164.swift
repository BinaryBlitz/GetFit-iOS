//
//  PhoneNumber+toE164.swift
//  GetFit
//
//  Created by Алексей on 16.02.17.
//  Copyright © 2017 BinaryBlitz. All rights reserved.
//

import Foundation
import PhoneNumberKit

extension PhoneNumber {
  func toE164() -> String? {
    return PhoneNumberKit().format(self, toType: .e164)
  }
}
