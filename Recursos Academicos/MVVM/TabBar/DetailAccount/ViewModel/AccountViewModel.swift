//
//  AccountViewModel.swift
//  Recursos Academicos
//
//  Created by Gil casimiro on 12/03/24.
//

import Foundation
import SwiftUI

class AccountViewModel: ObservableObject {
    
    @Published var userImage: String = String()
    @Published var actionsMenuAccount: [String] = ["Notificaciones", "Mensajes", "Aviso de privacidad", "Ayuda", "Cerrar sesión"]
    
    ///This function help us to build the correct of diferents option in AcountDetailView
    ///
    /// - Parameters:
    ///    - name: Name of the view to build
    /// - Returns: The new view
    
    @ViewBuilder
    func goToViewSelected(name: String) -> some View {
        switch name {
        case "Notificaciones":
            NotificationView()
        case "Mensajes":
            MessageInboxView()
        case "Aviso de privacidad":
            PrivacityNoticeView()
        case "Ayuda":
            PDFTextbooksView()
            //        case "Cerrar sesión":
        default:
            EmptyView()
        }
    }
    
    /// This funtion get the icon of AcountDetailView options
    /// - Parameters:
    ///    - action: The button that we want the icon
    /// - Returns: The correct icon
    
    func getIconAction(action: String) -> String {
        switch action {
        case "Notificaciones":
            return "icon-notif"
        case "Mensajes":
            return "icon-messages"
        case "Aviso de privacidad":
            return "icon-unlocked"
        case "Ayuda":
            return "icon-help"
        case "Cerrar sesión":
            return"icon-off"
        default:
            return ""
        }
    }
    ///This funtion get the image profile.
    func loadUserProfileImage() {
        //Configurar la foto de perfil
        if let imageUrlString = UserDefaults.standard.string(forKey: Settings.userImageUrl)?.trimmingCharacters(in: .whitespaces) {
            //            let url = URL(string: imageUrlString)!
            userImage = imageUrlString
        } else {
            userImage = "profile-placeholder"
        }
    }
    
}

extension AccountViewModel {
    func onAppear() {
        loadUserProfileImage()
    }
}
