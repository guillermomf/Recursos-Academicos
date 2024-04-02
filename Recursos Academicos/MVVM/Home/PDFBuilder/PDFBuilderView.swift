//
//  PDFBuilderView.swift
//  Recursos Academicos
//
//  Created by Gil casimiro on 14/03/24.
//

import SwiftUI
import SwiftUIX
import PDFKit

/// This view help us to open the PDF´s who lives in the APP
///
/// - Parameters:
///    - resourcesName: Name of the view
///    - resourceTitle: name of the PDF file

struct PDFBuilderView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var resourceName: String
    @State var resourceTitle: String
    var body: some View {
        VStack{
            VStack {
                if let url = Bundle.main.url(forResource: resourceTitle, withExtension: "pdf") {
                    PDFKitRepresentedView(url)
                        .padding(.horizontal)
                        .background(Color.init(hex: "#F4F4F4"))
                        .ignoresSafeArea(.all)
                } else {
                    Text("Error: PDF not found")
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct PDFBuilderView_Previews: PreviewProvider {
    static var previews: some View {
        PDFBuilderView(resourceName: "Sitios de interés recomendados", resourceTitle: "Ligas_software_gratuito")
    }
}

/// Funtion to help to open the PDF

struct PDFKitRepresentedView: UIViewRepresentable {
    let url: URL
    init(_ url: URL) {
        self.url = url
    }
    
    func makeUIView(context: UIViewRepresentableContext<PDFKitRepresentedView>) -> PDFKitRepresentedView.UIViewType {
        let pdfView = PDFView()
        pdfView.document = PDFDocument(url: self.url)
        pdfView.autoScales = true
        return pdfView
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PDFKitRepresentedView>) {
        // Update the view.
    }
}

