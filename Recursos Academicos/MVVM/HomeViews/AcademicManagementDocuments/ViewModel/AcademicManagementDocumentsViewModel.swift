//
//  AcademicManagementDocumentsViewModel.swift
//  Recursos Academicos
//
//  Created by Gil casimiro on 09/03/24.
//

import Foundation
import UIKit
import SwiftUI

class AcademicManagementDocumentsViewModel: ObservableObject {
    
    @Published var nodeList : [ModelContentNode] = []
    @Published var fileList : [ModelContentFile] = []
    @Published var idNode: Int = Int()
    @Published var isActiveBool: Bool = Bool()
    let columns = [GridItem(.fixed(10))]
    
    func loadResources(nodeId: Int){
        //Vaciar elementos del listado
        fileList.removeAll()
        
        //Iniciar cargadores de contenido
        //        loaderIndicator.startAnimating()
        
        ContentSrv.SharedInstance.getProfessorResources(nodeId: nodeId, searchId: 1) { (result, list)  in
            
            if result {
                DispatchQueue.main.async {
                    self.fileList = list.sorted(by: {$1.name < $0.name})
                    
                    if self.fileList.count == 0 {
                        //Poner etiqueta para cuando esta vacio y presentarla en la View
                    }
                    print(self.fileList)
                    //                if self.loaderIndicator.isAnimating {
                    //                    self.loaderIndicator.stopAnimating()
                    //                }
                }
            } else {
                DispatchQueue.main.async {
                    if self.fileList.count == 0 {
                        //Poner etiqueta para cuando esta vacio y presentarla en la View
                    }
                    //                if self.loaderIndicator.isAnimating {
                    //                    self.loaderIndicator.stopAnimating()
                    //                }
                }
            }
        }
    }
    
    func loadContent() {
        //Cargar contenido
        ContentSrv.SharedInstance.getParentNodes(ParentId: nil) { (result) in
            if result {
                DispatchQueue.main.async {
                    ContentSrv.SharedInstance.getStoredNodes(parentId: nil, success: { (result, nodeList) in
                        self.nodeList = nodeList!.filter({$0.parentId == 124 && $0.id == 145})
                        self.loadResources(nodeId: (self.nodeList.first?.id)!)
                    })
                }
            } else {
                DispatchQueue.main.async {
                    ContentSrv.SharedInstance.getStoredNodes(parentId: nil, success: { (result, nodeList) in
                        self.nodeList = nodeList!.filter({$0.parentId == 124 && $0.id == 145})
                        self.loadResources(nodeId: (self.nodeList.first?.id)!)
                    })
                }
            }
        }
    }
    
    ///funntion that get the icon image un our grid
    ///
    /// - Parameters:
    ///    - name: Name of the icon that we want
    /// - Returns: The correct icon
    
    func getImage(name: String) -> String{
        switch name {
        case "Secundaria":
            return "icon_secundaria"
        case "Preescolar":
            return "icon_preescolar"
        case "Primaria":
            return "icon_primaria"
        case "Ingles ELT":
            return "icon_ingles"
        default:
            return ""
        }
    }
}

extension AcademicManagementDocumentsViewModel {
    func onAppear() {
//        let concurrentQueue = DispatchQueue.init(label: "loadContent.concurrent.queue", attributes: .concurrent)
//        concurrentQueue.async {
            self.loadContent()
//        }
    }
}
