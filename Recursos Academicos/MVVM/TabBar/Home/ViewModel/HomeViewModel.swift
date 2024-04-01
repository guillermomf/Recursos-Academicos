//
//  HomeViewModel.swift
//  Recursos Academicos
//
//  Created by Gil casimiro on 08/03/24.
//

import Foundation
import SwiftUI


class HomeViewModel: ObservableObject {
    @Published var availableResources : [String] = []
    @Published var resourcesEmpty: Bool = Bool()
    var availableOptions : [String] = ["Guías del maestro y recursos digitales", "Documentos de gestión académica", "Serie de Inglés - Help!", "Servicios pedagógicos", "Sitios de interés recomendados", "Aplicaciones recomendadas", "Libros de texto en PDF", "Libros de texto digital"]
    
    
    func getResourcesPermissions() {
        ContentSrv.SharedInstance.getResourcesPermissions { (result, list) in
            if result {
                DispatchQueue.main.async {
                    for item in self.availableOptions {
                        if list.contains(item) {
                            self.availableResources.append(item)
                        }
                    }
                    //                    self.loaderIndicator.stopAnimating()
                    if self.availableResources.count == 0 {
                        self.resourcesEmpty = true
                    }
                }
            } else {
                DispatchQueue.main.async {
                    ContentSrv.SharedInstance.getStoredPermissions(success: { (result, list) in
                        DispatchQueue.main.async {
                            //                            self.loaderIndicator.stopAnimating()
                            for item in self.availableOptions {
                                if list.contains(item) {
                                    self.availableResources.append(item)
                                }
                            }
                            if self.availableResources.count == 0 {
                                self.resourcesEmpty = true
                            }
                        }
                    })
                }
            }
        }
    }
    
    /// This funtion allow us to create a new View whit the name of List in HomeView
    /// - Parameters:
    ///    - name: Name of the view that we want built
    /// - Returns: The correct view.
    
    @ViewBuilder
    func goToViewSelected(name: String) -> some View {
        switch name {
            //        case "Guías del maestro y recursos digitales":
            
        case "Documentos de gestión académica":
            AcademicManagementDocumentsView()
        case "Servicios pedagógicos":
            VStack{
                NavigationBarCustom(title: "Servicios pedagógicos")
                    .padding(.horizontal)
                PDFBuilderView(resourceName: "Servicios pedagógicos", resourceTitle: "Servicios_pedagogicos")
            }
        case "Sitios de interés recomendados":
            VStack{
                NavigationBarCustomTwoLines(title: "Sitios de interés recomendados")
                    .padding(.horizontal)
                PDFBuilderView(resourceName: "Sitios de interés recomendados", resourceTitle: "ligas_de_interes")
            }
        case "Aplicaciones recomendadas":
            VStack{
                NavigationBarCustomTwoLines(title: "Aplicaciones recomendadas")
                    .padding(.horizontal)
                PDFBuilderView(resourceName: "Aplicaciones recomendadas", resourceTitle: "Ligas_software_gratuito")
            }
        case "Libros de texto en PDF":
//            PDFTextbooksView()
//            EnglishSeriesHelpView()
            GuidesAndDigitalResourcesView()
            //        case "Libros de texto digital":
            
        case "Serie de Inglés - Help!":
            EnglishSeriesHelpView() 
        default:
            EmptyView()
        }
    }
}

extension HomeViewModel {
    func onAppear(){
        availableResources.removeAll()
        getResourcesPermissions()
    }
}


