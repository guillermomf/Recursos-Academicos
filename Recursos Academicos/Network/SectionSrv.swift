//
//  SectionSrv.swift
//  Recursos Academicos
//
//  Created by Daniel Cab Hernández on 25/02/19.
//  Copyright © 2019 Integra IT Soluciones. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreData
import UIKit

class SectionSrv {
    static let SharedInstance = SectionSrv()
//    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    /// Metodo que almacena un arreglo de secciones del curso definido
    ///
    /// - Parameter Sections: Arreglo de secciones a almacenar
    /// - Returns: Retorna un booleano indicando si se almaceno correctamente
    func storeSections(Sections: [SectionModel]) -> Bool {
        
        var result : Bool = true
        
        for section in Sections {
            
            let context = DataController.shared.container.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "Sections", in: context)
            let newSectionRegistry = NSManagedObject(entity: entity!, insertInto: context)
            
            newSectionRegistry.setValue(section.id , forKey: "id")
            newSectionRegistry.setValue(section.name, forKey: "name")
            newSectionRegistry.setValue(section.order, forKey: "order")
            newSectionRegistry.setValue(section.content, forKey: "content")
            newSectionRegistry.setValue(section.course,forKey: "course")
            newSectionRegistry.setValue(section.courseId, forKey: "courseId")
            
            do {
                try context.save()
            } catch {
                result = false
            }
        }
        
        return result
    }
    
    /// Metódo que vacia las secciones de cursos almacenados en la BD del dispositivo
    func deleteStoredSections() {
        let context = DataController.shared.container.viewContext
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Sections")
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        
        do {
            try context.execute(request)
            try context.save()
        } catch {
            print ("Error al eliminar las secciones de curso de la BD", error)
        }
        
    }
    
    /// Metódo que retorna las clases de secciones almacenados localmente en el dispositivo
    ///
    /// - Parameter success: Tupla que retorna el resultado de la consulta y el listado de cursos recuperados de la BD local
    func getStoredSections(CourseId: Int, Result: @escaping([SectionModel]) -> Void ) {
        let context = DataController.shared.container.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Sections")
        request.predicate = NSPredicate(format: "courseId = %@", CourseId.description)
        
        var sectionList : [SectionModel] = []
        
        do {
            let result = try context.fetch(request)
            
            for data in result as! [NSManagedObject] {
                
                let newSection = SectionModel(withDbObject: data)
                sectionList.append(newSection)
            }
            
            return Result(sectionList)
            
        } catch {
            
            return Result(sectionList)
        }
    }
    
    /// Metodo que almacena un arreglo de clases por sección del curso
    ///
    /// - Parameter Classes: Arreglo de clases a almacenar
    /// - Returns: Retorna un booleano indicando si se almaceno correctamente
    func storeSectionClasses(SectionClasses: [SectionClassModel]) -> Bool {
        
        var result : Bool = true
        
        for sectionClass in SectionClasses {
            
            let context = DataController.shared.container.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "SectionClasses", in: context)
            let newSectionClassRegistry = NSManagedObject(entity: entity!, insertInto: context)
            
            newSectionClassRegistry.setValue(sectionClass.id , forKey: "id")
            newSectionClassRegistry.setValue(sectionClass.name, forKey: "name")
            newSectionClassRegistry.setValue(sectionClass.order, forKey: "order")
            newSectionClassRegistry.setValue(sectionClass.content, forKey: "content")
            newSectionClassRegistry.setValue(sectionClass.courseSection,forKey: "courseSection")
            newSectionClassRegistry.setValue(sectionClass.courseSectionId, forKey: "courseSectionId")
            
            do {
                try context.save()
            } catch {
                result = false
            }
        }
        
        return result
    }
    
    /// Metódo que vacia las clases por sección de cursos almacenados en la BD del dispositivo
    func deleteSectionClasses() {
        let context = DataController.shared.container.viewContext
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "SectionClasses")
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        
        do {
            try context.execute(request)
            try context.save()
        } catch {
            print ("Error al eliminar las clases de sección de curso de la BD", error)
        }
        
    }
    
    /// Metódo que retorna las clases de secciones almacenados localmente en el dispositivo
    ///
    /// - Parameter success: Tupla que retorna el resultado de la consulta y el listado de cursos recuperados de la BD local
    func getStoredSectionsClasses(SectionId: Int) -> [SectionClassModel] {
        let context = DataController.shared.container.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "SectionClasses")
        request.predicate = NSPredicate(format: "courseSectionId = %@", SectionId.description)
        
        var sectionClassList : [SectionClassModel] = []
        
        do {
            let result = try context.fetch(request)
            
            for data in result as! [NSManagedObject] {
                
                let newSectionClass = SectionClassModel(withDbObject: data)
                sectionClassList.append(newSectionClass)
            }
            return sectionClassList
            
        } catch {
            return sectionClassList
        }
    }
    
    /// Metodo que almacena un arreglo de archivos de tareas del curso definido
    ///
    /// - Parameter ClassFiles: Arreglo de archivos de clases a almacenar
    /// - Returns: Retorna un booleano indicando si se almaceno correctamente
    func storeClassFiles(ClassFiles: [ClassFileModel]) -> Bool {
        
        var result : Bool = true
        
        for classFile in ClassFiles {
            
            let context = DataController.shared.container.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "ClassFiles", in: context)
            let newTaskRegistry = NSManagedObject(entity: entity!, insertInto: context)
            
            newTaskRegistry.setValue(classFile.id , forKey: "id")
            newTaskRegistry.setValue(classFile.classId, forKey: "classId")
            newTaskRegistry.setValue(classFile.fileName, forKey: "fileName")
            newTaskRegistry.setValue(classFile.fileURL, forKey: "fileUrl")
            newTaskRegistry.setValue(classFile.fileDescription,forKey: "fileDescription")
            
            do {
                try context.save()
            } catch {
                result = false
            }
        }
        
        return result
    }
    
    /// Metódo que vacia las tareas de cursos almacenados en la BD del dispositivo
    func deleteStoredClassFiles(taskId: Int) {
        let context = DataController.shared.container.viewContext
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "ClassFiles")
        fetch.predicate = NSPredicate(format: "classId = %@", taskId.description)
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        
        
        do {
            try context.execute(request)
            try context.save()
        } catch {
            print ("Error al eliminar los archivos de clases del curso de la BD", error)
        }
        
    }
    
    /// Metódo que retorna los archivos de clases almacenados localmente en el dispositivo
    ///
    /// - Parameter success: Tupla que retorna el resultado de la consulta y el listado de archivos de clases recuperados de la BD local
    func getStoredClassFiles(classId: Int, Result: @escaping([ClassFileModel]) -> Void ) {
        let context = DataController.shared.container.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ClassFiles")
        request.predicate = NSPredicate(format: "classId = %@", classId.description)
        
        var classFileList : [ClassFileModel] = []
        
        do {
            let result = try context.fetch(request)
            
            for data in result as! [NSManagedObject] {
                
                let newClassFile = ClassFileModel(withDbObject: data)
                classFileList.append(newClassFile)
            }
            
            return Result(classFileList)
            
        } catch {
            
            return Result(classFileList)
        }
    }
}
