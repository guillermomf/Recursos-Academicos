//
//  GuidesAndDigitalResourcesViewModel.swift
//  Recursos Academicos
//
//  Created by Gil casimiro on 25/03/24.
//

import Foundation

class GuidesAndDigitalResourcesViewModel: ObservableObject {
    @Published var textToSearch: String = String()
    @Published var video: Videos = .init(id: Int(), image: String(), duration: Int(), user: Videos.User(id: Int(), name: String(), url: String()), videoFiles: [])
    @Published var showItemSelectd: Bool = Bool()
    @Published var nodeList = ["Secundaria", "Primaria", "Preescolar", "Ingles ELT"]
    @Published var isSelected: Int = 0
    @Published var isDownLoadTrue: Bool = Bool()
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
            
        case "Imprimibles":
            return "printer"
        case "Videos":
            return "video"
        case "Audios":
            return "waveform"
        case "Libros de texto": //icon-pdf
            return "list.bullet.clipboard"
        case "Guías":
            return "person.crop.square"
        case "Libros de texto digital":
            return "plus.square"
        case "Interactivo":
            return "righttriangle"
        default:
            return ""
        }
    }
}
