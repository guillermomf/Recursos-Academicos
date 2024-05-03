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
                SearchBarCustom(textToSearch: viewModel.searchText)
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
                    .onTapGesture {
                        viewModel.showFilterSheet.toggle()
                    }
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
                    ForEach(viewModel.CourseList, id: \.self){ item in
                        NavigationLink(destination: CourseDetailsView(coursesList: [item]), label: {
                            HStack{
                                Image(systemName: "plus")
                                    .foregroundColor(Color.init(hex: "#838383"))
                                    .padding(.leading)
                                Text(item.name)
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
                }
            }.padding(.top)
        }.navigationBarBackButtonHidden(true)
            .padding(.horizontal)
            .background(GeneralBackground().ignoresSafeArea())
            .onAppear{
                viewModel.validateSession()
            }
            .sheet(isPresented: $viewModel.showFilterSheet, content: {
                if #available(iOS 16.0, *) {
                    CourseFilterSheet(hiddenFilterView: $viewModel.showFilterSheet, alphabetic: $viewModel.alphabetic, oldest: $viewModel.oldest)
                        .presentationDetents([.height(420)])
                } else {
                    CourseFilterSheet(hiddenFilterView: $viewModel.showFilterSheet, alphabetic: $viewModel.alphabetic, oldest: $viewModel.oldest)
                }
            })
    }
}

#Preview {
    CoursesHomeView()
    //    CourseFilterSheet(hiddenFilterView: .constant(true), alphabetic: .constant(true), oldest: .constant(true))
}

struct CourseFilterSheet: View {
    @Binding var hiddenFilterView: Bool
    @Binding var alphabetic: Bool
    @Binding var oldest: Bool
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 15){
                Text("Odernar por")
                    .customFont(fontKey: .robotoregular, size: 14)
                    .foregroundStyle(Color.init(hex: "#000000")!)
                HStack {
                    Image(systemName: "eye")
                        .foregroundStyle(Color.init(hex: "#004C98")!)
                    Text("Más vistos")
                        .customFont(fontKey: .robotoBold, size: 20)
                        .foregroundStyle(Color.init(hex: "#004C98")!)
                }
            }.frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom)
            
            Group {
                Button(action: {
                    
                }, label: {
                    HStack{
                        Image(systemName: "arrow.up.and.down.text.horizontal")
                        Text("De la A a la Z (Alfabéticamente)")
                            .customFont(fontKey: .robotoregular, size: 20)
                            .foregroundStyle(Color.init(hex: "#252B33")!)
                    }
                })
                Divider()
                Button(action: {
                    
                }, label: {
                    HStack {
                        Image(systemName: "arrow.up.and.down.text.horizontal")
                        Text("De la Z a la A")
                            .customFont(fontKey: .robotoregular, size: 20)
                            .foregroundStyle(Color.init(hex: "#252B33")!)
                    }
                })
                Divider()
                Button(action: {
                    
                }, label: {
                    HStack {
                        Image(systemName: "arrow.up.and.down.text.horizontal")
                        Text("Más recientes (Fecha)")
                            .customFont(fontKey: .robotoregular, size: 20)
                            .foregroundStyle(Color.init(hex: "#252B33")!)
                    }
                })
                Divider()
                Button(action: {
                    
                }, label: {
                    HStack {
                        Image(systemName: "arrow.up.and.down.text.horizontal")
                        Text("Más antiguos (Fecha)")
                            .customFont(fontKey: .robotoregular, size: 20)
                            .foregroundStyle(Color.init(hex: "#252B33")!)
                    }
                })
            }.frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 5)
            HStack{
                Button(action: {
                    hiddenFilterView.toggle()
                }, label: {
                    ButtonGradientCustom(image: "", title: "Cancelar", colorOne: "#EDEDED", colorTwo: "#EDEDED", width: 160, height: 50)
                        .foregroundStyle(Color.init(hex: "#252B33")!)
                        .customFont(fontKey: .robotoregular, size: 16)
                })
                Spacer()
                Button(action: {
                    hiddenFilterView.toggle()
                }, label: {
                    ButtonGradientCustom(image: "", title: "Seleccionar", colorOne: "#BD76E2", colorTwo: "FF5793", width: 160, height: 50)
                        .foregroundStyle(Color.init(hex: "#FFFFFF")!)
                        .customFont(fontKey: .robotoregular, size: 16)
                })
            }.padding(.vertical)
        }.padding(.horizontal)
    }
}
