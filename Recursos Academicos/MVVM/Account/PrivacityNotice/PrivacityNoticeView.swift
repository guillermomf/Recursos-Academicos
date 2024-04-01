//
//  PrivacityNoticeView.swift
//  Recursos Academicos
//
//  Created by Gil casimiro on 12/03/24.
//

import SwiftUI

struct PrivacityNoticeView: View {
    @Environment(\.presentationMode) var presentationMode
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
                Text("Aviso de Privacidad")
                    .foregroundColor(Color.init(hex: "#004C98"))
                    .customFont(fontKey: .robotolight, size: 26)
                    .padding(.leading)
                Spacer()
            }
            .padding()
            ScrollView{
                Image("privacy_policy")
                    .resizable()
                    .background(
                        Rectangle()
                            .foregroundColor(Color.white)
                            .shadow(color: Color.gray, radius: 3)
                            .padding()
                    )
            }
        }
        .navigationBarBackButtonHidden(true)
        .background(Color.init(hex: "#F4F4F4")?.ignoresSafeArea())
    }
}

struct PrivacityNoticeView_Previews: PreviewProvider {
    static var previews: some View {
        PrivacityNoticeView()
    }
}
