//
//  Routine+CoreDataProperties.swift
//  TimeSolver
//
//  Created by 段奕含 on 2021/5/26.
//
//

import Foundation
import CoreData


extension Routine {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Routine> {
        return NSFetchRequest<Routine>(entityName: "Routine")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var routineName: String?
    @NSManaged public var isFinished: Int16
    @NSManaged public var timeRemaining: Int16
    @NSManaged public var time: Int16


}

extension Routine : Identifiable {

}
