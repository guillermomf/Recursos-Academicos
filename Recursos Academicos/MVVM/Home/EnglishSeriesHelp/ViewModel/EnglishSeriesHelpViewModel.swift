//
//  EnglishSeriesHelpViewModel.swift
//  Recursos Academicos
//
//  Created by Gil casimiro on 20/03/24.
//

import Foundation
import SwiftUI

class EnglishSeriesHelpViewModel: ObservableObject {
    @Published var fileList : [ModelContentFile] = []
    @Published var fileTypeId: Int = Int()
    @Published var modelEmpty: String = String()
    @Published var parentNodeId : Int = Int()
    @Published var filterNodeid : Int = 0
    
    @ViewBuilder
    func goToViewSelected(name: String) -> some View {
        switch name {
        case "Libros de texto":
            TextBooksView(title: name)
        case "Guias":
            TextBooksView(title: name)
        case "Solucionarios":
            TextBooksView(title: name)
        default:
            EmptyView()
        }
    }
    
    func validateSession() {
        SecuritySrv.validateSession { (result) in
            if result {
                DispatchQueue.main.async {
                    self.loadContent()
                }
            } else {
                DispatchQueue.main.async {
                    SecuritySrv.SharedInstance.refreshToken(success: { (result) in
                        if result {
                            DispatchQueue.main.async {
                                self.loadContent()
                            }
                        } else {
                            DispatchQueue.main.async {
//                                SecuritySrv.logOut(self)
                            }
                        }
                    })
                }
            }
        }
    }
    
    func loadContent() {
        //Iniciar el indicador de actividad
        fileList.removeAll()
//        loaderIndicator.startAnimating()
        
        ContentSrv.SharedInstance.getTextBookNodes(fileTypeId: fileTypeId) { (result, list) in
            if result {
                DispatchQueue.main.async {
                    self.fileList = list.filter({$0.fileTypeId == self.fileTypeId})
//                    self.loaderIndicator.stopAnimating()
                    if self.fileList.count == 0 {
                        self.modelEmpty = "modelEmpty"
                    }
                }
            } else {
                DispatchQueue.main.async {
                    ContentSrv.SharedInstance.getStoredFileNodes(parentId: self.parentNodeId, success: { (result, list) in
                        DispatchQueue.main.async {
                            self.fileList = list!.filter({$0.fileTypeId == self.fileTypeId})
//                            self.loaderIndicator.stopAnimating()
                            if self.fileList.count == 0 {
                                self.modelEmpty = "modelEmpty"
                            }
                        }
                    })
                }
            }
        }
    }
}
