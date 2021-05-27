//
//  Home.swift
//  TimeSolver
//
//  Created by 段奕含 on 2021/5/20.
//

import SwiftUI

struct TaskHome: View {
    @State var showingSheet: Bool = false
    
    @Binding var subtitle: String
    @State var bigtitle: String = UserDefaults.standard.string(forKey: "taskBigTitle") ?? "My Tasks"
    
    
    @Binding var goTimeView: Bool
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                TextField("", text: $bigtitle)
                    .font(.bold(.system(size: 40))())
                    .padding(.leading, 30)
                    .padding(.top, 20)
                    .onChange(of: bigtitle) { value in
                        UserDefaults.standard.setValue(bigtitle, forKey: "taskBigTitle")
                    }
                
                Spacer()
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 50))
                    .shadow(radius: 3, x: 3, y: 3)
                    .foregroundColor(.gray)
                    .padding(.top, 20)
                    .onTapGesture {
                        showingSheet = true
                    }
                
                Image(systemName: "arrowtriangle.forward.circle")
                    .font(.system(size: 50))
                    .shadow(radius: 3, x: 3, y: 3)
                    .foregroundColor(.gray)
                    .padding(.trailing, 20)
                    .padding(.top, 20)
                    .onTapGesture {
                        goTimeView = true
                    }
            }
            
            TextField("", text: $subtitle)
                .foregroundColor(.gray)
                .padding(.leading, 30)
                .onChange(of: subtitle) { value in
                    UserDefaults.standard.setValue(subtitle, forKey: "taskSubTitle")
                }
            
            TaskList()
            
        }
        .sheet(isPresented: $showingSheet) {
            TaskSheet(showingSheet: $showingSheet)
        }
    }
}


struct RoutineHome: View {
    @State var showingSheet: Bool = false
    
    @Binding var subtitle: String
    @State var bigtitle: String = UserDefaults.standard.string(forKey: "routineBigTitle") ?? "My Routines"
    
    
    @Binding var goTimeView: Bool
    @Binding var id: UUID?
    
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                TextField("", text: $bigtitle)
                    .font(.bold(.system(size: 40))())
                    .padding(.leading, 30)
                    .padding(.top, 20)
                    .onChange(of: bigtitle) { value in
                        UserDefaults.standard.setValue(bigtitle, forKey: "routineBigTitle")
                    }
                
                Spacer()
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 50))
                    .shadow(radius: 3, x: 3, y: 3)
                    .foregroundColor(.gray)
                    .padding(.top, 20)
                    .padding(.trailing, 20)
                    .onTapGesture {
                        showingSheet = true
                    }
            }
            
            TextField("", text: $subtitle)
                .foregroundColor(.gray)
                .padding(.leading, 30)
                .onChange(of: subtitle) { value in
                    UserDefaults.standard.setValue(subtitle, forKey: "routneSubTitle")
                }
            
            RoutineList(onTapGesture: onTapGesture)
        }
        .sheet(isPresented: $showingSheet) {
            RoutineSheet(showingSheet: $showingSheet)
        }
        
    }
    
    func onTapGesture(routine: Routine) {
        id = routine.id!
        goTimeView = true
    }
}
