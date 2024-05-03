//
//  SitesOfInteresView.swift
//  Recursos Academicos
//
//  Created by Gil casimiro on 02/05/24.
//

import SwiftUI

struct SitesOfInterestModel: Hashable {
    var id: String?
    var name: String?
    var description: String?
}


struct SitesOfInteresView: View {
    @State var deleteItem: Bool = Bool()
    @State var testArray: [SitesOfInterestModel] = [SitesOfInterestModel(id: "1", name: "Nombre del sitio uno", description: "esta es una descripcion del sitio uno"), SitesOfInterestModel(id: "2", name: "Nombre del sitio dos", description: "esta es una descripcion del sitio dos")]
    //    @State var testArray: [SitesOfInterestModel] = []
    var body: some View {
        VStack{
            NavigationBarCustom(title: "Sitios de interés")
            ScrollView {
                ForEach(testArray, id: \.id){ index in
                    VStack {
                        VStack(spacing: 5){
                            Text(index.name ?? "")
                                .customFont(fontKey: .robotoBold, size: 20)
                                .foregroundStyle(Color.init(hex: "#252B33")!)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text(index.description ?? "")
                                .customFont(fontKey: .robotoregular, size: 13)
                                .foregroundStyle(Color.init(hex: "#444444")!)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        HStack{
                            Button(action: {
                                //action
                            }, label: {
                                Image(systemName: "square.and.pencil")
                                    .resizable()
                                    .foregroundStyle(Color.init(hex: "#838383")!)
                                    .frame(width: 30, height: 30)
                            })
                            .background(
                                RoundedCorner(radius: 10)
                                    .foregroundStyle(Color.white)
                                    .frame(width: 40, height: 40)
                            )
                            .padding(.trailing)
                            Button(action: {
                                deleteItem.toggle()
                            }, label: {
                                Image(systemName: "trash")
                                    .resizable()
                                    .foregroundStyle(Color.init(hex: "#838383")!)
                                    .frame(width: 30, height: 30)
                            }).background(
                                RoundedCorner(radius: 10)
                                    .foregroundStyle(Color.white)
                                    .frame(width: 40, height: 40)
                            )
                            Spacer()
                            Button(action: {
                                //action
                            }, label: {
                                Text("Visitar \(Image(systemName: "arrow.right"))")
                                    .customFont(fontKey: .robotoregular, size: 16)
                                    .foregroundStyle(Color.white)
                            }).background(
                                RoundedCorner(radius: 10)
                                    .foregroundStyle(LinearGradient(colors: [Color.init(hex: "#00459A")!, Color.init(hex: "#002161")!], startPoint: .leading, endPoint: .trailing))
                                    .frame(width: 100, height: 40)
                            )
                            .frame(width: 100, height: 40)
                        }//Hstack
                        .padding(.bottom, 10)
                        .padding([.top, .leading], 5)
                        Divider()
                    }//Vstack
                    .padding(.top, 20)
                }//foreach
                NavigationLink(destination: {AddNewInterestSiteView()}, label: {
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
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                if testArray.isEmpty {
                    Image(systemName: "text.bubble.fill")
                        .resizable()
                        .foregroundStyle(Color.init(hex: "#E3E3E3")!)
                        .opacity(0.8)
                        .frame(width: 100, height: 100)
                        .padding(.top, 150)
                    Text("¡Lo sentimos!\nNo hay contenido disponible\npor el momento.")
                        .customFont(fontKey: .robotoregular, size: 18)
                        .foregroundStyle(Color.init(hex: "#E3E3E3")!)
                        .opacity(0.8)
                        .multilineTextAlignment(.center)
                }
            }//Scroll
        }.padding(.horizontal)
            .navigationBarBackButtonHidden(true)
            .background(GeneralBackground())
            .disabled(deleteItem)
            .overlay(content: {
                if deleteItem {
                VStack{
                    Button(action: {
                        deleteItem.toggle()
                    }, label: {
                        VStack{
                            Image(systemName: "exclamationmark.circle")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .foregroundStyle(Color.init(hex: "#FFC002")!)
                                .padding(.bottom, 16)
                            Text("¿Estás seguro?")
                                .customFont(fontKey: .robotoBold, size: 23)
                                .foregroundStyle(Color.init(hex: "444444")!)
                            Text("¡Esta operación no se podrá revertir!")
                                .customFont(fontKey: .robotoregular, size: 15)
                                .foregroundStyle(Color.init(hex: "444444")!)
                            HStack {
                                Button(action: {
                                    deleteItem.toggle()
                                }, label: {
                                    ButtonGradientCustom(image: "", title: "Sí, estoy seguro", colorOne: "#00459A", colorTwo: "002161", width: 140, height: 50)
                                        .foregroundStyle(Color.white)
                                }).padding(.top)
                                Button(action: {
                                    deleteItem.toggle()
                                }, label: {
                                    ButtonGradientCustom(image: "multiply.circle", title: "Entendido", colorOne: "#EDEDED", colorTwo: "#EDEDED", width: 140, height: 50)
                                        .foregroundStyle(Color.black)
                                }).padding(.top)
                            }
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
            })
    }
}

#Preview {
    SitesOfInteresView()
}

//struct SitesOfInteresView: View {
//    var body: some View {
//
//    }
//}
