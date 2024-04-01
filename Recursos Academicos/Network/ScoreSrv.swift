//
//  ScoreSrv.swift
//  Recursos Academicos
//
//  Created by L85 on 7/7/19.
//  Copyright © 2019 Integra IT Soluciones. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreData

class ScoreSrv {
    static let SharedInstance : ScoreSrv = ScoreSrv()
//    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    /// Obtener el listado de calificaciones del estudiante
    ///
    /// - Parameter GroupId: Id perteneciente al grupo
    /// - Parameter ListResult: Resultado del llamado, tupla de Booleano y arreglo de tareas
    func getStudentScores(GroupId: Int, ListResult: @escaping(Bool, [ScoreModel]) -> Void) {
        
        let url = Settings.userScoreURL(groupId: GroupId)
        let accessToken = UserDefaults.standard.string(forKey: Settings.userTokenKey)
        var request = URLRequest(url: url)
        var scoreList: [ScoreModel] = []
        
        request.httpMethod = "GET"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(accessToken!)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if error != nil  {
                DispatchQueue.main.async {
                    self.getStoredScores(groupId: GroupId, Result: { (list) in
                        ListResult(false, list)
                    })
                }
            }
            
            if data == nil  {
                DispatchQueue.main.async {
                    self.getStoredScores(groupId: GroupId, Result: { (list) in
                        ListResult(false, list)
                    })
                }
            }
            
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                
                switch statusCode {
                case 200...299:
                    //Convertir resultado esperado a formato JSON
                    let jsonData = JSON(data).dictionary
                    print(jsonData)
                    let scoreData = jsonData?["data"]?.array
                    if let scoreData = scoreData {
                        DispatchQueue.main.async {
                            for score in scoreData {
                                let newScore = ScoreModel(withJsonObject: score, groupId: GroupId)
                                scoreList.append(newScore)
                            }
                            
                            let stored = self.storeUserScores(Scores: scoreList)
                            ListResult(stored, scoreList)
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.getStoredScores(groupId: GroupId, Result: { (list) in
                                ListResult(false, scoreList)
                            })
                        }
                    }
                default:
                    ListResult(false, scoreList)
                }
            }
        }
        
        task.resume()
    }
    
    /// Metodo que almacena un arreglo de calificaciones de usuario
    ///
    /// - Parameter Tasks: Arreglo de archivos de tareas a almacenar
    /// - Returns: Retorna un booleano indicando si se almaceno correctamente
    func storeUserScores(Scores: [ScoreModel]) -> Bool {
        
        var result : Bool = true
        
        for score in Scores {
            
            let context = DataController.shared.container.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "Scores", in: context)
            let newScoreRegistry = NSManagedObject(entity: entity!, insertInto: context)
            
            newScoreRegistry.setValue(score.id , forKey: "id")
            newScoreRegistry.setValue(score.homework , forKey: "homework")
            newScoreRegistry.setValue(score.exam , forKey: "exam")
            newScoreRegistry.setValue(score.assistance , forKey: "assistance")
            newScoreRegistry.setValue(score.activity , forKey: "activity")
            newScoreRegistry.setValue(score.score , forKey: "score")
            newScoreRegistry.setValue(score.points , forKey: "points")
            newScoreRegistry.setValue(score.status , forKey: "status")
            newScoreRegistry.setValue(score.registerDate , forKey: "registerDate")
            newScoreRegistry.setValue(score.comment , forKey: "comment")
            newScoreRegistry.setValue(score.studentGroupId , forKey: "studentGroupId")
            newScoreRegistry.setValue(score.studentGroup , forKey: "studentGroup")
            newScoreRegistry.setValue(score.studentId , forKey: "studentId")
            newScoreRegistry.setValue(score.student , forKey: "student")
            newScoreRegistry.setValue(score.userId , forKey: "userId")
            newScoreRegistry.setValue(score.user , forKey: "user")
            newScoreRegistry.setValue(score.schedulingPartialId , forKey: "schedulingPartialId")
            newScoreRegistry.setValue(score.schedulingPartial , forKey: "schedulingPartial")
            
            do {
                try context.save()
            } catch {
                result = false
            }
        }
        
        return result
    }
    
    /// Metódo que retorna las calificaciones de un alumno
    ///
    /// - Parameter success: Tupla que retorna el resultado de la consulta y el listado de calificaciones recuperadas de la BD local
    func getStoredScores(groupId: Int, Result: @escaping([ScoreModel]) -> Void ) {
        let context = DataController.shared.container.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Scores")
        request.predicate = NSPredicate(format: "studentGroupId = %@", groupId.description)
        var scoreList : [ScoreModel] = []
        
        do {
            let result = try context.fetch(request)
            
            for data in result as! [NSManagedObject] {
                
                let newScore = ScoreModel(withDbObject: data)
                scoreList.append(newScore)
            }
            
            return Result(scoreList)
            
        } catch {
            
            return Result(scoreList)
        }
    }
    
    /// Metódo que vacia las califaciones de un alumno almacenadas en la BD del dispositivo
    func deleteStoredScores() {
        let context = DataController.shared.container.viewContext
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Scores")
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        
        do {
            try context.execute(request)
            try context.save()
        } catch {
            print("Error al eliminar las calificaciones de la BD", error)
        }
        
    }
}
