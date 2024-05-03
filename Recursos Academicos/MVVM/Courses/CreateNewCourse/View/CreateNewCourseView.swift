//
//  CreateNewCourseView.swift
//  Recursos Academicos
//
//  Created by Gil casimiro on 11/04/24.
//

import SwiftUI

struct CreateNewCourseView: View {
    
    @StateObject var viewModel: CreateNewCourseViewModel = CreateNewCourseViewModel()
    @State var optionArray: [String] = ["primaria" ,"secundaria", "preescolar"]
    
    var body: some View {
        ScrollView {
            VStack{
                NavigationBarCustom(title: "Crear nuevo curso")
                    .padding(.vertical, 30)
                VStack(spacing: 10){
                    TextFieldCustom(text: $viewModel.textCourseName, placeHolder: "Nombre del curso")
                        .onChange(of: viewModel.textCourseName, perform: {
                            _ in
                            print(viewModel.textCourseName)
                        })
                    TextFieldCustom(text: $viewModel.textInstitution, placeHolder: "Institución")
                    TextFieldCustom(text: $viewModel.textTopic, placeHolder: "Materia relacionada")
                    TextFieldCustom(text: $viewModel.textDescription, placeHolder: "Descripción")
                    TextFieldCustom(text: $viewModel.textObjetive, placeHolder: "Objetivo")
                }.padding(.horizontal, 1)
                    .padding(.bottom, 10)
                VStack(spacing: 10){
                    InteractiveFieldCustom(actionButton: {
                        print("Nivel académico")
                        viewModel.showAcademicLevelOptions.toggle()
                    },name: $viewModel.academicLevelSelected, imageName: "chevron.down", optionArray: optionArray, isSelected: $viewModel.showAcademicLevelOptions)
                    
                    InteractiveFieldCustom(actionButton: {
                        print("Grado")
                        viewModel.showGradeoptions.toggle()
                    },name: $viewModel.gradeSelected, imageName: "chevron.down", optionArray: optionArray, isSelected: $viewModel.showGradeoptions)
                    
                    CalendarFieldCustom(name: $viewModel.startDateText, date: $viewModel.startDateSelected)
                    CalendarFieldCustom(name:$viewModel.endDateText, date: $viewModel.endDateSelected)
                    
                    InteractiveFieldCustom(actionButton: {
                        print("Días de la semana")
                        viewModel.showDayOfWeekOptions.toggle()
                    },name: $viewModel.showDayOfWeekSelected, imageName: "chevron.down", optionArray: optionArray, isSelected: $viewModel.showDayOfWeekOptions)
                }.padding(.horizontal, 1)
                HStack{
                    Button(action: {
                        //Action
                    }, label: {
                        ButtonGradientCustom(image: "", title: "Cancelar", colorOne: "#EDEDED", colorTwo: "#EDEDED", width: 160, height: 50)
                            .foregroundStyle(Color.init(hex: "#252B33")!)
                            .customFont(fontKey: .robotoregular, size: 16)
                    })
                    Spacer()
                    Button(action: {
                        print("\(viewModel.textCourseName), \(viewModel.textInstitution), \(viewModel.textTopic), \(viewModel.textDescription), \(viewModel.textObjetive), \(viewModel.academicLevelSelected), \(viewModel.gradeSelected), \(viewModel.showDayOfWeekSelected), \(viewModel.startDateSelected), \(viewModel.endDateSelected)")
                    }, label: {
                        ButtonGradientCustom(image: "", title: "Guardar", colorOne: "#BD76E2", colorTwo: "FF5793", width: 160, height: 50)
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
