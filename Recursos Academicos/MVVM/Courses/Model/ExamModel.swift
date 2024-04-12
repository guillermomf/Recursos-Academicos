//
//  ExamModel.swift
//  Recursos Academicos
//
//  Created by Daniel Cab Hernández on 25/02/19.
//  Copyright © 2019 Integra IT Soluciones. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreData

//Tipos de preguntas
enum QuestionType : Int {
    case multipleQuestion    = 1
    case openQuestion        = 2
    case relationalQuestion  = 3
    case trueOrFalseQuestion = 4
    case imageMultiple       = 5
}

class CourseExamSchedule {
    var id : Int
    var courseId : Int
    var description : String
    var applicationDate : String
    var formattedAppDate : Date?
    var studentGroupId : Int
    var userId : Int
    var examScheduleTypeId : Int
    var registerDate : String
    var updateDate : String?
    var active : Bool
    var teacherExamId : Int?
    var scheduleTypeId: Int
    var scheduleDescription : String
    var scheduleActive : Bool
    var scheduleRegDate : String
    var scheduleUpdDate : String?
    var hasScore : Bool
    var isAnswered : Bool
    var examScore : String?
    var examCorrectAnswers : Int?
    var examScoreComments : String?
    var examTypeId : Int
    var endApplicationTimeString: String?
    var beginApplicationTimeString: String?
    var beginApplicationDateString: String?
    var endApplicationDateString: String?
    var endApplicationTime: Date?
    var beginApplicationTime: Date?
    var beginApplicationDate: Date?
    var endApplicationDate: Date?
    var minutesExam: Int?
    var schedulingPartialId: Int?
    
    /// Inicializar el modelo utilizando un objeto de tipo JSON
    ///
    /// - Parameter jsonObject: JSON que contiene el modelo
    init(withJsonObject json: JSON, courseId: Int) {
        
        id = json["id"].int!
        self.courseId = courseId
        description = json["description"].string!
        applicationDate = json["applicationDate"].string!
        studentGroupId = json["studentGroupId"].int!
        userId = json["userId"].int!
        examScheduleTypeId = json["examScheduleTypeId"].int!
        registerDate = json["registerDate"].string!
        updateDate = json["updateDate"].string
        active = json["active"].bool!
        teacherExamId = json["teacherExamId"].int
        scheduleTypeId = json["examScheduleType"]["id"].int!
        scheduleDescription = json["examScheduleType"]["description"].string!
        scheduleActive = json["examScheduleType"]["active"].bool!
        scheduleRegDate = json["examScheduleType"]["registerDate"].string!
        scheduleUpdDate = json["examScheduleType"]["updateDate"].string
        hasScore = json["hasScore"].bool!
        isAnswered =  json["isAnswered"].bool!
        examScore = json["score"]["score"].string
        examCorrectAnswers = json["score"]["correctAnswers"].int
        examScoreComments = json["score"]["comments"].string
        examTypeId = json["teacherExam"]["teacherExamTypeId"].int!
        beginApplicationTimeString = json["beginApplicationTime"].string
        beginApplicationDateString = json["beginApplicationDate"].string
        endApplicationDateString = json["endApplicationDate"].string
        endApplicationTimeString = json["endApplicationTime"].string
        minutesExam = json["minutesExam"].int
        schedulingPartialId = json["schedulingPartialId"].int
        //Convertir el string de fecha en un objeto de tipo Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formattedAppDate = dateFormatter.date(from: applicationDate)
        
        //Convertir el string de fecha en un objeto de tipo Date
        let dateFormatterTimer = DateFormatter()
        
        if let beginApplicationDateString = beginApplicationDateString {
            dateFormatterTimer.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            if let beginDate = dateFormatterTimer.date(from: beginApplicationDateString) {
                beginApplicationDate = beginDate
            } else {
                dateFormatterTimer.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSS"
                beginApplicationDate = dateFormatterTimer.date(from: beginApplicationDateString)
            }
        }
        
        if let endApplicationDateString = endApplicationDateString {
            dateFormatterTimer.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            if let endDate = dateFormatterTimer.date(from: endApplicationDateString) {
                endApplicationDate = endDate
            } else {
                dateFormatterTimer.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSS"
                endApplicationDate = dateFormatterTimer.date(from: endApplicationDateString)
            }
        }
        
        if let endApplicationTimeString = endApplicationTimeString {
            dateFormatterTimer.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            if let endTime = dateFormatterTimer.date(from: endApplicationTimeString) {
                endApplicationTime = endTime
            } else {
                dateFormatterTimer.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSS"
                endApplicationTime = dateFormatterTimer.date(from: endApplicationTimeString)
            }
        }
        
        if let beginApplicationTimeString = beginApplicationTimeString {
            dateFormatterTimer.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            if let beginTime = dateFormatterTimer.date(from: beginApplicationTimeString) {
                beginApplicationTime = beginTime
            } else {
                dateFormatterTimer.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSS"
                beginApplicationTime = dateFormatterTimer.date(from: beginApplicationTimeString)
            }
        }
    }
    
    /// Inicializar el modelo utilizando un objeto de BD
    ///
    /// - Parameter dbObject: Objeto de BD que contiene el modelo de contenido
    init(dbObject : NSManagedObject) {
        self.id = dbObject.value(forKey: "id") as! Int
        self.courseId = dbObject.value(forKey: "courseId") as! Int
        self.description = dbObject.value(forKey: "scheduleDescription") as! String
        self.applicationDate = dbObject.value(forKey: "applicationDate") as! String
        self.studentGroupId = dbObject.value(forKey: "studentGroupId") as! Int
        self.userId = dbObject.value(forKey: "userId") as! Int
        self.examScheduleTypeId = dbObject.value(forKey: "examScheduleTypeId") as! Int
        self.registerDate = dbObject.value(forKey: "registerDate") as! String
        self.updateDate = dbObject.value(forKey: "updateDate") as! String?
        self.active = dbObject.value(forKey: "active") as! Bool
        self.teacherExamId = dbObject.value(forKey: "teacherExamId") as! Int?
        self.scheduleTypeId = dbObject.value(forKey: "scheduleTypeId") as! Int
        self.scheduleDescription = dbObject.value(forKey: "scheduleExamDescription") as! String
        self.scheduleActive = dbObject.value(forKey: "scheduleActive") as! Bool
        self.scheduleRegDate = dbObject.value(forKey: "scheduleRegDate") as! String
        self.scheduleUpdDate = dbObject.value(forKey: "scheduleUpdDate") as! String?
        self.hasScore = dbObject.value(forKey: "hasScore") as! Bool
        self.isAnswered = dbObject.value(forKey: "isAnswered") as! Bool
        self.examScore = dbObject.value(forKey: "examScore") as! String?
        self.examCorrectAnswers = dbObject.value(forKey: "examCorrectAnswers") as! Int?
        self.examScoreComments = dbObject.value(forKey: "examScoreComments") as! String?
        self.examTypeId = dbObject.value(forKey: "examTypeId") as! Int
        
        //Convertir el string de fecha de aplicación en un objeto de tipo Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd'T'HH:mm:ss"
        self.formattedAppDate = dateFormatter.date(from: self.applicationDate)
    }
}

class ExamQuestion: Equatable {
    var id : Int
    var content : String
    var explanation : String?
    var urlImage : String?
    var type : QuestionType
    var active : Bool
    var answers : [ExamAnswers]
    
    //Permite obtener el indice en caso de utilizarse en arreglos
    static func == (lhs: ExamQuestion, rhs: ExamQuestion) -> Bool {
        return lhs.id == rhs.id
    }
    
    //Inicia el objeto utilizando un JSON
    init(withJsonObject json: JSON) {
        id = json["questionId"].int!
        content = json["question"]["content"].string!
        explanation = json["question"]["explanation"].string
        urlImage = json["question"]["urlImage"].string
        type = QuestionType(rawValue: json["question"]["questionTypeId"].int!)!
        active = json["question"]["active"].bool!
        answers = []
        
        let answersJson = json["question"]["answers"].array
        
        for answer in answersJson! {
            let newAnswer = ExamAnswers(withJsonObject: answer, questionId: id)
            answers.append(newAnswer)
        }
    }
}

class ExamAnswers: Equatable {
    
    var id : Int
    var imageBase64 : String?
    var isCorrect : Bool
    var relationDescription : String?
    var questionId : Int
    var question : String?
    var order : Int
    var description : String
    var active : Bool
    
    static func == (lhs: ExamAnswers, rhs: ExamAnswers) -> Bool {
        return lhs.id == rhs.id
    }
    
    //Inicializa un objeto de tipo respuesta para pregunta de examen
    init(withJsonObject json: JSON, questionId: Int) {
        id  = json["id"].int!
        imageBase64 = json["imageBase64"].string
        isCorrect = json["isCorrect"].bool!
        relationDescription = json["relationDescription"].string
        self.questionId = questionId
        question = json["question"].string
        order = json["order"].int!
        description = json["description"].string!
        active = json["active"].bool!
    }
}

class UserAnswer: Equatable {
    
    var answerId : Int
    var questionIndex : Int
    var answerExplanation : String
    
    static func == (lhs: UserAnswer, rhs: UserAnswer) -> Bool {
        return lhs.answerId == rhs.answerId
    }
    
    init(id : Int, index: Int, explanation: String?) {
        answerId = id
        questionIndex = index
        answerExplanation = explanation ?? ""
    }
}
