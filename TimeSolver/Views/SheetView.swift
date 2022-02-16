//
//  SheetView.swift
//  TimeSolver
//
//  Created by 段奕含 on 2021/5/20.
//

import SwiftUI

struct TaskSheet: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var showingSheet: Bool
    
    @State var taskName: String = ""
    @State var priority: Int = 0
    @State var deadline: Date = Date()
    

    var body: some View {
        VStack(spacing: 30) {
            HStack {
                TopButton(title: "Cancel")
                    .onTapGesture {
                        showingSheet = false
                    }
                Spacer()
                TopButton(title: "Add")
                    .onTapGesture {
                        
                        /// 添加
                        let newTask = Task(context: viewContext)
                        newTask.deadline = deadline
                        if taskName == "" {
                            taskName = "New Plan"
                        }
                        newTask.taskName = taskName
                        if priority == 0 {
                            priority = 1
                        }
                        newTask.priority = Int16(priority)
                        newTask.isFinished = 0
                        newTask.id = UUID()
                        
                        do {
                            try viewContext.save()
                        } catch {
                            print(error.localizedDescription)
                        }
                        
                        /// 推送
                        let notificationCenter = UNUserNotificationCenter.current()
                        notificationCenter.getNotificationSettings { settings in
                            // 如果授权了
                            if(settings.authorizationStatus == .authorized) {
                                //推送时间
                                var notificationTime = Calendar.init(identifier: .gregorian).dateComponents([.year,.month,.day,.weekday,.hour,.minute,.second], from: deadline)
                                notificationTime.timeZone = TimeZone(identifier: "Asia/Shanghai")
                                // 提前一天推送
                                var notificationDay = notificationTime
                                notificationDay.day = notificationDay.day! - 1
                                notificationDay.weekday = notificationDay.weekday! - 1
                                // 提前两小时推送
                                var notificationHour = notificationTime
                                notificationHour.hour = notificationHour.hour! - 2
                                
                                                        
                                // 推送内容
                                let contentTime = UNMutableNotificationContent()
                                contentTime.title = "Deadline!!"
                                contentTime.body = "\(taskName) is almost due in one day!!"
                                contentTime.sound = UNNotificationSound.default
                                
                                let contentDay = UNMutableNotificationContent()
                                contentDay.title = "Deadline!!"
                                contentDay.body = "\(taskName) is almost due in one hour!!"
                                contentDay.sound = UNNotificationSound.default
                                
                                let contentHour = UNMutableNotificationContent()
                                contentHour.title = "Deadline!!"
                                contentHour.body = "\(taskName) is almost due now!!"
                                contentHour.sound = UNNotificationSound.default

                                
                                // 创建trigger和request
                                let triggerDay = UNCalendarNotificationTrigger(dateMatching: notificationDay, repeats: false)
                                let triggerHour = UNCalendarNotificationTrigger(dateMatching: notificationHour, repeats: false)
                                let triggerTime = UNCalendarNotificationTrigger(dateMatching: notificationTime, repeats: false)
                                
                                let requestDay = UNNotificationRequest(identifier: "\(taskName)_day", content: contentDay, trigger: triggerDay)
                                let requestHour = UNNotificationRequest(identifier: "\(taskName)_hour", content: contentHour, trigger: triggerHour)
                                let requestTime = UNNotificationRequest(identifier: "\(taskName)_time", content: contentTime, trigger: triggerTime)

                                
                                // 添加推送
                                notificationCenter.add(requestDay) { _ in }
                                notificationCenter.add(requestHour) { _ in }
                                notificationCenter.add(requestTime) { _ in }
                            }
                            

                        }
                        
                        
                        showingSheet = false
                    }
            }
            .padding(.horizontal, 40)
            .padding(.top, 100)
            Spacer()
            NameItem(name: $taskName)
            TimeItem(deadline: $deadline)
            PriorityItem(priority: $priority)
            Spacer()
            Spacer()
        }
    }
}



struct RoutineSheet: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var showingSheet: Bool
    
    @State var routineName: String = ""
    @State var routineTimeRemaining: String = ""
    

    var body: some View {
        VStack(spacing: 30) {
            HStack {
                TopButton(title: "Cancel")
                    .onTapGesture {
                        showingSheet = false
                    }
                Spacer()
                TopButton(title: "Add")
                    .onTapGesture {
                        /// 添加
                        let newRoutine = Routine(context: viewContext)
                        if routineName == "" {
                            routineName = "New Routine"
                        }
                        
                        newRoutine.routineName = routineName
                        if let routineTimeRemaining = Int(routineTimeRemaining), routineTimeRemaining >= 0, routineTimeRemaining < 60 * 12 {
                            newRoutine.timeRemaining = Int16(routineTimeRemaining) * 60
                            newRoutine.time = Int16(routineTimeRemaining) * 60
                        }else {
                            newRoutine.timeRemaining = 45 * 60
                            newRoutine.time = 45 * 60
                        }
                        
      
                        newRoutine.isFinished = 0
                        newRoutine.id = UUID()
                        
                        do {
                            try viewContext.save()
                        } catch {
                            print(error.localizedDescription)
                        }
                        showingSheet = false

                        
                    }
            }
            .padding(.horizontal, 40)
            .padding(.top, 100)
            Spacer()
            LastingItem(lasting: $routineTimeRemaining)
            NameItem(name: $routineName, padding: "Enter a routine")
            Spacer()
            Spacer()
        }
    }
}

struct NameItem: View {
    @Binding var name: String
    var title = "TO DO"
    var padding = "Enter a task"
    
    var body: some View {
        HStack(spacing: 0) {
            Text(title)
                .font(.system(size: 25))
                .foregroundColor(.gray)
                .frame(width: 110, height: 40)
            
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .frame(width: W - 150, height: 40)
                    .foregroundColor(Color(#colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.937254902, alpha: 1)))
                    .accentColor(Color(#colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.7764705882, alpha: 1)))
                
                TextField(padding, text: $name)
                    .padding()
            }
        }
        .frame(width: W - 40, height: 40)
        .padding()
    }
}


struct LastingItem: View {
    @Binding var lasting: String
    var title = "Lasting mins"
    
    var body: some View {
        HStack(spacing: 0) {
            Text(title)
                .font(.system(size: 25))
                .foregroundColor(.gray)
                .frame(width: 200, height: 40)
            
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .frame(width: 70, height: 70)
                    .foregroundColor(Color(#colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.937254902, alpha: 1)))
                    .accentColor(Color(#colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.7764705882, alpha: 1)))
                
                TextField("", text: $lasting)
                    .padding()
                    .frame(width: 70, height: 70)
                    .keyboardType(.numberPad)
                    .foregroundColor(.gray)
                    .font(.system(size: 24))

            }

        }
        .offset(x: -30)
        .frame(width: W - 40, height: 40)
        .padding()
    }
}
struct TimeItem: View {
    @Binding var deadline: Date
    
    var body: some View {
        HStack(spacing: 0) {
            Text("Deadline")
                .font(.system(size: 25))
                .foregroundColor(.gray)
                .frame(width: 110, height: 40)
            
            DatePicker("", selection: $deadline)
                .accentColor(.black)
                .frame(width: W - 150, height: 40)
                .padding(0)
                .offset(x: -3)
        }
        .frame(width: W - 40, height: 40)
        .padding()
    }
}


struct PriorityItem: View {
    @Binding var priority: Int
    
    var body: some View {
        HStack(spacing: 0) {
            Text("Priority")
                .font(.system(size: 25))
                .foregroundColor(.gray)
                .frame(width: 110, height: 40)
            
            HStack(spacing: 2) {
                ForEach(0..<6) { idx in
                    Image(systemName: idx >= priority ? "star" : "star.fill")
                        .foregroundColor(.gray)
                        .font(.system(size: 24))
                        .onTapGesture {
                            priority = idx + 1
                        }
                }
            }
        }
        .frame(width: W - 40, height: 40)
        .padding()
    }
}



struct TopButton: View {
    var title: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .frame(width: 90, height: 40)
                .foregroundColor(Color(#colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.937254902, alpha: 1)))
                .shadow(radius: 3, x: 3, y: 3)

            Text(title)
                .font(.system(size: 22))
                .foregroundColor(.gray)
        }
        
    }
}

