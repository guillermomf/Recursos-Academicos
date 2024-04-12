//
//  CourseHomeViewModel.swift
//  Recursos Academicos
//
//  Created by Gil casimiro on 10/04/24.
//

import Foundation


class CourseHomeViewModel: ObservableObject {
    
    @Published var CourseList : [CoursesModel] = []
    
    func validateSession() {
        //Vaciar cursos de la tabla
        CourseList = []
//        tbCourses.reloadData()
        //Iniciar el indicador de actividad
//        tbCourses.backgroundView = loaderView
//        loaderIndicator.startAnimating()
        
        SecuritySrv.validateSession { (result) in
            if result {
                DispatchQueue.main.async {
                    self.loadCourses()
                }
            } else {
                DispatchQueue.main.async {
                    SecuritySrv.SharedInstance.refreshToken(success: { (result) in
                        if result {
                            DispatchQueue.main.async {
                                self.loadCourses()
                            }
                        } else {
                            DispatchQueue.main.async {
//                                self.loaderIndicator.stopAnimating()
//                                SecuritySrv.logOut(self)
                            }
                        }
                    })
                }
            }
        }
    }

    func loadCourses() {
        
        //Obtener los cursos provenientes del servicio
        CourseSrv.SharedInstance.getCourses { (result, courseList) in
            
            if result {
                DispatchQueue.main.async {
                   
                    self.CourseList = CourseSrv.SharedInstance.persistentCourseList!.sorted(by: {$1.formattedStartDate < $0.formattedStartDate})
//                    self.tbCourses.reloadData()
                    print("CourseList \(self.CourseList)")
//                    self.loaderIndicator.stopAnimating()
                    
                    if self.CourseList.count == 0 {
                        print("CourseList isEmpty")
//                        self.tbCourses.backgroundView = self.emptyView
                    }
                    
//                    if self.refreshControl.isRefreshing {
//                        self.refreshControl.endRefreshing()
//                    }
                }
            } else {
                DispatchQueue.main.async {
//                    self.loaderIndicator.stopAnimating()
                    self.CourseList = CourseSrv.SharedInstance.persistentCourseList ?? []
//                    if self.refreshControl.isRefreshing {
//                        self.refreshControl.endRefreshing()
//                    }
                }
            }
        }
    }

    
    /// This funtion get the icon of AcountDetailView options
    /// - Parameters:
    ///    - action: The button that we want the icon
    /// - Returns: The correct icon
    
    func getIconAction(action: String) -> String {
        switch action {
        case "mensaje":
            return "icon-notif"
        case "check":
            return "icon-messages"
        case "pregunta":
            return "icon-unlocked"
        case "Ayuda":
            return "icon-help"
        case "Cerrar sesión":
            return"icon-off"
        default:
            return ""
        }
    }
}
