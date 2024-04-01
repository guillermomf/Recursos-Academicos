//
//  MessageViewModelq.swift
//  Recursos Academicos
//
//  Created by Gil casimiro on 13/03/24.
//

import Foundation
import UIKit

class MessageViewModel: ObservableObject {
    
    @Published var chatGroupId : Int?
    @Published var messageList : [MessageModel] = []
    @Published var scrollToBottom : Bool = false
    var receiverName : String?
    var receiverId : Int = 0
    
    func validateSession() {
        //Vaciar cursos de la tabla
        messageList = []
        //Iniciar el indicador de actividad
//        loaderIndicator.startAnimating()
        
        SecuritySrv.validateSession { (result) in
            if result {
                DispatchQueue.main.async {
                    self.loadMessages()
                }
            } else {
                DispatchQueue.main.async {
                    SecuritySrv.SharedInstance.refreshToken(success: { (result) in
                        if result {
                            DispatchQueue.main.async {
                                self.loadMessages()
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
    
    func loadMessages() {
        if let chatGroupId = chatGroupId {
            MessagesSrv.SharedInstance.getConversationMessages(chatGroupId: chatGroupId) { (result, list) in
                if result {
                    DispatchQueue.main.async {
                        self.messageList = list.sorted(by: {$1.messageSequence > $0.messageSequence})
//                        self.loaderIndicator.stopAnimating()
//                        print(self.messageList)
                        self.scrollToBottom = true
                        if self.messageList.count == 0 {
//                            self.tbMessages.backgroundView = self.viewEmptyContent
                        }
//                        self.tbMessages.reloadData()
//                        self.scrollToBottom(animated: false)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.messageList = MessagesSrv.SharedInstance.getStoredMessages(chatGroupId: chatGroupId).sorted(by: {$1.messageSequence > $0.messageSequence})
//                        self.loaderIndicator.stopAnimating()
//                        print(self.messageList)
                        self.scrollToBottom = true
                        if self.messageList.count == 0 {
//                            self.tbMessages.backgroundView = self.viewEmptyContent
                        }
                        
//                        self.tbMessages.reloadData()
//                        self.scrollToBottom(animated: false)
                    }
                }
            }
        }
    }
    func sendMessage(receiverId: Int, chatGroupId: Int, message: String) {
//        btnSend.isEnabled = false
//        let messageString = txtMessage.text?.trimmingCharacters(in: .whitespaces)
        
        if !(message.isEmpty) {
            MessagesSrv.SharedInstance.sendMessage(receiverId: receiverId, chatGroupId: chatGroupId, message: message) { (result, message) in
                
                if result {
                    DispatchQueue.main.async {
                        self.messageList.append(message!)
//                        self.scrollToBottom(animated: true)
                        
                    }
                } else {
                    DispatchQueue.main.async {
//                        let Alert = UIAlertController(title: "Error de envio", message: "El mensaje no pudo se enviado, verifica tu conexión a internet o intenta de nuevo mas tarde", preferredStyle: .alert)
//                        let Action = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
//
//                        Alert.addAction(Action)
//                        self.present(Alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
}
extension MessageViewModel {
    func onAppear() {
        validateSession()
    }
}

extension MessageView {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
