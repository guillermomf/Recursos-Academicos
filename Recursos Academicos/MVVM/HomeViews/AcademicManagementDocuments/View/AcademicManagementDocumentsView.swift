//
//  AcademicManagementDocumentsView.swift
//  Recursos Academicos
//
//  Created by Gil casimiro on 08/03/24.
//

import SwiftUI

struct AcademicManagementDocumentsView: View {
    @StateObject var viewModel: AcademicManagementDocumentsViewModel = AcademicManagementDocumentsViewModel()
    @State var isSelected: Int = 0
    
    var body: some View {
        VStack{
           NavigationBarCustomTwoLines(title: "Documentos de gestión\nacadémica")
            ScrollView(.horizontal){
                LazyHGrid(rows: viewModel.columns, content: {
                    ForEach(viewModel.nodeList.indices, id: \.self) { item in
                        Button(action: {
                            isSelected = item
                            viewModel.idNode = viewModel.nodeList[item].id
                            print(viewModel.idNode)
//                            viewModel.loadResources(nodeId: viewModel.idNode)
                        }, label: {
                            VStack{
                                Image(viewModel.getImage(name: viewModel.nodeList[item].name))
                                    .resizable()
                                    .frame(width: 45, height: 45)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .strokeBorder(isSelected == item ? Color.orange : Color.clear, lineWidth: 2)
                                            .frame(width: 69, height: 69)
                                            .background(Color.white.cornerRadius(12))
                                    )
                                Text(viewModel.nodeList[item].name)
                                    .foregroundColor(.black)
                                    .customFont(fontKey: .robotoBold, size: 12)
                                    .padding(.top)
                            }
                        })
                    }
                }).frame(width: 75, height: 75)
                    .padding(.vertical)
            }
            ScrollView{
                VStack {
                    ForEach(viewModel.fileList, id: \.id) { list in
                        HStack{
                            Text(list.name)
                                .foregroundColor(Color.init(hex: "#252B33"))
                                .customFont(fontKey: .robotoregular, size: 16)
                                .lineLimit(1)
                            Spacer()
                            Image(systemName: "icloud.and.arrow.down.fill")
                                .resizable()
                                .frame(width: 24, height: 19)
                                .foregroundColor(Color.init(hex: "#004C98"))
                        }
                        .frame(height: 40)
                        .onTapGesture {
                            let url = URL(string: list.urlContent ?? "")!
                            UIApplication.shared.open(url)
                        }
                        Divider()
                    }
                }
            }
        }
        .padding(.horizontal)
        .background(Color.init(hex: "#F4F4F4")?.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .onAppear {
            viewModel.onAppear()
        }
    }
}

struct AcademicManagementDocumentsView_Previews: PreviewProvider {
    static var previews: some View {
        AcademicManagementDocumentsView()
    }
}
