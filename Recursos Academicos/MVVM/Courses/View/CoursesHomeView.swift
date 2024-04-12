//
//  CoursesHomeView.swift
//  Recursos Academicos
//
//  Created by Gil casimiro on 09/04/24.
//

import SwiftUI

struct CoursesHomeView: View {
    @StateObject var viewModel: CourseHomeViewModel = CourseHomeViewModel()
    @State var items: [String] = ["mensaje","check","pregunta"]
    @State var options: [String] = ["Libros de texto", "Guias", "Solucionarios"]
    @State var searchText: String = String()
    var body: some View {
        VStack{
            HStack{
                Text("Cursos")
                    .foregroundStyle(Color.init(hex: "#002161")!)
                    .customFont(fontKey: .robotoBold, size: 43)
                Spacer()
                ForEach(items, id: \.self) { index in
                    Image(viewModel.getIconAction(action: index))
                        .foregroundColor(.white)
                        .background(
                            RoundedCorner(radius: 16)
                                .foregroundStyle(LinearGradient(colors: [Color.init(hex: "#FFC69F")!, Color.init(hex: "#FF5793")!], startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/))
                                .frame(width: 50, height: 50)
                        )
                        .padding(10)
                }
            }.padding(.bottom, 10)
            Text("Envía y recibe documentos con tus alumno, programa actividades y tareas, programa exámenes en línea, pasa asistencia y genera calificaciones con base a tus parámetros de evaluación.")
                .foregroundStyle(Color.init(hex: "#444444")!)
                .customFont(fontKey: .robotoregular, size: 13)
            HStack(spacing: 0){
                SearchBarCustom(textToSearch: searchText)
                    .padding(.vertical)
                Image(systemName: "slider.horizontal.3")
                    .foregroundStyle(Color.white)
                    .frame(width: 50, height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundStyle(LinearGradient(colors: [Color.init(hex: "#B47AED")!, Color.init(hex: "#FF5793")! ], startPoint: .leading, endPoint: .trailing))
                            .frame(width: 50, height: 50)
                    )
                    .padding(.horizontal, 25)
                NavigationLink(destination: {CreateNewCourseView()}, label: {
                Image(systemName: "plus")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .foregroundColor(.white)
                    .background(
                        Circle()
                            .foregroundStyle(LinearGradient(colors: [Color.init(hex: "#00459A")!, Color.init(hex: "#002161")! ], startPoint: .leading, endPoint: .trailing))
                            .frame(width: 50, height: 50)
                    )
                })
            }.padding([.trailing, .bottom], 10)
            Divider()
            ScrollView {
                VStack{
                    ForEach(options, id: \.self){ item in
                        NavigationLink(destination: Text("hola"), label: {
                            HStack{
                                Image(systemName: "plus")
                                    .foregroundColor(Color.init(hex: "#838383"))
                                    .padding(.leading)
                                Text(item)
                                    .customFont(fontKey: .robotoregular, size: 16)
                                    .foregroundColor(Color.init(hex: "#252B33"))
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(Color.init(hex: "#838383"))
                                    .padding(.trailing)
                            } .frame(width: UIScreen.main.bounds.width/1.1, height: 50)
                            .background(RoundedRectangle(cornerRadius: 15)
                                .foregroundColor(Color.white)
                                .frame(width: UIScreen.main.bounds.width/1.1, height: 50)
                            )
                        })
                    }
                    .padding(.bottom, 5)
                }.padding(.top)
            }
        }.navigationBarBackButtonHidden(true)
        .padding(.horizontal)
        .background(GeneralBackground().ignoresSafeArea())
        .onAppear{
            viewModel.validateSession()
        }
    }
}

#Preview {
    CoursesHomeView()
}

