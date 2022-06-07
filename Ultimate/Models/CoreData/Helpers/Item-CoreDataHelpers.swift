//
//  Item-CoreDataHelpers.swift
//  Ultimate
//
//  Created by Matthew Sakhnenko on 10.04.2022.
//

import Foundation

extension Item {
    enum SortOrder {
        case optimized, title, creationDate
    }
    
    var itemTitle: String {
        title ?? "New Item"
    }
    
    var itemDetail: String {
        detail ?? ""
    }
    
    var itemCompleted: Bool {
        completed
    }
    
    var itemCreationDate: Date {
        creationDate ?? Date()
    }
        
    static var example: Item {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext
        
        let item = Item(context: viewContext)
        item.title = "Example Item"
        item.detail = "This is an example item"
        item.priority = 3
        item.creationDate = Date()
        
        return item
    }
}
