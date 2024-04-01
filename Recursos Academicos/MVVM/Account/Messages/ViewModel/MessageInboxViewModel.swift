//
//  MessageViewModel.swift
//  Recursos Academicos
//
//  Created by Gil casimiro on 12/03/24.
//

import Foundation


class MessageInboxViewModel: ObservableObject {
    
    @Published var convoList : [ConversationModel] = []
    var receiverName : String?
    var receiverId : Int!
    var chatGroupId : Int = 0
    
    //Validar la sesión activa
 func validateSession() {
        convoList = []
        //Iniciar el indicador de actividad
//        tbConversations.backgroundView = loaderView
//        loaderIndicator.startAnimating()
        
        SecuritySrv.validateSession { (result) in
            if result {
                DispatchQueue.main.async {
                    self.loadConversations()
                }
            } else {
                DispatchQueue.main.async {
                    SecuritySrv.SharedInstance.refreshToken(success: { (result) in
                        if result {
                            DispatchQueue.main.async {
                                self.loadConversations()
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
    
    func loadConversations() {
        //Cargador de la tabla
//        tbConversations.backgroundView = loaderView
//        loaderIndicator.startAnimating()
        
        //Consultar el servicio web
        MessagesSrv.SharedInstance.getUserConversations { (result, list) in
            if result {
                DispatchQueue.main.async {
                    self.convoList = list.sorted(by: {$1.lastMessageDate! < $0.lastMessageDate!})
//                    self.loaderIndicator.stopAnimating()
                    
                    if self.convoList.count == 0 {
//                        self.tbConversations.backgroundView = self.viewEmptyContent
                    }
                    
//                    if self.refreshControl.isRefreshing {
//                        self.refreshControl.endRefreshing()
//                    }
                    
//                    self.tbConversations.reloadData()
                }
            } else {
                DispatchQueue.main.async {
                    self.convoList = MessagesSrv.SharedInstance.getStoredConversations().sorted(by: {$1.lastMessageDate! < $0.lastMessageDate!})
                    
//                    self.loaderIndicator.stopAnimating()
                    
                    if self.convoList.count == 0 {
//                        self.tbConversations.backgroundView = self.viewEmptyContent
                    }
                    
//                    if self.refreshControl.isRefreshing {
//                        self.refreshControl.endRefreshing()
//                    }
                    
//                    self.tbConversations.reloadData()
                }
            }
        }
    }
}

extension MessageInboxViewModel {
    func onAppear() {
        validateSession()
    }
}
