//
//  MessageViewModel.swift
//  Alamofire
//
//  Created by admin on 8/8/18.
//

import Foundation
import IGListKit


open class MessageViewModel: ListDiffable {
    
    let id: String
    let layout: String
    let height: CGFloat = 0
    
    public init(id: String, layout: String) {
        self.id = id
        self.layout = layout
    }
    
    public func diffIdentifier() -> NSObjectProtocol {
        return id as NSString
    }
    
    public func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? MessageViewModel else {
            return false
        }
        
        return self.id == object.id
    }
}
