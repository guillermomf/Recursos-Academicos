//
//  MessageView.swift
//  Recursos Academicos
//
//  Created by Gil casimiro on 13/03/24.
//

import SwiftUI

struct MessageView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: MessageViewModel = MessageViewModel()
    @State var image : String?
    @State var receiverName : String
    @State var receiverId : Int
    @State var chatGroupId : Int
    @State var messageText: String = String()
    @Namespace var bottomID
    
    var body: some View {
        VStack {
            VStack{
                HStack{
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .frame(width: 12, height: 20)
                            .foregroundColor(Color.init(hex: "#004C98"))
                    })
                    if let img = image {
                        AsyncImage(url: URL(string: img)) {
                            img in
                            img.image?
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                                .padding(.leading, 10)
                        }
                    } else {
                        Image("profile-placeholder")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                            .padding(.leading, 10)
                    }
                    Text(receiverName)
                        .foregroundColor(Color.init(hex: "#444444"))
                        .customFont(fontKey: .robotoBold, size: 20)
                    Spacer()
                }
                .padding()
                Divider()
                ScrollView{
                    ScrollViewReader { value in
                        ForEach(viewModel.messageList, id: \.id) { item in
                            VStack{
                                if item.owner {
                                    VStack{
                                        HStack{
                                            Spacer()
                                            Text(item.message)
                                                .foregroundColor(Color.white)
                                                .customFont(fontKey: .robotoregular, size: 16)
                                                .padding(.horizontal, 15)
                                                .padding(.vertical, 10)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 12, style: .circular)
                                                        .foregroundColor(Color.init(hex: "#004C98"))
                                                )
                                        }
                                        HStack{
                                            Spacer()
                                            Text(dateFormatterHelper(date: item.senderDate ?? Date()))
                                                .foregroundColor(Color.init(hex: "A9A9A9"))
                                                .customFont(fontKey: .robotoregular, size: 12)
                                        }
                                    }
                                } else {
                                    VStack{
                                        HStack{
                                            Text(item.message)
                                                .foregroundColor(Color.init(hex: "454545"))
                                                .customFont(fontKey: .robotoregular, size: 16)
                                                .padding(.horizontal, 15)
                                                .padding(.vertical, 10)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 12, style: .circular)
                                                        .foregroundColor(Color.init(hex: "#F2F2F2"))
                                                )
                                            Spacer()
                                        }
                                        HStack{
                                            Text(dateFormatterHelper(date: item.senderDate ?? Date()))
                                                .foregroundColor(Color.init(hex: "A9A9A9"))
                                                .customFont(fontKey: .robotoregular, size: 12)
                                            Spacer()
                                        }
                                    }
                                }
                                
                            }.padding([.horizontal, .top])
                                .onReceive(viewModel.$scrollToBottom, perform: { response in
                                    if response {
                                        value.scrollTo(bottomID, anchor: .bottom)
                                    }
                                })
                                .onAppear{
                                    value.scrollTo(bottomID, anchor: .bottom)
                                    
                                }
                        }
                        Text("").id(bottomID)
                    }//ScrollRViewaider
                }//Scrool
                HStack{
                    TextField("Escribe un mensaje aqui", text: $messageText)
                        .frame(width: 290, height: 34)
                        .padding(.leading, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .circular)
                                .foregroundColor(Color.white)
                        )
                    Button(action: {
                        self.hideKeyboard()
                        viewModel.sendMessage(receiverId: receiverId, chatGroupId: chatGroupId, message: messageText)
                        messageText = ""
                    }, label: {
                        Image("icon-send")
                            .frame(width: 34, height: 34)
                    }).disabled(messageText.isEmpty)
                }.padding()
                    .frame(width: UIScreen.main.bounds.width)
                    .background(Color.init(hex: "#F4F4F4").ignoresSafeArea())
            }
            .background(Color.init(hex: "#FFFFFF"))
            .cornerRadius(20, corners: [.topLeft, .topRight])
            .padding(.top)
            .padding(.top)
        }//VStack
        .navigationBarBackButtonHidden(true)
        .background(Color.init(hex: "#F4F4F4").ignoresSafeArea())
        .onAppear{
            //            NotificationCenter.default.addObserver(self, selector: #selector(pushNotificationHandler(_:)), name: NSNotification.Name(rawValue: "NewNotification"), object: nil)
            viewModel.chatGroupId = chatGroupId
            viewModel.onAppear()
        }
    }
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        MessageView(image: String(), receiverName: String(), receiverId: Int(), chatGroupId: Int())
    }
}
