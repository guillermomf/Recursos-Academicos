//
//  TextBooksView.swift
//  Recursos Academicos
//
//  Created by Gil casimiro on 20/03/24.
//

import SwiftUI
import SwiftUIX

struct TextBooksView: View {
    @State var viewModel: EnglishSeriesHelpViewModel = EnglishSeriesHelpViewModel()
    //TODO: delete this array after connect to backEnd
    @State var options: [String] = ["Opcion 1", "Opcion 2", "Opcion 3"]
    @State var title: String
    @State var searchText: String = String()
    var body: some View {
        VStack{
            NavigationBarCustom(title: "Serie de inglés Help!")
            HStack{
                VStack(alignment: .leading, spacing: 10){
                    Text(title)
                        .customFont(fontKey: .robotoregular, size: 17)
                        .foregroundColor(Color.init(hex: "#23294C"))
                    Image("help_english")
                        .padding(.trailing)
                }
                Spacer()
            }
            .padding()
           SearchBarCustom(textToSearch: searchText)
            ScrollView{
                ForEach(options, id:\.self){item in
                    NavigationLink(destination: SeriesHelpContentSeleted(title: title, itemSelected: item), label: {
                        VStack{
                            HStack{
                                Image(systemName: "checkmark.seal")
                                Text(item)
                                    .customFont(fontKey: .robotoregular, size: 16)
                                    .foregroundColor(Color.init(hex: "#252B33"))
                                Spacer()
                                Image(systemName: "arrowtriangle.right.fill")
                                    .foregroundColor(Color.init(hex: "#004C98"))
                            }
                            Divider()
                        }
                    })
                }
            }.padding(.top)
                .refreshable {
                    viewModel.validateSession()
                }
        }.navigationBarBackButtonHidden(true)
            .padding(.horizontal)
            .onAppear{
                //                viewModel.validateSession()
            }
            .background(GeneralBackground())
    }
}

struct TextBooksView_Previews: PreviewProvider {
    static var previews: some View {
        TextBooksView(title: String())
    }
}

struct botomShetFilter: View {
    var body: some View {
        VStack{
            
        }
    }
}
