//
//  Settings.swift
//  Recursos Academicos
//
//  Created by Gil casimiro on 07/03/24.
//

import Foundation
//import VimeoNetworking

/// Clase donde las configuraciones para elementos de tipo global son almacenados en código duro
public class Settings {
    
    //Llaves utilizadas por las preferencias del dispositivo
    static let userTokenKey : String = "TokenKey"
    static let userRefreshKey : String = "RefreshKey"
    static let userNameKey : String = "NameKey"
    static let userFullNameKey : String = "FullNameKey"
    static let userRoleKey : String = "RoleKey"
    static let userEmailKey : String = "EmailKey"
    static let userImageUrl : String = "ImageKey"
    static let userNotificationId : String = "notificationsKey"
    static let userBrandingTier : String = "brandingKey"
    
    //URL base del dominio
    //DEV
    //static let baseUrl : String = "http://ralarousse.azurewebsites.net/"
    //PRE PROD
        //static let baseUrl : String = "http://ra-back-pre-prod.azurewebsites.net/"
    //QA
    //static let baseUrl : String = "https://ralarousse-deploy.azurewebsites.net/"
    //PROD
    static let baseUrl : String = "https://unificacion-api.azurewebsites.net/"
//    static let baseUrlB : String = "https://hlrma-api.azurewebsites.net"
    //https://unificacion-api.azurewebsites.net/token
    
    //URLs de servicios de eventos
    static let eventsUrl : URL = URL(string: baseUrl + "api/events/student?date=")!
    
    //URL de servicios de notificaciones
    static let tokenRegistrationUrl : URL = URL(string: baseUrl + "api/users/registerDevice")!
    static let userNotificationsInboxUrl : URL = URL(string: baseUrl + "api/users/all-notifications?")!
    
    //URLs de servicios de seguridad
    static let tokenUrl : URL = URL(string: baseUrl + "token")!
    static let passwordRecoveryUrl : URL = URL(string: baseUrl + "api/users/resetpassword")!
    static let userProfileUrl : URL = URL(string: baseUrl + "api/users/profile?origin=2")!
    static let sessionValidationUrl : URL = URL(string: baseUrl + "api/users/validateSession")!
    
    //URLs de servicios de Nodos
    static func contentNodesURL(parentId: Int) -> URL {
        let url : URL = URL(string: baseUrl + "api/nodes/\(parentId)/structure")!
        
        return url
    }
    
    static func professorResourcesURL(nodeId: Int, page: Int, size: Int, searchId: Int) -> URL {
        
        let url : URL = URL(string: baseUrl + "api/nodes/\(nodeId)/academic-manager?currentPage=\(page)&sizePage=\(size)&searchId=\(searchId)")!
        
        return url
    }
    
    static func nodeContentURL(parentId: Int) -> URL {
        let url : URL = URL(string: baseUrl + "api/nodes/\(parentId)/all-contents?nodeId=\(parentId)&fileTypeId=0&currentPage=0&sizePage=9999")!
        
        return url
    }
    
    static func textBooksContentURL(fileTypeId: Int) -> URL {
        let url : URL = URL(string: baseUrl + "api/nodes/145/all-contents?nodeId=145&fileTypeId=\(fileTypeId)&currentPage=0&sizePage=9999")!
        
        return url
    }
    
    static func nodeRelatedContentURL(nodeId: Int) -> URL {
        let url : URL = URL(string: baseUrl + "api/contents/\(nodeId)/relation/?currentPage=1&pageSize=8")!
        
        return url
    }
    
    static func contentVisitUrl(contentId: Int) -> URL {
        let url : URL = URL(string: baseUrl + "api/contents/\(contentId)/visits")!
        return url
    }
    
    /*static let rootNodeURL : URL = URL(string: baseUrl + "api/nodes/0/subnodes")!
    static let firstLevelNodeURL : URL = URL(string: baseUrl + "api/nodes/2/subnodes")!
    static let childNodeURL : URL = URL(string: baseUrl + "api/nodes/")!*/
    
    //URLs de servicios de cursos
    static let coursesURL : URL = URL(string:  baseUrl + "api/courses/teacher")!
    static let coursesTasksURL : URL = URL(string: baseUrl + "api/homeworks/student?studentGroupId=")!
    static let homeworkUploadUrl : URL = URL(string: baseUrl + "api/homeworks/uploadAnswer")!
    static let courseActivitiesURL: URL = URL(string: baseUrl + "api/activities/student?studentGroupId=")!
    static let activityUploadURL: URL = URL(string: baseUrl + "api/activities/uploadAnswer")!
    static func coursePlanningURL(groupId: Int) -> URL {
        let url : URL = URL(string: baseUrl + "api/courseplanning/Getgroup?id=\(groupId)")!
        return url
    }
    static func coursePartialsURL(groupId: Int) -> URL {
        let url : URL = URL(string: baseUrl + "api/schedulingpartial/GetByStudentGroup?id=\(groupId)")!
        return url
    }
    static func homeworkUploadedFilesUrl(homeworkId : Int) -> URL {
        let url : URL = URL(string: baseUrl + "api/homeworks/\(homeworkId)/answers")!
        
        return url
    }
    static func activityUploadedFilesUrl(activityId : Int) -> URL {
        let url : URL = URL(string: baseUrl + "api/activities/\(activityId)/answers")!
        
        return url
    }
    
    static func homeworkFileDeleteUrl(homeworkId: Int, fileId: Int) -> URL {
        let url : URL = URL(string: baseUrl + "api/homeworks/\(homeworkId)/deleteAnswer?answerId=\(fileId)")!
        
        return url
    }
    
    static func activityFileDeleteUrl(activityId: Int, fileId: Int) -> URL {
        let url : URL = URL(string: baseUrl + "api/activities/\(activityId)/deleteAnswer?answerId=\(fileId)")!
        
        return url
    }
    
    //URLs de servicios de examenes
    static let examSchedulesUrl : URL = URL(string: baseUrl + "api/examchedules/student?groupId=")!
    static let examQuestionsUrl : URL = URL(string: baseUrl + "api/teacherexams?id=")!
    static let examScoreUrl : URL = URL(string: baseUrl + "api/tests")!
    static func timedExamStartUrl(Id: Int, ExamScheduleId: Int) -> URL {
        let url : URL = URL(string: baseUrl + "api/teacherexams/StartExamSchedule?id=\(Id)&examScheduleId=\(ExamScheduleId)&image=true")!
        return url
    }
    
    //URLs de servicios de mensajeria
    static let userConversationsUrl : URL = URL(string: baseUrl + "api/messages/conversations")!
    static func convoMessagesUrl(chatGroupId : Int) -> URL {
        let url : URL = URL(string: baseUrl + "api/messages?id=\(chatGroupId)")!
        return url
    }
    static let sendMessageUrl : URL = URL(string: baseUrl + "api/messages")!
    static let userContactsUrl : URL = URL(string: baseUrl + "api/messages/contacts")!
    
//    //Configuración de la App de Vimeo
//    static let vimeoAppConfiguration = AppConfiguration(
//        clientIdentifier: "443030e54276aa02af6fd520626ca9bc401d4abc",
//        clientSecret: "Vh2Uf5AsJdDOzUic9scXXS3teqaGAvd6gR2pW2uI9wT5UKi4nuyBtHwyhyPjcjNUDWzBaqc0PM8yBVx2Yzw4NvRWRKVVc8a8KRbpA84TrzBe7iXjlcaZEtC6cRCKpvhy",
//        scopes: [.Public, .Private],
//        keychainService: "KeychainServiceVimeo")
    
    //URLs de servicios de calificación
    static func userScoreURL(groupId : Int) -> URL {
        let url : URL = URL(string: baseUrl + "api/scores/student/?studentGroupId=\(groupId)")!
        return url
    }
}

//extension Settings {
//    ///Branding color schemes
//    static func getBrandingScheme() -> BrandingScheme? {
//        var scheme : BrandingScheme!
//        
//        let accessLevel : String? = UserDefaults.standard.string(forKey: Settings.userBrandingTier)
//        
//        if let accessLevel = accessLevel {
//            switch accessLevel {
//            case "preescolar":
//                scheme = BrandingScheme(background: #colorLiteral(red: 0.9490196078, green: 0.9529411765, blue: 0.9490196078, alpha: 1), component: #colorLiteral(red: 0.5176470588, green: 0.03137254902, blue: 0.5176470588, alpha: 1))
//                scheme.backgroundImage = #imageLiteral(resourceName: "design-preescolar.jpg")
//            case "primaria":
//                scheme = BrandingScheme(background: #colorLiteral(red: 0.9607843137, green: 0.9882352941, blue: 0.9882352941, alpha: 1), component: #colorLiteral(red: 0.03921568627, green: 0.6274509804, blue: 0.5137254902, alpha: 1))
//                scheme.backgroundImage = #imageLiteral(resourceName: "design-primaria.jpg")
//            case "secundaria":
//                scheme = BrandingScheme(background: #colorLiteral(red: 0.9490196078, green: 0.9529411765, blue: 0.9490196078, alpha: 1), component: #colorLiteral(red: 0.0862745098, green: 0.4588235294, blue: 0.6470588235, alpha: 1))
//                scheme.backgroundImage = #imageLiteral(resourceName: "design-secundaria.jpg")
//            default:
//                scheme = BrandingScheme(background: UIColor.red, component: UIColor.lightGray)
//            }
//            return scheme
//        } else {
//            return BrandingScheme(background: UIColor.red, component: UIColor.lightGray)
//        }
//    }
//}
