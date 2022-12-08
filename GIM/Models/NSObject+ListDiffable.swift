//
//  NSObject+ListDiffable.swift
//  GIM
//
//  Created by Tubagus Adhitya Permana on 22/10/22.
//

import IGListKit

extension NSObject: ListDiffable {
  public func diffIdentifier() -> NSObjectProtocol {
    return self
  }

  public func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
    return isEqual(object)
  }
}
