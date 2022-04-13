//
//  UltimateApp.swift
//  Ultimate
//
//  Created by Matthew Sakhnenko on 02.04.2022.
//

import SwiftUI

@main
struct UltimateApp: App {
    @StateObject var dataController: DataController
    
    init() {
        let dataController = DataController()
        _dataController = StateObject(wrappedValue: dataController)
        
        configureSupportViews()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification), perform: save)
        }
    }
    
    // MARK:  Configuration
    
    private func configureSupportViews() {
        // TabView
        UITabBar.appearance().shadowImage = UIImage()
    }
    
    // MARK: Actions
    
    func save(_ note: Notification) {
        dataController.save()
    }
}
