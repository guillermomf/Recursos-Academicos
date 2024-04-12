//
//  CourseSrv.swift
//  Recursos Academicos
//
//  Created by Daniel Cab Hernández on 25/02/19.
//  Copyright © 2019 Integra IT Soluciones. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreData
import UIKit

class CourseSrv {
    static let SharedInstance = CourseSrv()
//    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var persistentCourseList : [CoursesModel]?
    
    /// Obtener el listado de cursos del estudiante
    ///
    /// - Parameter Nodes: Resultado del servicio
    func getCourses(Courses: @escaping(Bool, [CoursesModel]) -> Void) {
        let url = Settings.coursesURL
        let accessToken = UserDefaults.standard.string(forKey: Settings.userTokenKey)
        var coursesArray : [CoursesModel] = []
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(accessToken!)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard error == nil else {
                DispatchQueue.main.async {
                    CourseSrv.SharedInstance.getStoredCourses(success: { (result, coursesList) in
                        
                        if result {
                            self.persistentCourseList = coursesList!
                            coursesArray = coursesList!
                        }
                    })
                }
                Courses(true, coursesArray)
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    CourseSrv.SharedInstance.getStoredCourses(success: { (result, coursesList) in
                        if result {
                            self.persistentCourseList = coursesList!
                            coursesArray = coursesList!
                        }
                    })
                }
                Courses(false, coursesArray)
                return
            }
            print(response as? HTTPURLResponse)
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                switch statusCode {
                case 200...299:
                    
                    //Borrar datos previamente almacenados
                    DispatchQueue.main.async {
                        SectionSrv.SharedInstance.deleteStoredSections()
                        SectionSrv.SharedInstance.deleteSectionClasses()
                    }
                    
                    //Convertir resultado esperado a formato JSON
                    let jsonData = JSON(data).dictionary
                    
                    let courseData = jsonData?["data"]?.array
                    
                    if courseData != nil {
                        
                        for courseItem in courseData! {
                            DispatchQueue.main.async {
                                let newCourse = CoursesModel(jsonObject: courseItem)
                                
                                //Almacenas las secciones del curso
                                _ = SectionSrv.SharedInstance.storeSections(Sections: newCourse.courseSections!)
                                
                                //Almacenar las clases por cada sección
                                for section in newCourse.courseSections! {
                                    _ = SectionSrv.SharedInstance.storeSectionClasses(SectionClasses: section.classes)
                                    for sectionClass in section.classes {
                                        SectionSrv.SharedInstance.deleteStoredClassFiles(taskId: sectionClass.id)
                                        _ = SectionSrv.SharedInstance.storeClassFiles(ClassFiles: sectionClass.classFiles)
                                    }
                                }
                                
                                coursesArray.append(newCourse)
                            }
                        }
                        
                        DispatchQueue.main.async {
                            self.persistentCourseList = coursesArray
                            let storedCourses = self.storeCourses(Courses: coursesArray)
                            Courses(storedCourses, coursesArray)
                        }
                        
                    } else {
                        self.persistentCourseList = []
                        Courses(true, coursesArray)
                    }
                default:
                    Courses(false, coursesArray)
                }
            }
        }
        
        task.resume()
    }
    
    /// Metodo que almacena un arreglo de cursos localmente en el dispositivo
    ///
    /// - Parameter nodes: Arreglo de cursos a almacenar
    /// - Returns: Retorna un booleano indicando si se almaceno correctamente
    func storeCourses(Courses: [CoursesModel]) -> Bool {
        deleteStoredCourses()
        var result : Bool = true
        for Course in Courses {
            
            let context = DataController.shared.container.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "Courses", in: context)
            let newCourseRegistry = NSManagedObject(entity: entity!, insertInto: context)
            
            newCourseRegistry.setValue(Course.id , forKey: "id")
            newCourseRegistry.setValue(Course.name, forKey: "name")
            newCourseRegistry.setValue(Course.description, forKey: "courseDescription")
            newCourseRegistry.setValue(Course.goal, forKey: "goal")
            newCourseRegistry.setValue(Course.startDate,forKey: "startDate")
            newCourseRegistry.setValue(Course.endDate, forKey: "endDate")
            newCourseRegistry.setValue(Course.active, forKey: "active")
            newCourseRegistry.setValue(Course.subject ,forKey: "subject")
            newCourseRegistry.setValue(Course.nodeId, forKey: "nodeId")
            newCourseRegistry.setValue(Course.node, forKey: "node")
            newCourseRegistry.setValue(Course.userId, forKey: "userId")
            newCourseRegistry.setValue(Course.user, forKey: "user")
            newCourseRegistry.setValue(Course.registerDate, forKey: "registerDate")
            newCourseRegistry.setValue(Course.updateDate, forKey: "updateDate")
            newCourseRegistry.setValue(Course.monday, forKey: "monday")
            newCourseRegistry.setValue(Course.tuesday, forKey: "tuesday")
            newCourseRegistry.setValue(Course.wednesday, forKey: "wednesday")
            newCourseRegistry.setValue(Course.thursday, forKey: "thursday")
            newCourseRegistry.setValue(Course.friday, forKey: "friday")
            newCourseRegistry.setValue(Course.saturday, forKey: "saturday")
            newCourseRegistry.setValue(Course.sunday, forKey: "sunday")
            newCourseRegistry.setValue(Course.professorName, forKey: "professorName")
            newCourseRegistry.setValue(Course.groupId, forKey: "groupId")
            
            do {
                try context.save()
            } catch {
                result = false
            }
        }
        
        return result
    }
    
    /// Metódo que vacia los cursos almacenados en la BD del dispositivo
    func deleteStoredCourses() {
        let context = DataController.shared.container.viewContext
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Courses")
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        
        do {
            try context.execute(request)
            try context.save()
        } catch {
            print ("Error al eliminar los nodos de la BD", error)
        }
        
    }
    
    /// Metódo que retorna los cursos almacenados localmente en el dispositivo
    ///
    /// - Parameter success: Tupla que retorna el resultado de la consulta y el listado de cursos recuperados de la BD local
    func getStoredCourses(success: @escaping(Bool, [CoursesModel]?) -> Void) {
        let context = DataController.shared.container.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Courses")
        var courseList : [CoursesModel] = []
        
        do {
            let result = try context.fetch(request)
            
            for data in result as! [NSManagedObject] {
                
                let newCourseModel = CoursesModel(dbObject: data)
                courseList.append(newCourseModel)
            }
            return success(true, courseList)
            
        } catch {
            return success(false, courseList)
        }
    }
    
    /// Metodo que almacena un arreglo de horarios de examen localmente en el dispositivo
    ///
    /// - Parameter nodes: Arreglo de horarios de examen a almacenar
    /// - Returns: Retorna un booleano indicando si se almaceno correctamente
    func storeCourseExamSchedules(Schedules: [CourseExamSchedule]) -> Bool {
        var result : Bool = true
        
        for Schedule in Schedules {
            
            let context = DataController.shared.container.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "ExamSchedules", in: context)
            let newCourseRegistry = NSManagedObject(entity: entity!, insertInto: context)
            
            newCourseRegistry.setValue(Schedule.id , forKey: "id")
            newCourseRegistry.setValue(Schedule.courseId, forKey: "courseId")
            newCourseRegistry.setValue(Schedule.description, forKey: "scheduleDescription")
            newCourseRegistry.setValue(Schedule.applicationDate, forKey: "applicationDate")
            newCourseRegistry.setValue(Schedule.studentGroupId, forKey: "studentGroupId")
            newCourseRegistry.setValue(Schedule.userId, forKey: "userId")
            newCourseRegistry.setValue(Schedule.examScheduleTypeId, forKey: "examScheduleTypeId")
            newCourseRegistry.setValue(Schedule.registerDate, forKey: "registerDate")
            newCourseRegistry.setValue(Schedule.updateDate, forKey: "updateDate")
            newCourseRegistry.setValue(Schedule.active, forKey: "active")
            newCourseRegistry.setValue(Schedule.teacherExamId, forKey: "teacherExamId")
            newCourseRegistry.setValue(Schedule.scheduleTypeId,forKey: "scheduleTypeId")
            newCourseRegistry.setValue(Schedule.scheduleDescription, forKey: "scheduleExamDescription")
            newCourseRegistry.setValue(Schedule.scheduleActive, forKey: "scheduleActive")
            newCourseRegistry.setValue(Schedule.scheduleRegDate, forKey: "scheduleRegDate")
            newCourseRegistry.setValue(Schedule.scheduleUpdDate, forKey: "scheduleUpdDate")
            
            do {
                try context.save()
            } catch {
                result = false
            }
        }
        
        return result
    }
    
    /// Metódo que retorna los horarios de examen almacenados localmente en el dispositivo
    ///
    /// - Parameter success: Tupla que retorna el resultado de la consulta y el listado de horarios de examen recuperados de la BD local
    func getStoredExamSchedules(courseId: Int, success: @escaping(Bool, [CourseExamSchedule]?) -> Void) {
        let context = DataController.shared.container.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ExamSchedules")
        request.predicate = NSPredicate(format: "courseId = %@", courseId.description)
        var scheduleList : [CourseExamSchedule] = []
        
        do {
            let result = try context.fetch(request)
            
            for data in result as! [NSManagedObject] {
                
                let newSchedule = CourseExamSchedule(dbObject: data)
                scheduleList.append(newSchedule)
            }
            return success(true, scheduleList)
            
        } catch {
            return success(false, scheduleList)
        }
    }
    
    /// Metódo que vacia los horarios de examen almacenados en la BD del dispositivo
    func deleteStoredSchedules() {
        let context = DataController.shared.container.viewContext
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "ExamSchedules")
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        
        do {
            try context.execute(request)
            try context.save()
        } catch {
            print ("Error al eliminar los nodos de la BD", error)
        }
        
    }
    
    /// Obtener la planeación del parcial
    ///
    /// - Parameter Nodes: Resultado del servicio
    func getCoursePlanning(groupId: Int, Result: @escaping(Bool, CoursePlanning?) -> Void) {
        let url = Settings.coursePlanningURL(groupId: groupId)
        let accessToken = UserDefaults.standard.string(forKey: Settings.userTokenKey)
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(accessToken!)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard error == nil else {
                Result(false, nil)
                return
            }
            
            guard let data = data else {
                Result(false, nil)
                return
            }
            
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                switch statusCode {
                case 200...299:
                    //Convertir resultado esperado a formato JSON
                    let jsonData = JSON(data).dictionary
                    let planningData = jsonData!["data"]?.array
                    
                    if let data = planningData?.first {
                        let newPlanning = CoursePlanning(jsonObject: data)
                        
                        Result(true, newPlanning)
                    } else {
                        Result(false, nil)
                    }
                default:
                    Result(false, nil)
                }
            }
        }
        
        task.resume()
    }
    
    /// Metodo que almacena la planeación de un curso
    ///
    /// - Parameter Planning: Modelo que contiene la planeación del curso
    /// - Returns: Retorna un booleano indicando si se almaceno correctamente
    func storeCoursePlanning(Planning: CoursePlanning) -> Bool {
        var result : Bool = true
        
        let context = DataController.shared.container.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Planning", in: context)
        let newCoursePlanning = NSManagedObject(entity: entity!, insertInto: context)
        
        newCoursePlanning.setValue(Planning.id, forKey: "id")
        newCoursePlanning.setValue(Planning.studentGroupId, forKey: "studentGroupId")
        newCoursePlanning.setValue(Planning.assistance, forKey: "assistance")
        newCoursePlanning.setValue(Planning.homework, forKey: "homework")
        newCoursePlanning.setValue(Planning.activity, forKey: "activity")
        newCoursePlanning.setValue(Planning.exam, forKey: "exam")
        newCoursePlanning.setValue(Planning.partialQuantity, forKey: "partialQuantity")
        
        do {
            try context.save()
        } catch {
            result = false
        }
        
        return result
    }
    
    /// Metódo que vacia la planeación de un curso especificado
    func deleteStoredPlanning(groupId: Int) {
        let context = DataController.shared.container.viewContext
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Planning")
        fetch.predicate = NSPredicate(format: "studentGroupId = %@", "\(groupId)")
        
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        
        do {
            try context.execute(request)
            try context.save()
        } catch {
            print ("Error al eliminar los nodos de la BD", error)
        }
        
    }
    
    /// Metódo que retorna los horarios de examen almacenados localmente en el dispositivo
    ///
    /// - Parameter success: Tupla que retorna el resultado de la consulta y el listado de horarios de examen recuperados de la BD local
    func getStoredPlanning(groupId: Int, success: @escaping(Bool, CoursePlanning?) -> Void) {
        let context = DataController.shared.container.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Planning")
        request.predicate = NSPredicate(format: "studentGroupId = %@", "\(groupId)")
        
        do {
            let result = try context.fetch(request)
            
            if let data = result.first {
                let newPlanning = CoursePlanning(dbObject: data as! NSManagedObject)
                
                return success(true, newPlanning)
            } else {
                return success(false, nil)
            }
        } catch {
            return success(false, nil)
        }
    }
    
    /// Obtener los periodos por parcial y numero de parciales
    ///
    /// - Parameter Nodes: Resultado del servicio
    func getCoursePartials(groupId: Int, Result: @escaping(Bool, [CoursePartial]) -> Void) {
        let url = Settings.coursePartialsURL(groupId: groupId)
        let accessToken = UserDefaults.standard.string(forKey: Settings.userTokenKey)
        var partialList : [CoursePartial] = []
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(accessToken!)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard error == nil else {
                Result(false, partialList)
                return
            }
            
            guard let data = data else {
                Result(false, partialList)
                return
            }
            
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                
                switch statusCode {
                case 200...299:
                    //Convertir resultado esperado a formato JSON
                    let jsonData = JSON(data).dictionary
                    let partialsData = jsonData!["data"]?.array
                    
                    if let data = partialsData {
                        for partial in data {
                            let newPartial = CoursePartial(jsonObject: partial)
                            partialList.append(newPartial)
                        }
                        
                        Result(true, partialList)
                    } else {
                        Result(false, partialList)
                    }
                default:
                    Result(false, partialList)
                }
            }
        }
        
        task.resume()
    }
    
    /// Metodo que almacena los parciales de un curso
    ///
    /// - Parameter groupId: Id del grupo al que pertenece el listado
    /// - Parameter Partials: Arreglo de modelo de parciales a almacenar
    /// - Returns: Retorna un booleano indicando si se almaceno correctamente
    func storeCoursePartials(groupId: Int, Partials: [CoursePartial]) -> Bool {
        var result : Bool = true
        
        for partial in Partials {
            let context = DataController.shared.container.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "Partials", in: context)
            let newCoursePartial = NSManagedObject(entity: entity!, insertInto: context)
            
            newCoursePartial.setValue(partial.id, forKey: "id")
            newCoursePartial.setValue(partial.coursePlanningId, forKey: "coursePlanningId")
            newCoursePartial.setValue(partial.startDate, forKey: "startDate")
            newCoursePartial.setValue(partial.endDate, forKey: "endDate")
            newCoursePartial.setValue(partial.startDateString, forKey: "startDateString")
            newCoursePartial.setValue(partial.endDateString, forKey: "endDateString")
            newCoursePartial.setValue(groupId, forKey: "studentGroupId")
            newCoursePartial.setValue(partial.description, forKey: "partialDescription")
            
            
            do {
                try context.save()
            } catch {
                result = false
            }
        }
        
        return result
    }
    
    /// Metódo que vacia los parciales de un curso especificado
    func deleteStoredPartials(groupId: Int) {
        let context = DataController.shared.container.viewContext
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Partials")
        fetch.predicate = NSPredicate(format: "studentGroupId = %@", "\(groupId)")
        
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        
        do {
            try context.execute(request)
            try context.save()
        } catch {
            print ("Error al eliminar los nodos de la BD", error)
        }
        
    }
    
    /// Metódo que retorna los parciales almacenados para un curso
    ///
    /// - Parameter success: Tupla que retorna el resultado de la consulta y el listado de parciales recuperados de la BD Local
    func getStoredPartials(groupId: Int, success: @escaping(Bool, [CoursePartial]) -> Void) {
        let context = DataController.shared.container.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Partials")
        request.predicate = NSPredicate(format: "studentGroupId = %@", "\(groupId)")
        var partialList : [CoursePartial] = []
        
        do {
            let result = try context.fetch(request)
            
            for partial in result as! [NSManagedObject] {
                let newPartial = CoursePartial(dbObject: partial)
                partialList.append(newPartial)
            }
            
            return success(true, partialList)
        } catch {
            return success(false, partialList)
        }
    }
}
