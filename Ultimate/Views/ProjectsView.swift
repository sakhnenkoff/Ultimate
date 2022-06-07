//
//  ProjectsView.swift
//  Ultimate
//
//  Created by Matthew Sakhnenko on 02.04.2022.
//

import SwiftUI

struct ProjectsView: View {
    static let openTag: String? = "Open"
    static let closedTag: String? = "Closed"
    let showClosedProjects: Bool
    
    let projects: FetchRequest<Project>
    let mockArray = ["String, String2"]
    
    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var moc
    
    @State private var showingSortOrder = false
    @State private var sortOrder: Item.SortOrder = .optimized
    
    init(showClosedProjects: Bool) {
        self.showClosedProjects = showClosedProjects
        
        projects = FetchRequest<Project>(entity: Project.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Project.creationDate, ascending: false)], predicate: NSPredicate(format: "closed = %d", showClosedProjects))
    }
    
    var body: some View {
        NavigationView {
            Group {
                if projects.wrappedValue.isEmpty {
                  Text("There is nothing here right now")
                        .foregroundColor(.secondary)
                } else {
                    List {
                        ForEach(projects.wrappedValue) { project in
                            Section(header: ProjectHeaderView(project: project)) {
                                ForEach(items(for: project)) { item in
                                    ItemRowView(project: project, item: item)
                                }
                                .onDelete { offsets in
                                    let allItems = items(for: project)
                                    
                                    for offset in offsets {
                                        let item = allItems[offset]
                                        dataController.delete(item)
                                        dataController.save()
                                    }
                                }
                                
                                if !showClosedProjects {
                                    Button {
                                        withAnimation {
                                            let item = Item(context: moc)
                                            item.project = project
                                            item.creationDate = Date()
                                            dataController.save()
                                        }
                                    } label: {
                                        Label("Add new Item", systemImage: "plus")
                                    }
                                }
                                
                            }
                        }
                    }.listStyle(InsetGroupedListStyle())
                }
            }
            .navigationTitle(showClosedProjects ? "Closed Projects" : "Open Projects")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if showClosedProjects == false {
                        Button {
                            withAnimation {
                                let project = Project(context: moc)
                                project.closed = false
                                project.creationDate = Date()
                                project.items = []
                                dataController.save()
                            }
                        } label: {
                            Label("Add Project", systemImage: "plus")
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showingSortOrder.toggle()
                    } label: {
                        Label("Sort", systemImage: "arrow.up.arrow.down")
                    }

                }
            }
            .actionSheet(isPresented: $showingSortOrder) {
                ActionSheet(title: Text("Sort Items"), message: nil, buttons: [
                    .default(Text("Optimized")) { sortOrder = .optimized },
                    .default(Text("Creation Date")) { sortOrder = .creationDate },
                    .default(Text("Title")) { sortOrder = .title },
                ])
            }
            
            SelectSomethingView()
        }
    }
    
    func items(for project: Project) -> [Item] {
        switch sortOrder {
        case .title:
            return project.wrappedItems.sort(by: \Item.itemTitle)
        case .creationDate:
            return project.wrappedItems.sort(by: \Item.itemCreationDate)
        case .optimized:
           return project.wrappeedItemsDefaultSorted
        }
    }
}

struct ProjectsView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    
    static var previews: some View {
        ProjectsView(showClosedProjects: false)
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}


