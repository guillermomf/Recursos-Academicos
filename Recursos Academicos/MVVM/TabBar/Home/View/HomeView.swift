//
//  HomeView.swift
//  Recursos Academicos
//
//  Created by Gil casimiro on 08/03/24.
//

import SwiftUI

struct HomeView: View {
    //Variables
    @StateObject var viewModel: HomeViewModel = HomeViewModel()
    @State var nameView: String = String()
    @State var trus: Bool = false
    
    var body: some View {
        ScrollView{
            VStack{
                HeaderHomeView()
                VStack{
                    if !viewModel.resourcesEmpty {
                        ForEach(viewModel.availableResources, id: \.self) { item in
                            ResourcesRowView(item: item)
                        }
                    } else {
                        Text("vacio")
                    }
                }
                .padding(20)
            }//VStack
            .padding(.horizontal)
        }//Scroll
        .background(Color.init(hex: "#F4F4F4")?.ignoresSafeArea())
        .onAppear{
            viewModel.onAppear()
        }
    }
}
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

