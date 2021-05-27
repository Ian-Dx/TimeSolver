//
//  Task+CoreDataProperties.swift
//  TimeSolver
//
//  Created by 段奕含 on 2021/5/20.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var taskName: String?
    @NSManaged public var priority: Int16
    @NSManaged public var deadline: Date?
    @NSManaged public var isFinished: Int16

}

extension Task : Identifiable {

}
