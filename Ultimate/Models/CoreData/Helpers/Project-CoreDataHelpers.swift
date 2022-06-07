//
//  Project-CoreDataHelpers.swift
//  Ultimate
//
//  Created by Matthew Sakhnenko on 10.04.2022.
//

import Foundation

extension Project {
    
    static let colors = ["Pink", "Purple", "Red", "Orange", "Gold", "Green", "Teal", "Light Blue", "Dark Blue", "Midnight", "Dark Gray", "Gray"]
    
    var projectTitle: String {
        title ?? "New Project"
    }
    
    var projectDetail: String {
        detail ?? ""
    }
    
    var projectColor: String {
        color ?? "Light Blue"
    }
    
    var wrappedItems: [Item] {
        let items = items?.allObjects as? [Item] ?? []
       return items
    }

    var wrappeedItemsDefaultSorted: [Item] {
        return wrappedItems.sorted { first, second in
                if first.completed == false {
                    if second.completed == true {
                        return true
                    }
                } else if first.completed == true {
                    if second.completed == false {
                        return false
                    }
                }
                
                if first.priority > second.priority {
                    return true
                } else if first.priority < second.priority {
                    return false
                }
                
                return first.itemCreationDate < second.itemCreationDate
            }
    }
    
    var completionAmount: Double {
        let originalItems = items?.allObjects as? [Item] ?? []
        guard !originalItems.isEmpty else { return 0 }
        let completedItems = originalItems.filter(\.completed)
        let result = Double(completedItems.count) / Double(originalItems.count)

        return result
    }
    
    static var example: Project {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext
        
        let project = Project(context: viewContext)
        project.title = "Example Project"
        project.detail = "This is an example Project"
        project.closed = true
        project.creationDate = Date()
        
        return project
    }
}
