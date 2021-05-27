//
//  TimeView.swift
//  TimeSolver
//
//  Created by 段奕含 on 2021/5/21.
//

import SwiftUI

struct TaskTimeView: View {
    @Binding var goTimeView: Bool
    @State var subTitle: String
    
    @FetchRequest(entity: Task.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \Task.isFinished, ascending: true),
        NSSortDescriptor(keyPath: \Task.priority, ascending: false)
    ]) var tasks: FetchedResults<Task>
    
    @State var taskName = ""
    @State var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var minRemaining = "45"
    @State var secRemaining = "00"
    @State var timeRemaining = 45 * 60
    @State var isTimePaused = false
    @State var fontSize: CGFloat = 30
    @State var offsetY: CGFloat = H
    @State var animationControl = true
    
    var body: some View {
        ZStack {
            Image("1")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: W, height: H, alignment: .center)
            
            VStack(spacing: 25) {
                Text(taskName)
                    .font(.system(size: 45))
                    .bold()
                    .padding(.horizontal, 30)
                    .padding(.top, 56)
                Text(subTitle)
                    .font(.system(size: fontSize))
                    .foregroundColor(.gray)
                    .padding(.horizontal, 30)
                Spacer()
            }
            
            VStack(spacing: 50) {
                HStack(spacing: 30) {
                    SingleTime(time: $minRemaining)
                    SingleTime(time: $secRemaining)
                }
                HStack(spacing: 20) {
                    BottomButton(title: "Back")
                        .onTapGesture {
                            animationControl = true
                            offsetY = H
                            DispatchQueue.main.asyncAfter(wallDeadline: .now() + .milliseconds(300), execute: { [self] in
                                goTimeView = false
                            })
                        }
                    BottomButton(title: isTimePaused ? "Resume" : "Pause")
                        .onTapGesture {
                            isTimePaused.toggle()
                            if isTimePaused {
                                timer.upstream.connect().cancel()
                            }else {
                                timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
                            }
                        }
                }
            }
            .offset(y: -30)
        }
        .onReceive(timer) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
                let min = Int(timeRemaining / 60)
                let sec = Int(timeRemaining % 60)
                
                minRemaining = String(format:"%02d", arguments: [min])
                secRemaining = String(format:"%02d", arguments: [sec])
            }else {
                subTitle = "Well done!"
                fontSize = 60
            }
        }
        .animation(animationControl ? .spring() : .none)
        .onAppear {
            if tasks.count > 0 {
                let maxIndex = tasks.lastIndex() { task in
                    return task.priority == tasks[0].priority && task.isFinished == 0
                }!

                let randomIndex = Int.random(in: 0...maxIndex)
                
                taskName = tasks[randomIndex].taskName!
            }else {
                taskName = "No plan now! Go for fun!"
            }
            DispatchQueue.main.asyncAfter(wallDeadline: .now() + .milliseconds(100), execute: { [self] in
                offsetY = 0
            })
            DispatchQueue.main.asyncAfter(wallDeadline: .now() + .milliseconds(500), execute: { [self] in
                animationControl = false
            })
        }
        .offset(y: offsetY)


    }
}


struct RoutineTimeView: View {
    @Binding var goTimeView: Bool
    @State var subTitle: String
    
    @State var id: UUID
    
    @FetchRequest(entity: Routine.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \Task.isFinished, ascending: true)
    ]) var routines: FetchedResults<Routine>
    
    @Environment(\.managedObjectContext) private var viewContext

    
    @State var routineName = ""
    @State var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var minRemaining = "45"
    @State var secRemaining = "00"
    @State var timeRemaining = 45 * 60
    @State var isTimePaused = false
    @State var fontSize: CGFloat = 30
    @State var offsetY: CGFloat = H
    @State var animationControl = true
    @State var routine: Routine?
    
    var body: some View {
        ZStack {
            Image("1")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: W, height: H, alignment: .center)
            
            VStack(spacing: 25) {
                Text(routineName)
                    .font(.system(size: 45))
                    .bold()
                    .padding(.horizontal, 30)
                    .padding(.top, 56)
                Text(subTitle)
                    .font(.system(size: fontSize))
                    .foregroundColor(.gray)
                    .padding(.horizontal, 30)
                Spacer()
            }
            
            VStack(spacing: 50) {
                HStack(spacing: 30) {
                    SingleTime(time: $minRemaining)
                    SingleTime(time: $secRemaining)
                }
                HStack(spacing: 20) {
                    BottomButton(title: "Back")
                        .onTapGesture {
                            /// 更新core data
                            viewContext.performAndWait {
                                routine!.timeRemaining = Int16(timeRemaining)
                                if timeRemaining == 0 {
                                    routine!.isFinished = 1
                                }
                                try? viewContext.save()
                            }
                            
                            animationControl = true
                            offsetY = H
                            DispatchQueue.main.asyncAfter(wallDeadline: .now() + .milliseconds(300), execute: { [self] in
                                goTimeView = false
                            })
                        }
                    BottomButton(title: isTimePaused ? "Resume" : "Pause")
                        .onTapGesture {
                            isTimePaused.toggle()
                            if isTimePaused {
                                timer.upstream.connect().cancel()
                            }else {
                                timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
                            }
                        }
                }
            }
            .offset(y: -30)
        }
        .onReceive(timer) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
                let min = Int(timeRemaining / 60)
                let sec = Int(timeRemaining % 60)
                
                minRemaining = String(format:"%02d", arguments: [min])
                secRemaining = String(format:"%02d", arguments: [sec])
            }else {
                subTitle = "Well done!"
                fontSize = 60
            }
        }
        .animation(animationControl ? .spring() : .none)
        .onAppear {
            /// 时间
            routine = routines.filter { routine in
                routine.id == id
            }[0]
            
            routineName = routine!.routineName!
            
            timeRemaining = Int(routine!.timeRemaining)
            
            let min = Int(timeRemaining / 60)
            let sec = Int(timeRemaining % 60)
            
            minRemaining = String(format:"%02d", arguments: [min])
            secRemaining = String(format:"%02d", arguments: [sec])
            
            if timeRemaining == 0 {
                subTitle = "Well done!"
                fontSize = 60
            }
            
            
            /// 动画
            DispatchQueue.main.asyncAfter(wallDeadline: .now() + .milliseconds(100), execute: { [self] in
                offsetY = 0
            })
            DispatchQueue.main.asyncAfter(wallDeadline: .now() + .milliseconds(500), execute: { [self] in
                animationControl = false
            })
        }
        .offset(y: offsetY)


    }
}


struct SingleTime: View {
    @Binding var time: String
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(Color(#colorLiteral(red: 0.4477933049, green: 0.4478728175, blue: 0.4477828145, alpha: 1)))
                .shadow(color: .black, radius: 4, x: 4, y: 4)
                .frame(width: 100, height: 100, alignment: .center)
            Text(time)
                .font(.system(size: 50))
                .bold()
                .foregroundColor(.white)
                .shadow(color: .black, radius: 2, x: 3, y: 3)
        }
    }
}


struct BottomButton: View {
    var title: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .frame(width: 110, height: 50)
                .foregroundColor(Color(#colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.937254902, alpha: 1)))
                .shadow(radius: 3, x: 3, y: 3)
            
            Text(title)
                .font(.system(size: 26))
                .bold()
                .foregroundColor(.black)
        }
    }
}
