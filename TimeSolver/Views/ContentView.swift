//
//  ContentView.swift
//  TimeSolver
//
//  Created by 段奕含 on 2021/5/20.
//

import SwiftUI
import CoreData
struct ContentView: View {
    @State var goTaskTimeView: Bool = false
    @State var goRoutineTimeView: Bool = false
    
    @State var taskSubTitle: String = UserDefaults.standard.string(forKey: "taskSubTitle") ?? "Move your ass! But don't move your ass!"
    @State var routineSubTitle: String = UserDefaults.standard.string(forKey: "routneSubTitle") ?? "Finish all of them!"
    @State var routineID: UUID?
    
    @State var selectedTab = UserDefaults.standard.integer(forKey: "selectedTab")
    
    
    var body: some View {
        ZStack {
            if goTaskTimeView {
                TaskTimeView(goTimeView: $goTaskTimeView, subTitle: taskSubTitle)
            }else if goRoutineTimeView {
                RoutineTimeView(goTimeView: $goRoutineTimeView, subTitle: routineSubTitle, id: routineID!)
            }else {
                TabView(selection: $selectedTab) {
                    TaskHome(subtitle: $taskSubTitle, goTimeView: $goTaskTimeView)
                        .tabItem {
                            Image(systemName: "exclamationmark.circle.fill")
                            Text("Tasks")
                        }
                        .onAppear {
                            UserDefaults.standard.setValue(0, forKey: "selectedTab")
                        }
                        .tag(0)
                    RoutineHome(subtitle: $routineSubTitle, goTimeView: $goRoutineTimeView, id: $routineID)
                        .tabItem {
                            Image(systemName: "arrow.clockwise.circle.fill")
                            Text("Routines")
                        }
                        .onAppear {
                            UserDefaults.standard.setValue(1, forKey: "selectedTab")
                        }
                        .tag(1)
                }
                .onAppear {
                    selectedTab = UserDefaults.standard.integer(forKey: "selectedTab")
                }
                .accentColor(.black)
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
