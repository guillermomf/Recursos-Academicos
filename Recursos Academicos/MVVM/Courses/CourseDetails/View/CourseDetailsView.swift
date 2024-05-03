//
//  CourseDetailsView.swift
//  Recursos Academicos
//
//  Created by Gil casimiro on 19/04/24.
//

import SwiftUI
import BottomSheet
import SwiftUIX

struct CourseDetailsView: View {
    @State var coursesList : [CoursesModel]
    @State var addGroupShow: Bool = Bool()
    @State var addNameGruop: String = String()
    @State var addPasswordGruop: String = String()
    @State var goToSitesOfInteres: Bool = Bool()
    @State var array: [String] = ["hola", "adios"]
    var body: some View {
        VStack(spacing: 25){
            NavigationBarCustom(title: "Atrás")
            VStack(spacing: 10){
                Text(coursesList.first?.name ?? "")
                    .customFont(fontKey: .robotoBold, size: 43)
                    .foregroundStyle(Color.init(hex: "#004C98")!)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(coursesList.first?.description ?? "")
                    .customFont(fontKey: .robotoregular, size: 13)
                    .foregroundStyle(Color.init(hex: "444444")!)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(coursesList.first?.goal ?? "")
                    .customFont(fontKey: .robotoregular, size: 13)
                    .foregroundStyle(Color.init(hex: "444444")!)
                    .frame(maxWidth: .infinity, alignment: .leading)
                HStack{
                    Button(action: {
                        addGroupShow.toggle()
                    }, label: {
                        HStack{
                            Image(systemName: "plus")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.white)
                            Text("Agregar grupo")
                                .customFont(fontKey: .robotoregular, size: 16)
                                .foregroundStyle(Color.white)
                        }
                        .background(
                            RoundedCorner(radius: 16)
                                .foregroundStyle(LinearGradient(colors: [Color.init(hex: "#00459A")!, Color.init(hex: "#002161")!], startPoint: .leading, endPoint: .trailing))
                                .frame(width: 180, height: 50)
                        )
                        .frame(width: 170, height: 50)
                    })
                    CircleImage(image: "link", action: {
                        goToSitesOfInteres.toggle()
                    })
                   
                    CircleImage(image: "trash",action: {
                        print("dos")
                    })
                    CircleImage(image: "square.and.pencil",action: {
                        print("tres")
                    })
                    //                    NavigationLink(_isActive: $goToSitesOfInteres, destination: {SitesOfInteresView()}, label: {EmptyView()})
                }
                .padding(.top)
                ScrollView {
                    //                    if let nameCourses = coursesList.first?.courseSections?.first?.classes {
                    //                        ForEach(nameCourses, id: \.self) { index in
                    //                            Text(index.name ?? "")
                    //                        }
                    //                    }
                    ForEach(array, id: \.self) { item in
                        HStack{
                            Text(item)
                                .customFont(fontKey: .robotoregular, size: 16)
                                .foregroundStyle(Color.init(hex: "#252B33")!)
                            Spacer()
                            Image(systemName: "ellipsis")
                        }.padding(.vertical,10)
                        Divider()
                    }
                }.padding(.vertical)
            }
        }
        //TODO: change when .sheet native be best option
        .navigationBarBackButtonHidden(true)
        .padding(.horizontal)
        .background(GeneralBackground())
        .bottomSheet(isPresented: $addGroupShow, height: 300, topBarCornerRadius: 30) {
            VStack{
                TextFieldCustom(text: $addNameGruop, placeHolder: "Nombre del grupo")
                TextFieldCustom(text: $addPasswordGruop, placeHolder: "Contraseña")
                HStack{
                    Button(action: {
                        //Action
                    }, label: {
                        ButtonGradientCustom(image: "", title: "Cancelar", colorOne: "#EDEDED", colorTwo: "#EDEDED", width: 170, height: 50)
                            .foregroundStyle(Color.init(hex: "#252B33")!)
                            .customFont(fontKey: .robotoregular, size: 16)
                    })
                    Spacer()
                    Button(action: {
                        //Action
                    }, label: {
                        ButtonGradientCustom(image: "", title: "Guardar", colorOne: "#BD76E2", colorTwo: "FF5793", width: 170, height: 50)
                            .foregroundStyle(Color.init(hex: "#FFFFFF")!)
                            .customFont(fontKey: .robotoregular, size: 16)
                    })
                }.padding(.vertical)
            }.padding(.horizontal)
        }
        NavigationLink(_isActive: $goToSitesOfInteres, destination: {SitesOfInteresView()}, label: {EmptyView()})
    }
}

#Preview {
    CourseDetailsView(coursesList: [])
}

struct CircleImage: View {
    @State var image: String
    @State var action: () -> Void?
    
    var body: some View {
        Button(action: {
            action()
        }, label: {
            Image(systemName: image)
                .resizable()
                .foregroundColor(.white)
                .frame(width: 30, height: 30)
                .background(
                    Circle()
                        .foregroundStyle(LinearGradient(colors: [Color.init(hex: "#FFC69F")!, Color.init(hex: "#FF5793")!], startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/))
                        .frame(width: 50, height: 50)
                )
                .frame(width: 50, height: 50)
        })
    }
}
