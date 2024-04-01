//
//  MessageInboxView.swift
//  Recursos Academicos
//
//  Created by Gil casimiro on 12/03/24.
//

import SwiftUI

struct MessageInboxView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: MessageInboxViewModel = MessageInboxViewModel()
    var body: some View {
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
                Text("Mensajes")
                    .foregroundColor(Color.init(hex: "#004C98"))
                    .customFont(fontKey: .robotolight, size: 26)
                    .padding(.leading)
                Spacer()
            }
            .padding()
            ScrollView{
                ForEach(viewModel.convoList, id: \.chatGroupId) { item in
                    NavigationLink(destination: {
                        MessageView(image: item.receiverAvatar, receiverName: item.receiverUserName, receiverId: item.receiverUserId, chatGroupId: item.chatGroupId)
                    }, label: {
                    VStack(alignment:.leading){
                        HStack{
                            if let img = item.receiverAvatar {
                                AsyncImage(url: URL(string: img)) {
                                    img in
                                    img.image?
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 50, height: 50)
                                        .clipShape(Circle())
                                }
                            } else {
                                Image("profile-placeholder")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 54, height: 54)
                                    .clipShape(Circle())
                            }
                            VStack(alignment:.leading, spacing: 3) {
                                HStack {
                                    Text(item.receiverUserName)
                                        .customFont(fontKey: .robotoBold, size: 17)
                                        .foregroundColor(Color.init(hex: "#444444"))
                                    Spacer()
                                    Text(dateFormatterHelper(date: item.lastMessageDate ?? Date()))
                                        .customFont(fontKey: .robotoregular, size: 14)
                                        .foregroundColor(Color.init(hex: "#A9A9A9"))
                                }
                                HStack {
                                    Text(item.lastMessage ?? "")
                                        .customFont(fontKey: .robotoregular, size: 14)
                                        .foregroundColor(Color.init(hex: "#444444"))
                                    Spacer()
                                    if !item.isRead {
                                        Image(systemName: "circle.fill")
                                            .resizable()
                                            .frame(width: 10, height: 10)
                                            .foregroundColor(Color.init(hex: "#028CFF"))
                                    }
                                }
                            }
                        }
                        .padding(.bottom, 10)
                        Divider()
                    }.padding([.horizontal, .top])
                })
                }
            }//Scrool
            .background(Color.init(hex: "#FFFFFF"))
            .cornerRadius(20, corners: [.topLeft, .topRight])
        }
        .navigationBarBackButtonHidden(true)
        .background(Color.init(hex: "#F4F4F4").ignoresSafeArea())
        .onAppear{
            viewModel.onAppear()
        }
    }
}

struct MessageInboxView_Previews: PreviewProvider {
    static var previews: some View {
        MessageInboxView()
    }
}
//TODO: Cambiar de lugar
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}
//TODO: Cambiar de lugar
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
