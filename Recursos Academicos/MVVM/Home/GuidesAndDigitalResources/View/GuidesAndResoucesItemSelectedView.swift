//
//  GuidesAndResoucesItemSelectedView.swift
//  Recursos Academicos
//
//  Created by Gil casimiro on 26/03/24.
//

import SwiftUI

struct GuidesAndResoucesItemSelectedView: View {
    @StateObject var viewModel: GuidesAndDigitalResourcesViewModel = GuidesAndDigitalResourcesViewModel()
    @StateObject var viewModelVideos = ViewModel()
    @StateObject var vm: DownloadViewModel = .init()
    @State var academicLevel: String
    @State var itemSelected: String
    //TODO: Remove this array after connect to backEnd
    @State var options: [String] = ["Opcion 1", "Opcion 2", "Opcion 3", "Opcion 4", "Opcion 5" , "Opcion 6", "Opcion 7"]
    var body: some View {
        ScrollView{
            VStack{
                NavigationBarCustomTwoLines(title: "Guías del maestro y recursos digitales")
                HStack {
                    Image(viewModel.getImage(name: academicLevel))
                    VStack(alignment: .leading){
                        Text(academicLevel)
                            .customFont(fontKey: .robotoBold, size: 20)
                            .foregroundStyle(Color.init(hex: "#23294C")!)
                        Text(itemSelected)
                            .customFont(fontKey: .robotoregular, size: 17)
                            .foregroundStyle(Color.init(hex: "#23294C")!)
                    }.padding(.leading, 8)
                    Spacer()
                }
                .padding(.vertical)
                SearchBarCustomWithFilter(textToSearch: viewModel.textToSearch)
                    .padding(.bottom)
                if itemSelected == "Guías" || itemSelected == "Libros de texto" || itemSelected ==  "Imprimibles" {
                    ForEach(options, id:\.self){ item in
                        NavigationLink(destination: {SeriesHelpContentSeleted(title: itemSelected, itemSelected: item)}, label: {
                            VStack{
                                HStack{
                                    Image(systemName: viewModel.getImage(name: itemSelected))
                                    Text(item)
                                        .customFont(fontKey: .robotoregular, size: 16)
                                        .foregroundColor(Color.init(hex: "#252B33"))
                                    Spacer()
                                    Image(systemName: "arrowtriangle.right.fill")
                                        .foregroundColor(Color.init(hex: "#004C98"))
                                }
                                Divider()
                                    .padding(.vertical, 10)
                            }
                        })
                    }
                } else if itemSelected == "Videos" || itemSelected == "Audios" {
                    ForEach(viewModelVideos.videos, id: \.id) { item in
                        Button(action: {
                            viewModel.video = item
                            print("Item\(item)")
                            viewModel.showItemSelectd = true
                        }, label: {
                            HStack {
                                Image(systemName: viewModel.getImage(name: itemSelected))
                                Text(item.user.name)
                                Spacer()
                                Image(systemName: "arrowtriangle.right.fill")
                                    .foregroundColor(Color.init(hex: "#004C98"))
                            }
                        })
                        Divider()
                            .padding(.vertical, 10)
                    }.background(NavigationLink(isActive: $viewModel.showItemSelectd, destination: {VideoHelperItemSeleted(title: itemSelected, video: viewModel.video)},  label: {EmptyView()}).opacity(0.0))
                } else if itemSelected == "Libros de texto digital" || itemSelected == "Interactivo"{
                    ForEach(options, id:\.self){ item in
                        NavigationLink(destination: {SeriesHelpContentSeleted(title: itemSelected, itemSelected: item)}, label: {
                            VStack{
                                HStack{
                                    Image(systemName: viewModel.getImage(name: itemSelected))
                                    Text(item)
                                        .customFont(fontKey: .robotoregular, size: 16)
                                        .foregroundColor(Color.init(hex: "#252B33"))
                                    Spacer()
                                    Image(systemName: "arrowtriangle.right.fill")
                                        .foregroundColor(Color.init(hex: "#004C98"))
                                }
                                Divider()
                                    .padding(.vertical, 10)
                            }.onTapGesture {
                                //                                let url = URL(string: item.urlContent ?? "")!
                                //                                UIApplication.shared.open(url)
                            }
                        })
                    }
                    
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .padding()
        .background(GeneralBackground())
        .refreshable {
            await viewModelVideos.findvideos()
        }
    }
}

#Preview {
    GuidesAndResoucesItemSelectedView(academicLevel: "Secundaria", itemSelected: "Audios")
}
