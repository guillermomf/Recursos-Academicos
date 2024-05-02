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
                    Image(systemName: "plus")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(.white)
                        .background(
                            RoundedCorner(radius: 16)
                                .foregroundStyle(LinearGradient(colors: [Color.init(hex: "#00459A")!, Color.init(hex: "#002161")!], startPoint: .leading, endPoint: .trailing))
                                .frame(width: 180, height: 50)
                        )
                        .frame(width: 180, height: 50)
                    })
                    CircleImage(image: "plus", action: {
                        print("uno")
                    })
                    CircleImage(image: "plus",action: {
                        print("dos")
                    })
                    CircleImage(image: "plus",action: {
                        print("tres")
                    })
                }
                .padding(.top)
                ScrollView {
                    if let nameCourses = coursesList.first?.courseSections?.first?.classes {
                        ForEach(nameCourses, id: \.self) { index in
                            Text(index.name ?? "")
                        }
                    }
                }
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
            }
        }
    }
}

#Preview {
    CourseDetailsView(coursesList: [])
}

struct CircleImage: View {
    @State var image: String
    @State var action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }, label: {
            Image(systemName: image)
                .background(
                    Circle()
                        .foregroundStyle(LinearGradient(colors: [Color.init(hex: "#FFC69F")!, Color.init(hex: "#FF5793")!], startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/))
                        .frame(width: 50, height: 50)
                )
                .frame(width: 50, height: 50)
        })
    }
}
