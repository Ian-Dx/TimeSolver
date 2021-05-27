//
//  Lists.swift
//  TimeSolver
//
//  Created by 段奕含 on 2021/5/20.
//

import SwiftUI
import UIKit

struct TaskList: View {
    @FetchRequest(entity: Task.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \Task.isFinished, ascending: true),
        NSSortDescriptor(keyPath: \Task.priority, ascending: false)
    ]) var tasks: FetchedResults<Task>
    
    var body: some View {
        ScrollView {
            ForEach(tasks, id:\.id) {task in
                TaskCheck(task: task)
            }
        }
        .frame(width: W)
    }
}



struct RoutineList: View {
    @FetchRequest(entity: Routine.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \Task.isFinished, ascending: true)
    ]) var routines: FetchedResults<Routine>
    
    var onTapGesture: (Routine) -> Void
    
    let timerEveryDay = Timer.publish(every: 24 * 60 * 60, on: .main, in: .common)
    let timerFirst = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var timerEveryDayConnected = Timer.publish(every: 24 * 60 * 60, on: .main, in: .common).autoconnect()
    
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        ScrollView {
            ForEach(routines, id:\.id) {routine in
                RoutineCheck(routine: routine, onTapGesture: onTapGesture)
            }
        }
        .frame(width: W)
        .onReceive(timerFirst) { date in
            var componets = Calendar.init(identifier: .gregorian).dateComponents([.year,.month,.day,.weekday,.hour,.minute,.second], from: date)
            componets.timeZone = TimeZone(identifier: "Asia/Shanghai")
            if componets.hour == 20 {
                timerEveryDayConnected = timerEveryDay.autoconnect()
                timerFirst.upstream.connect().cancel()
            }

        }
        .onReceive(timerEveryDayConnected) { _ in
            viewContext.performAndWait {
                for routine in routines {
                    routine.timeRemaining = routine.time
                    routine.isFinished = 0
                }
                try? viewContext.save()
            }
        }
        
    }
}

