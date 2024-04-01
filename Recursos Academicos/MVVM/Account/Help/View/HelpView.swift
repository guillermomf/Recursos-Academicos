//
//  HelpView.swift
//  Recursos Academicos
//
//  Created by Gil casimiro on 14/03/24.
//

import SwiftUI

struct HelpView: View {
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
                        .padding()
                })

                Text("Ayuda - Preguntas frecuentes")
                    .foregroundColor(Color.init(hex: "#004C98"))
                    .customFont(fontKey: .robotolight, size: 26)
                Spacer()
            }
            .padding()
        }
    }
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView()
    }
}
