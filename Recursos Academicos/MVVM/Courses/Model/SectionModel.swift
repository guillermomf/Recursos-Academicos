//
//  SectionModel.swift
//  Recursos Academicos
//
//  Created by Daniel Cab Hernández on 25/02/19.
//  Copyright © 2019 Integra IT Soluciones. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreData

class SectionModel: Hashable {
    
    // Conformidad con Equatable
     static func == (lhs: SectionModel, rhs: SectionModel) -> Bool {
         return lhs.id == rhs.id
     }
     
     // Conformidad con Hashable
     func hash(into hasher: inout Hasher) {
         hasher.combine(id)  // Usualmente, el id es suficiente si es único
     }
    var id : Int
    var order : Int
    var content : String?
    var name : String?
    var course : String?
    var courseId : Int
    var classes : [SectionClassModel] = []
    
    //Inicializa un objeto de tipo respuesta para pregunta de examen
    init(withJsonObject json: JSON, coursedId : Int) {
        
        id  = json["id"].int!
        order = json["order"].int ?? 0
        content = json["content"].string
        name = json["name"].string
        course = json["course"].string
        courseId = coursedId
        
        //Obtener el listado de clases de la sección
        if let classList = json["courseClasses"].array {
            for classObject in classList {
                let newClass = SectionClassModel(withJsonObject: classObject, sectionId: id)
                classes.append(newClass)
            }
        }
    }
    
    init(withDbObject dbObject: NSManagedObject) {
        id = dbObject.value(forKey: "id") as! Int
        order = dbObject.value(forKey: "order") as! Int
        name = dbObject.value(forKey: "name") as! String?
        content = dbObject.value(forKey: "content") as! String?
        course = dbObject.value(forKey: "course") as! String?
        courseId = dbObject.value(forKey: "courseId") as! Int
        
        DispatchQueue.main.async {
            self.classes = SectionSrv.SharedInstance.getStoredSectionsClasses(SectionId: self.id)
        }
    }
}

class SectionClassModel: Hashable {
    // Conformidad con Equatable
     static func == (lhs: SectionClassModel, rhs: SectionClassModel) -> Bool {
         return lhs.id == rhs.id
     }
     
     // Conformidad con Hashable
     func hash(into hasher: inout Hasher) {
         hasher.combine(id)  // Usualmente, el id es suficiente si es único
     }
    var id : Int
    var content : String?
    var order : Int
    var name : String?
    var courseSection : String?
    var courseSectionId : Int
    var classFiles : [ClassFileModel] = []
    
    init (withJsonObject json: JSON, sectionId : Int) {
        id = json["id"].int!
        order = json["order"].int ?? 0
        content = json["content"].string
        name = json["name"].string
        courseSection = json["courseSection"].string
        courseSectionId = sectionId
        
        if let fileList = json["files"].array {
            for file in fileList {
                let newClassFile = ClassFileModel(withJsonObject: file, classId: id)
                classFiles.append(newClassFile)
            }
        }
    }
    
    init(withDbObject dbObject: NSManagedObject) {
        id = dbObject.value(forKey: "id") as! Int
        order = dbObject.value(forKey: "order") as! Int
        name = dbObject.value(forKey: "name") as! String?
        content = dbObject.value(forKey: "content") as! String?
        courseSection = dbObject.value(forKey: "courseSection") as! String?
        courseSectionId = dbObject.value(forKey: "courseSectionId") as! Int
    }
}

class ClassFileModel {
    var id : Int
    var classId : Int
    var fileName : String?
    var fileDescription : String?
    var fileURL : String?
    
    init(withJsonObject json: JSON, classId: Int){
        id = json["id"].int!
        self.classId = classId
        fileName = json["name"].string
        fileDescription = json["description"].string
        fileURL = json["url"].string
    }
    
    init(withDbObject dbObject: NSManagedObject) {
        id = dbObject.value(forKey: "id") as! Int
        classId = dbObject.value(forKey: "classId") as! Int
        fileName = dbObject.value(forKey: "fileName") as! String?
        fileDescription = dbObject.value(forKey: "fileDescription") as! String?
        fileURL = dbObject.value(forKey: "fileUrl") as! String?
    }
}
