//
//  TimeSolverApp.swift
//  TimeSolver
//
//  Created by 段奕含 on 2021/5/20.
//

import SwiftUI

@main
struct TimeSolverApp: App {
    let persistenceController = PersistenceController.shared
    

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .onAppear {
                    let center = UNUserNotificationCenter.current()
                    center.requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
                }
        }
    }
}

var W: CGFloat = UIScreen.main.bounds.size.width
var H: CGFloat = UIScreen.main.bounds.size.height
