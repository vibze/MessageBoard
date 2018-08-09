//
//  MessageBoardViewController.swift
//  Alamofire
//
//  Created by admin on 8/8/18.
//

import UIKit
import IGListKit


public class MessageBoardViewController: UIViewController {
    
    public var messages: [MessageViewModel] {
        get { return dataSource.messages }
        set (v) { dataSource.messages = messages }
    }
    
    public func registerMessageLayout(_ c: AnyClass, layout: String) {
        collectionView.register(c, forCellWithReuseIdentifier: layout)
        dataSource.layouts[layout] = c
    }
    
    var dataSource = DataSource()
    
    lazy var collectionView: ListCollectionView = {
        let layout = ListCollectionViewLayout(stickyHeaders: true, scrollDirection: .vertical, topContentInset: 0, stretchToEdge: true)
        let cv = ListCollectionView(frame: CGRect.zero, listCollectionViewLayout: layout)
        
        return cv
    }()
    
    lazy var adapter: ListAdapter = {
        let updater = ListAdapterUpdater()
        let adapter = ListAdapter(updater: updater, viewController: self, workingRangeSize: 1)
        // workingRangeSize: range of section controllers who aren’t yet visible, but are near the screen.
        
        adapter.collectionView = collectionView
        adapter.dataSource = dataSource
        
        return adapter
    }()
    
    
    class DataSource: NSObject, ListAdapterDataSource, MessageBoardSectionControllerDelegate {
        
        var messages: [MessageViewModel] = []
        var layouts: [String: AnyClass] = [:]
        
        func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
            return messages
        }
        
        func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
            let controller = MessageBoardSectionController()
            controller.delegate = self
            return controller
        }
        
        func emptyView(for listAdapter: ListAdapter) -> UIView? {
            return nil
        }
        
        func layoutClassForIdentifier(_ id: String) -> AnyClass? {
            return layouts[id]
        }
    }
}


class MessageBoardSectionController: ListSectionController {
    
    weak var delegate: MessageBoardSectionControllerDelegate?
    var message: MessageViewModel?
    
    override func didUpdate(to object: Any) {
        guard let message = object as? MessageViewModel else {
            return
        }
        
        self.message = message
    }
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let ctx = collectionContext, let message = message, let layoutClass = delegate?.layoutClassForIdentifier(message.layout) else {
            return UICollectionViewCell()
        }
        
        let cell = ctx.dequeueReusableCell(of: layoutClass, withReuseIdentifier: message.layout, for: self, at: index)
        
        if let cell = cell as? MessageViewLayout {
            cell.updateMessage(message)
        }
        
        return cell
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext?.containerSize.width ?? 0, height: message?.height ?? 0)
    }
}


protocol MessageBoardSectionControllerDelegate: class {
    func layoutClassForIdentifier(_ id: String) -> AnyClass?
}


protocol MessageViewLayout {
    func updateMessage(_ message: MessageViewModel)
}
