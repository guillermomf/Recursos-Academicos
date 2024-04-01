//
//  ScoreModel.swift
//  Recursos Academicos
//
//  Created by L85 on 7/7/19.
//  Copyright © 2019 Integra IT Soluciones. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreData

class ScoreModel {
    var id: Int
    var homework: Double
    var exam: Double
    var assistance: Double
    var activity: Double
    var score: Double?
    var points: Int
    var status: Int
    var registerDateString: String?
    var registerDate: Date?
    var comment: String?
    var studentGroupId: Int
    var studentGroup: String?
    var studentId: Int?
    var student: String?
    var userId: Int?
    var user: String?
    var schedulingPartialId: Int?
    var schedulingPartial: String?
    
    init(withJsonObject json: JSON, groupId: Int) {
        id = json["id"].int!
        homework = json["homework"].double!
        exam = json["exam"].double!
        assistance = json["assistance"].double!
        activity = json["activity"].double!
        score = json["score"].double
        points = json["points"].int!
        status = json["status"].int!
        registerDateString = json["registerDate"].string
        comment = json["comment"].string
        studentGroupId = groupId
        studentGroup = json["studentGroup"].string
        studentId = json["studentId"].int
        student = json["student"].string
        userId = json["userId"].int
        user = json["user"].string
        schedulingPartialId = json["schedulingPartialId"].int
        schedulingPartial = json["schedulingPartial"].string
        
        //Convertir el string de fecha en un objeto de tipo Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        if let registerDateString = registerDateString {
            registerDate = dateFormatter.date(from: registerDateString)
        }
        
    }
    
    init(withDbObject dbObject: NSManagedObject) {
        id = dbObject.value(forKey: "id") as! Int
        homework = dbObject.value(forKey: "homework") as! Double
        exam = dbObject.value(forKey: "exam") as! Double
        assistance = dbObject.value(forKey: "assistance") as! Double
        activity = dbObject.value(forKey: "activity") as! Double
        score = dbObject.value(forKey: "score") as! Double?
        points = dbObject.value(forKey: "points") as! Int
        status = dbObject.value(forKey: "status") as! Int
        registerDate = dbObject.value(forKey: "registerDate") as! Date?
        comment = dbObject.value(forKey: "comment") as! String?
        studentGroupId = dbObject.value(forKey: "studentGroupId") as! Int
        studentGroup = dbObject.value(forKey: "studentGroup") as! String?
        studentId = dbObject.value(forKey: "studentId") as! Int?
        student = dbObject.value(forKey: "student") as! String?
        userId = dbObject.value(forKey: "userId") as! Int?
        user = dbObject.value(forKey: "user") as! String?
        schedulingPartialId = dbObject.value(forKey: "schedulingPartialId") as! Int?
        schedulingPartial = dbObject.value(forKey: "schedulingPartial") as! String?
    }
}
