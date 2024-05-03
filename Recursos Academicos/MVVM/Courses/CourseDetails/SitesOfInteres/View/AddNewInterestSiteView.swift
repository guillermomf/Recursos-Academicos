//
//  AddNewInterestSiteView.swift
//  Recursos Academicos
//
//  Created by Gil casimiro on 02/05/24.
//

import SwiftUI

struct AddNewInterestSiteView: View {
    @State var titleText: String = String()
    @State var urlText: String = String()
    @State private var descriptionText: String = ""
    @State var succes: Bool = Bool()

    var body: some View {
        ZStack{
            Color.white
            VStack{
                NavigationBarCustom(title: "Agregar sitio de interés")
                TextFieldCustom(text: $titleText, placeHolder: "Título del sitio")
                TextFieldCustom(text: $urlText, placeHolder: "URL")
                customTextEditor(placeHolder: "Descripción", text: $descriptionText)
                    .font(.body)
                    .transparentScrolling()
                    .background(Color.init(hex: "#F4F4F4"))
                    .accentColor(.blue)
                    .frame(height: 300)
                    .cornerRadius(8)
                
                Spacer()
                Button(action: {
                    succes.toggle()
                    print("\(titleText) \(urlText) \(descriptionText)")
                }, label: {
                    ButtonGradientCustom(image: "eye", title: "Guardar sitio de interés", colorOne: "#BD76E2", colorTwo: "FF5793", width: 335, height: 50)
                        .foregroundStyle(.white)
                        .padding(.bottom, 60)
                })
            }.padding(.horizontal)
                .disabled(succes)
            if succes {
                VStack{
                    Button(action: {
                        succes.toggle()
                    }, label: {
                        VStack{
                            Image(systemName: "checkmark.circle")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .foregroundStyle(Color.green)
                                .padding(.bottom, 16)
                            Text("¡Listo!")
                                .customFont(fontKey: .robotoBold, size: 23)
                                .foregroundStyle(Color.init(hex: "444444")!)
                            Text("Se ha guardado correctamente")
                                .customFont(fontKey: .robotoregular, size: 15)
                                .foregroundStyle(Color.init(hex: "444444")!)
                            Button(action: {
                                succes.toggle()
                            }, label: {
                                ButtonGradientCustom(image: "checkmark.circle", title: "Entendido", colorOne: "#00459A", colorTwo: "002161", width: 140, height: 50)
                                    .foregroundStyle(Color.white)
                            }).padding(.top)
                        }
                        .background(
                            RoundedCorner(radius: 12)
                                .foregroundStyle(Color.white)
                                .frame(width: 335, height: 280)
                        )
                    })
                }.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .background(Color.init(hex: "#000000").opacity(0.25).ignoresSafeArea(.all))
            }
        }.navigationBarBackButtonHidden(true)
        .ignoresSafeArea()
    }
}

#Preview {
    AddNewInterestSiteView()
}





