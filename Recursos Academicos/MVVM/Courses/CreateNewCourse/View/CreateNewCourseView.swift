//
//  CreateNewCourseView.swift
//  Recursos Academicos
//
//  Created by Gil casimiro on 11/04/24.
//

import SwiftUI

struct CreateNewCourseView: View {
    
    @State var optionArray: [String] = ["primaria" ,"secundaria", "preescolar"]
    //Info to send
    @State var textCourseName: String = String()
    @State var textInstitution: String = String()
    @State var textTopic: String = String()
    @State var textDescription: String = String()
    @State var textObjetive: String = String()
    @State var showAcademicLevelOptions: Bool = false
    @State var showGradeoptions: Bool = false
    @State var showDayOfWeekOptions: Bool = false
    @State var academicLevelSelected: String = "Nivel académico"
    @State var gradeSelected: String = "Grado"
    @State var showDayOfWeekSelected: String = "Días de la semana"
    @State var startDateText: String = "Fecha inicio"
    @State var startDateSelected: Date = Date()
    @State var endDateText: String = "Fecha termino"
    @State var endDateSelected: Date = Date()
    
        @State var showDatePicker = false
       

    var body: some View {
        ScrollView {
            VStack{
                NavigationBarCustom(title: "Crear nuevo curso")
                    .padding(.vertical, 30)
                VStack(spacing: 10){
                    TextFieldCustom(text: $textCourseName, placeHolder: "Nombre del curso")
                        .onChange(of: textCourseName, perform: {
                            _ in
                            print(textCourseName)
                        })
                    TextFieldCustom(text: $textInstitution, placeHolder: "Institución")
                    TextFieldCustom(text: $textTopic, placeHolder: "Materia relacionada")
                    TextFieldCustom(text: $textDescription, placeHolder: "Descripción")
                    TextFieldCustom(text: $textObjetive, placeHolder: "Objetivo")
                }.padding(.horizontal, 1)
                    .padding(.bottom, 10)
                VStack(spacing: 10){
                    InteractiveFieldCustom(actionButton: {
                        print("Nivel académico")
                        showAcademicLevelOptions.toggle()
                    },name: $academicLevelSelected, imageName: "chevron.down", optionArray: optionArray, isSelected: $showAcademicLevelOptions)
                    
                    InteractiveFieldCustom(actionButton: {
                        print("Grado")
                        showGradeoptions.toggle()
                    },name: $gradeSelected, imageName: "chevron.down", optionArray: optionArray, isSelected: $showGradeoptions)
                    
                    CalendarFieldCustom(name: $startDateText, date: $startDateSelected)
                    CalendarFieldCustom(name:$endDateText, date: $endDateSelected)
                    
                    InteractiveFieldCustom(actionButton: {
                        print("Días de la semana")
                        showDayOfWeekOptions.toggle()
                    },name: $showDayOfWeekSelected, imageName: "chevron.down", optionArray: optionArray, isSelected: $showDayOfWeekOptions)
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
                        print("\(textCourseName), \(textInstitution), \(textTopic), \(textDescription), \(textObjetive), \(academicLevelSelected), \(gradeSelected), \(showDayOfWeekSelected), \(startDateSelected), \(startDateSelected)")
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

