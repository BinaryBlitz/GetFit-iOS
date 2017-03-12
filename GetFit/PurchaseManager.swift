//
//  PurchaseManager.swift
//  GetFit
//
//  Created by Алексей on 12.03.17.
//  Copyright © 2017 BinaryBlitz. All rights reserved.
//

import Foundation
import SwiftyStoreKit
import SwiftyJSON
import StoreKit
import RealmSwift
import Realm

enum PurchaseError {
  case unknown
  case responseServerError
  case storeKitError(SKError)
}

class PurchaseManager {
  static let instance = PurchaseManager()
  private init() { }
  var programsProvider = APIProvider<GetFit.Programs>()

  enum PurchaseResult {
    case success
    case failure(PurchaseError)
  }

  func buy(program: Program, _ completion: ((PurchaseResult) -> Void)? = nil) {
    print("Buying \(program.productIdentifier)")
    SwiftyStoreKit.purchaseProduct(program.productIdentifier, atomically: false) { result in
      switch result {
      case .success(let product):
        self.programsProvider.request(.createPurchase(programId: program.id)) { result in
          switch result {
            case .success(let response):
              do {
                try _ = response.filterSuccessfulStatusCodes()
                if let purchaseId = try JSON(response.mapJSON())["id"].int {
                  let realm = try Realm()
                  try realm.write {
                    program.purchaseId = purchaseId
                  }
                }
                if product.needsFinishTransaction {
                  SwiftyStoreKit.finishTransaction(product.transaction)
                }
                completion?(.success)
              } catch {
                completion?(.failure(.responseServerError))
            }
            case .failure(let error):
              completion?(.failure(.unknown))
          }
        }
      case .error(let error):
        completion?(.failure(.storeKitError(error)))
      }
    }
  }
}
