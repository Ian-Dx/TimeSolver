//
//  CardsWithCheck.swift
//  TimeSolver
//
//  Created by 段奕含 on 2021/5/26.
//

import SwiftUI


struct TaskCheck: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State var task: Task
    @State var offsetW: CGFloat = 0
    @State var circleImageName: String = "circle"
    @State var priority: Int16 = 0
    
    
    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: circleImageName)
                .foregroundColor(.gray)
                .shadow(radius: 3, x: 3, y: 3)
                .font(.system(size: 30))
                .onTapGesture {
                    let newIsFinished: Int16 = task.isFinished == 0 ? 1 : 0
                    circleImageName = newIsFinished == 0 ? "circle" : "checkmark.circle.fill"
                    
                    /// 取消推送
                    let notificationCenter = UNUserNotificationCenter.current()
                    notificationCenter.getNotificationSettings { settings in
                        // 如果授权了
                        if(settings.authorizationStatus == .authorized) {
                            notificationCenter.removePendingNotificationRequests(withIdentifiers: ["\(task.taskName!)_day", "\(task.taskName!)_hour", "\(task.taskName!)_time"])
                        }
                    }
                    
                    /// 更新core data
                    viewContext.performAndWait {
                        task.isFinished = newIsFinished
                        try? viewContext.save()
                    }
                }
            TaskCard(task: $task, priority: $priority)
                .onTapGesture(count: 2) {
                    /// 更新
                    if task.priority < 6 {
                        viewContext.performAndWait {
                            task.priority += 1
                            priority += 1
                            try? viewContext.save()
                        }
                    }
                }
                .onLongPressGesture {
                    /// 更新
                    if task.priority > 1 {
                        viewContext.performAndWait {
                            task.priority -= 1
                            priority -= 1
                            try? viewContext.save()
                            
                        }
                    }
                }
        }
        .frame(width: W)
        .offset(x: offsetW < W * 0.2 ? offsetW : 0, y: 0)
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    self.offsetW = gesture.translation.width
                }
                .onEnded { gestrue in
                    /// 删除
                    if gestrue.translation.width < -0.34 * W {
                        offsetW = -W
                        
                        /// 取消推送
                        let notificationCenter = UNUserNotificationCenter.current()
                        notificationCenter.getNotificationSettings { settings in
                            // 如果授权了
                            if(settings.authorizationStatus == .authorized) {
                                notificationCenter.removePendingNotificationRequests(withIdentifiers: ["\(task.taskName!)_day", "\(task.taskName!)_hour", "\(task.taskName!)_time"])
                            }
                        }
                        
                        DispatchQueue.main.asyncAfter(wallDeadline: .now() + .milliseconds(100), execute: { [self] in
                            /// 删除core data
                            viewContext.delete(task)
                            do {
                                try viewContext.save()
                            } catch {
                                print(error.localizedDescription)
                            }
                            
                        })
                    }else {
                        offsetW = 0
                    }
                }
        )
        .animation(.spring())
        .onAppear {
            circleImageName = task.isFinished == 0 ? "circle" : "checkmark.circle.fill"
            priority = task.priority
        }
    }
}



struct RoutineCheck: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State var routine: Routine
    @State var offsetW: CGFloat = 0
    @State var circleImageName: String = "circle"
    var onTapGesture: (Routine) -> Void

    
    
    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: circleImageName)
                .foregroundColor(.gray)
                .shadow(radius: 3, x: 3, y: 3)
                .font(.system(size: 30))
                .onTapGesture {
                    let newIsFinished: Int16 = routine.isFinished == 0 ? 1 : 0
                    circleImageName = newIsFinished == 0 ? "circle" : "checkmark.circle.fill"
                    
                    /// 更新core data
                    viewContext.performAndWait {
                        routine.isFinished = newIsFinished
                        try? viewContext.save()
                    }
                }
            RoutineCard(routine: $routine)
                .onTapGesture {
                    onTapGesture(routine)
                }
        }
        .frame(width: W)
        .offset(x: offsetW < W * 0.2 ? offsetW : 0, y: 0)
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    self.offsetW = gesture.translation.width
                }
                .onEnded { gestrue in
                    /// 删除
                    if gestrue.translation.width < -0.34 * W {
                        offsetW = -W
                        
                        DispatchQueue.main.asyncAfter(wallDeadline: .now() + .milliseconds(100), execute: { [self] in
                            /// 删除core data
                            viewContext.delete(routine)
                            do {
                                try viewContext.save()
                            } catch {
                                print(error.localizedDescription)
                            }
                            
                        })
                    }else {
                        offsetW = 0
                    }
                }
        )
        .animation(.spring())
        .onAppear {
            circleImageName = routine.isFinished == 0 ? "circle" : "checkmark.circle.fill"
        }
    }
}
