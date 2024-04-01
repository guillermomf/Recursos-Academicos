//
//  GuidesView.swift
//  Recursos Academicos
//
//  Created by Gil casimiro on 20/03/24.
//

import SwiftUI

struct GuidesView: View {
    var body: some View {
        VStack{
            NavigationBarCustom(title: "Guías")
        }.navigationBarBackButtonHidden(true)
       
    }
}

struct GuidesView_Previews: PreviewProvider {
    static var previews: some View {
        GuidesView()
    }
}
