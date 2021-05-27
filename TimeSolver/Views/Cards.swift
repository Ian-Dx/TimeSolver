//
//  Cards.swift
//  TimeSolver
//
//  Created by 段奕含 on 2021/5/20.
//

import SwiftUI

struct TaskCard: View {
    @Binding var task: Task
    @Binding var priority: Int16
    @State var componets: DateComponents?
    
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        ZStack {
            if componets != nil {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: W - 100, height: 100, alignment: .center)
                    .foregroundColor(Color(#colorLiteral(red: 0.9620534366, green: 0.9620534366, blue: 0.9620534366, alpha: 1)))
                    .shadow(radius: 5, x: 5, y: 5)
                
                VStack(alignment: .leading, spacing: 20) {
                    Text(task.taskName!)
                        .font(.system(size: 20))
                        .bold()
                        .foregroundColor(.gray)
                    HStack(spacing: 2) {
                        Text("\(componets!.month!)-\(componets!.day!) \(componets!.hour!):\(componets!.minute!)")
                            .foregroundColor(.gray)
                        Spacer()
                        if priority > 0 {
                            ForEach(0..<Int(priority), id:\.self) { _ in
                                Image(systemName: "star.fill")
                                    .foregroundColor(Color(#colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)))
                            }
                        }
                        if priority < 6 {
                            ForEach(priority..<6, id:\.self) { _ in
                                Image(systemName: "star")
                                    .foregroundColor(Color(#colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)))
                            }
                        }
                    }
                }
                .padding()
                .frame(width: W - 100, height: 100, alignment: .leading)
            }
        }
        .onAppear {
            componets = Calendar.init(identifier: .gregorian).dateComponents([.year,.month,.day,.weekday,.hour,.minute,.second], from: task.deadline!)
        }
        .frame(width: W - 100, height: 100)
        .padding(.vertical, 10)
        
    }
}



struct RoutineCard: View {
    @Binding var routine: Routine
    
    @Environment(\.managedObjectContext) private var viewContext
    
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: W - 100, height: 100, alignment: .center)
                .foregroundColor(Color(#colorLiteral(red: 0.9620534366, green: 0.9620534366, blue: 0.9620534366, alpha: 1)))
                .shadow(radius: 5, x: 5, y: 5)
            
            HStack(spacing: 20) {
                Text(routine.routineName!)
                    .font(.system(size: 20))
                    .bold()
                    .foregroundColor(.gray)
                Spacer()
                Text("\(Int(routine.timeRemaining / 60)) mins \(Int(routine.timeRemaining % 60)) secs")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
            .padding()
            .frame(width: W - 100, height: 100, alignment: .leading)
            
        }
        .frame(width: W - 100, height: 100)
        .padding(.vertical, 10)
    }
}
