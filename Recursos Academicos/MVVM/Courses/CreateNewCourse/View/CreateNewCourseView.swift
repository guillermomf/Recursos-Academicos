//
//  CreateNewCourseView.swift
//  Recursos Academicos
//
//  Created by Gil casimiro on 11/04/24.
//

import SwiftUI

struct CreateNewCourseView: View {
    @State var text: String = String()
    @State var optionArray: [String] = ["primaria" ,"secundaria", "preescolar"]
    @State var isSelected: Bool = false
    var body: some View {
        ScrollView {
            VStack{
                NavigationBarCustom(title: "Crear nuevo curso")
                    .padding(.vertical, 30)
                VStack(spacing: 10){
                    TextFieldCustom(text: text, placeHolder: "Nombre del curso")
                    TextFieldCustom(text: text, placeHolder: "Institución")
                    TextFieldCustom(text: text, placeHolder: "Materia relacionada")
                    TextFieldCustom(text: text, placeHolder: "Descripción")
                    TextFieldCustom(text: text, placeHolder: "Objetivo")
                }.padding(.horizontal, 1)
                    .padding(.bottom, 10)
                VStack(spacing: 10){
                    InteractiveFieldCustom(actionButton: {
                        print("Nivel académico")
                    },name: "Nivel académico", imageName: "chevron.down", optionArray: optionArray, isSelected: isSelected)
                    
                    InteractiveFieldCustom(actionButton: {
                        print("Grado")
                    },name: "Grado", imageName: "chevron.down", optionArray: optionArray, isSelected: isSelected)
                    
                    CalendarFieldCustom(actionButton: {
                        print("Fecha inicio")
                    }, name: "Fecha inicio")
                    
                    CalendarFieldCustom(actionButton: {
                        print("Fecha termino")
                    }, name: "Fecha termino")
                    
                    InteractiveFieldCustom(actionButton: {
                        print("Días de la semana")
                    },name: "Días de la semana", imageName: "chevron.down", optionArray: optionArray, isSelected: isSelected)
                }.padding(.horizontal, 1)
                HStack{
                    Button(action: {
                        //Action
                    }, label: {
                        ButtonGradientCustom(title: "Cancelar", colorOne: "#EDEDED", colorTwo: "#EDEDED", width: 160, height: 50)
                            .foregroundStyle(Color.init(hex: "#252B33")!)
                            .customFont(fontKey: .robotoregular, size: 16)
                    })
                    Spacer()
                    Button(action: {
                        //Action
                    }, label: {
                        ButtonGradientCustom(title: "Guardar", colorOne: "#BD76E2", colorTwo: "FF5793", width: 160, height: 50)
                            .foregroundStyle(Color.init(hex: "#FFFFFF")!)
                            .customFont(fontKey: .robotoregular, size: 16)
                    })
                }.padding(.vertical)
            }.background(Color.init(hex: "#FFFFFF"))
        }//VStack
        .navigationBarBackButtonHidden(true)
        .padding(.horizontal)
    }//Scroll
}

#Preview {
    CreateNewCourseView()
}
