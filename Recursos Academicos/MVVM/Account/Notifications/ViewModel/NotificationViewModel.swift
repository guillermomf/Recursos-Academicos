//
//  NotificationViewModel.swift
//  Recursos Academicos
//
//  Created by Gil casimiro on 12/03/24.
//

import Foundation

class NotificationViewModel: ObservableObject {
    
    @Published var notificationList : [NotificationModel] = []
    var currentPagination : ListPagination?
    var pageSize : Int = 10
    
    func loadNotifications() {
        //Vaciar los campos de la tabla
        notificationList.removeAll()
        currentPagination = nil
        
        //Iniciar el indicador de actividad
//        loaderIndicator.startAnimating()
        
        NotificationSrv.SharedInstance.getUserNotifications(page: currentPagination?.pageNumber ?? 0 , pageSize: pageSize) { (result, list, pagination) in
            if result {
                DispatchQueue.main.async {
                    self.notificationList = list.sorted(by: {$1.registerDate! < $0.registerDate!})
                    self.currentPagination = pagination
//                    self.loaderIndicator.stopAnimating()
                    
                    if self.notificationList.count == 0 {
//                        self.tbNotifications.backgroundView = self.viewEmptyContent
                    }
                    
//                    self.tbNotifications.reloadData()
                }
            }
        }
    }
//    func dateFormatter(date: Date) -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy"
//        let year: String = dateFormatter.string(from: date)
//        dateFormatter.dateFormat = "MMM"
//        let month: String = dateFormatter.string(from: date)
//        dateFormatter.dateFormat = "dd"
//        let day: String = dateFormatter.string(from: date)
//        dateFormatter.dateFormat = "HH:mm"
//        let sentTime: String = dateFormatter.string(from: date)
//        
//        let finalDate = "\(sentTime) | \(month), \(day)"
//        
//        return finalDate
//    }
}

extension NotificationViewModel {
    
    func onAppear() {
        loadNotifications()
    }
}
