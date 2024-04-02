//
//  ShowContentSelected.swift
//  Recursos Academicos
//
//  Created by Gil casimiro on 23/03/24.
//

import SwiftUI

struct ShowContentSelected: View {
    var body: some View {
            VStack{
                NavigationBarCustom(title: "Regresar")
                    .padding(.horizontal)
                PDFBuilderView(resourceName: "Aplicaciones recomendadas", resourceTitle: "Ligas_software_gratuito")
            }
        .navigationBarBackButtonHidden(true)
        .background(GeneralBackground())
    }
}

#Preview {
    ShowContentSelected()
}
