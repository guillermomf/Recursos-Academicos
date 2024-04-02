//
//  EnglishSeriesHelpView.swift
//  Recursos Academicos
//
//  Created by Gil casimiro on 14/03/24.
//

import SwiftUI

struct EnglishSeriesHelpView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var options: [String] = ["Libros de texto", "Guias", "Solucionarios"]
    @State var viewModel: EnglishSeriesHelpViewModel = EnglishSeriesHelpViewModel()
    var body: some View {
        VStack{
            HStack{
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .frame(width: 12, height: 20)
                        .foregroundColor(Color.init(hex: "#004C98"))
                })
                Text("Serie de inglés Help!")
                    .foregroundColor(Color.init(hex: "#004C98"))
                    .customFont(fontKey: .robotolight, size: 26)
                    .padding(.leading)
                Spacer()
            }
            .padding()
            Image("help_english")
                .frame(maxWidth: .infinity)
                .padding()
            ScrollView {
                VStack{
                    ForEach(options, id: \.self){ item in
                        NavigationLink(destination: viewModel.goToViewSelected(name: item), label: {EmptyView()
                            Text(item)
                                .frame(width: UIScreen.main.bounds.width, height: 50)
                        })
                    }
                    .background(RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(Color.white)
                        .padding(.horizontal, 20)
                                
                    )
                    .padding(.bottom, 5)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .background(Color.init(hex: "#F4F4F4").ignoresSafeArea())
    }
}

struct EnglishSeriesHelpView_Previews: PreviewProvider {
    static var previews: some View {
        EnglishSeriesHelpView()
    }
}
