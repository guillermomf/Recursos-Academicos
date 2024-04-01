//
//  NotificationView.swift
//  Recursos Academicos
//
//  Created by Gil casimiro on 12/03/24.
//

import SwiftUI

struct NotificationView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: NotificationViewModel = NotificationViewModel()
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
                Text("Notificaciones")
                    .foregroundColor(Color.init(hex: "#004C98"))
                    .customFont(fontKey: .robotolight, size: 26)
                    .padding(.leading)
                Spacer()
            }
            .padding()
            ScrollView {
                ForEach(viewModel.notificationList, id: \.id) { item in
                    VStack(alignment:.leading){
                        HStack {
                            Image(systemName: "bell.and.waves.left.and.right")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(Color.init(hex: "#FF9D02"))
                                .background(RoundedRectangle(cornerRadius: 12).foregroundColor(Color.white).frame(width: 50, height: 50))
                                .padding()
                            VStack(alignment:.leading){
                                HStack{
                                    Text(item.title)
                                        .foregroundColor(Color.init(hex: "#23294C"))
                                        .customFont(fontKey: .robotoBold, size: 18)
                                    Spacer()
                                    Text(dateFormatterHelper(date: item.registerDate ?? Date()))
                                        .foregroundColor(Color.init(hex: "#A9A9A9"))
                                        .customFont(fontKey: .robotoregular, size: 14)
                                    
                                }
                                Text(item.message)
                                    .foregroundColor(Color.init(hex: "#444444"))
                                    .customFont(fontKey: .robotoregular, size: 14)
                                    .lineLimit(2)
                            }
                        }
                        Divider()
                    }
                }
                .padding(.horizontal)
            }
            .refreshable {
                viewModel.loadNotifications()
            }
        }
        .navigationBarBackButtonHidden(true)
        .background(Color.init(hex: "#F4F4F4").ignoresSafeArea())
        .onAppear{
            viewModel.onAppear()
        }
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView()
    }
}
