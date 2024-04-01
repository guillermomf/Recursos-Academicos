//
//  GuidesAndDigitalResourcesView.swift
//  Recursos Academicos
//
//  Created by Gil casimiro on 25/03/24.
//

import SwiftUI

struct GuidesAndDigitalResourcesView: View {
    let columns = [GridItem(.fixed(10))]
    @StateObject var viewModel: GuidesAndDigitalResourcesViewModel = GuidesAndDigitalResourcesViewModel()
    //TODO: Delete arrays
    @State var options: [String] = ["Imprimibles", "Videos", "Audios" , "Libros de texto", "Guías", "Libros de texto digital", "Interactivo"]
    @State var nodeList = ["Secundaria", "Primaria", "Preescolar", "Ingles ELT"]
    @State var isSelected: Int = 0
    @State var levelSelected: String = "Secundaria" //self.nodeList.first ?? ""
    var body: some View {
        ScrollView{
            VStack{
                NavigationBarCustomTwoLines(title: "Guías del maestro y recursos digitales")
                ScrollView(.horizontal){
                    LazyHGrid(rows: columns, content: {
                        ForEach(nodeList.indices, id: \.self) { item in
                            Button(action: {
                                levelSelected = nodeList[item]
                                isSelected = item
                                //                            viewModel.loadResources(nodeId: viewModel.idNode)
                            }, label: {
                                VStack{
                                    Image(viewModel.getImage(name: nodeList[item]))
                                        .resizable()
                                        .frame(width: 45, height: 45)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .strokeBorder(isSelected == item ? Color.orange : Color.clear, lineWidth: 2)
                                                .frame(width: 69, height: 69)
                                                .background(Color.white.cornerRadius(12))
                                        )
                                    Text(nodeList[item])
                                        .foregroundColor(Color.init(hex: "#004C98"))
                                        .customFont(fontKey: isSelected == item ? .robotoBold : .robotoregular, size: 12)
                                        .padding(.top)
                                }.padding(.trailing)
                            })
                        }
                    })
                    .frame(height: 75)
                    .padding(.vertical)
                    .padding(.leading)
                }
                
                ForEach(options, id: \.self){ item in
                    NavigationLink(destination: {GuidesAndResoucesItemSelectedView(academicLevel: levelSelected, itemSelected: item)}, label: {
                        HStack{
                            Image(systemName: viewModel.getImage(name: item))
                                .foregroundStyle(Color.init(hex: "#838383")!)
                                .padding(.leading)
                            Text(item)
                                .customFont(fontKey: .robotoregular, size: 16)
                                .foregroundStyle(Color.init(hex: "#252B33")!)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundStyle(Color.init(hex: "#838383")!)
                                .padding(.trailing)
                        }
                        .frame(height: 50)
                    })
                }
                .background(RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(Color.white)
                    .padding(.horizontal, 20)
                    .frame(width: UIScreen.main.bounds.width/1, height: 50)
                )
                .padding(.bottom, 5)
            }//VStack
        }//scrollView
        .padding(.horizontal)
        .background(GeneralBackground())
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    GuidesAndDigitalResourcesView()
}
