//
//  SolutionsView.swift
//  Recursos Academicos
//
//  Created by Gil casimiro on 20/03/24.
//

import SwiftUI

struct SolutionsView: View {
    var body: some View {
        VStack{
            NavigationBarCustom(title: "Solucionarios")
        }.navigationBarBackButtonHidden(true)
    }
}

struct SolutionsView_Previews: PreviewProvider {
    static var previews: some View {
        SolutionsView()
    }
}
