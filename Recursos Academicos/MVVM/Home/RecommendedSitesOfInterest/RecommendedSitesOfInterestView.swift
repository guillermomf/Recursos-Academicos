//
//  RecommendedSitesOfInterestView.swift
//  Recursos Academicos
//
//  Created by Gil casimiro on 08/03/24.
//

import SwiftUI
import WebKit
import SwiftUIX
import PDFKit

//struct PDFBiulderView: View {
//    @Environment(\.presentationMode) var presentationMode
//    @State var esourceName: String
//    @State var esourceTitle: String
//    
//    
//    var body: some View {
//        VStack{
//            HStack{
//                Button(action: {
//                    presentationMode.wrappedValue.dismiss()
//                }, label: {
//                    Image(systemName: "chevron.left")
//                        .resizable()
//                        .frame(width: 12, height: 20)
//                        .foregroundColor(Color.init(hex: "#004C98"))
//                })
//                .padding(.bottom, 25)
//                Text(resourceName)
//                    .foregroundColor(Color.init(hex: "#004C98"))
//                    .customFont(fontKey: .robotolight, size: 26)
//                    .padding(.leading)
//                Spacer()
//            }
//            .padding()
//            showPDF(resourceTitle: resourceTitle)
//        }
//        .navigationBarBackButtonHidden(true)
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        PDFBiulderView(resourceName: "Sitios de interes recomendados", resourceTitle: "ligas_de_interes")
//    }
//}
//
///// Parameters:
//
//@ViewBuilder
//func showPDF(resourceTitle: String) -> some View {
//    if let pdfURL = Bundle.main.url(forResource: resourceTitle, withExtension: "pdf"),
//       let pdfDocument = PDFDocument(url: pdfURL) {
//        PDFKitView(showing: pdfDocument)
//    } else {
//        Text("Error: PDF not found")
//    }
//}
