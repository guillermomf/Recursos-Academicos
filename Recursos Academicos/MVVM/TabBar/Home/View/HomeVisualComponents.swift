//
//  ResourcesRowView.swift
//  Recursos Academicos
//
//  Created by Gil casimiro on 08/03/24.
//

import SwiftUI

// this View help to show the rows in the list in HomeView
struct ResourcesRowView: View {
    @State var item: String
    @StateObject var viewModel: HomeViewModel = HomeViewModel()
    var body: some View {
        NavigationLink(destination: {viewModel.goToViewSelected(name: item)}, label: {
            HStack{
                Image(systemName: "square.grid.3x1.folder.fill.badge.plus")
                    .padding(.trailing, 25)
                    .frame(width: 40, height: 40)
                
                Text(item)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(Color.init(hex: "#252B33"))
                    .customFont(fontKey: .robotoregular, size: 18)
                Spacer()
                Image(systemName: "chevron.right")
                    .frame(width: 12, height: 30)
                    .foregroundColor(Color.init(hex: "004C98"))
            }
            .frame(height: 50)
            .background(Color.init(hex: "#F4F4F4"))
        })
        
    }
}
// This is the header of the HomeView
struct HeaderHomeView: View {
    var body: some View{
            VStack{
                HStack{
                    Image("logo_ra_login")
                        .resizable()
                        .frame(width: 50, height: 50)
                    Spacer()
                }
                .padding(.top, 40)
                HStack{
                    VStack{
                        Text("Bienvenido, ")
                            .foregroundColor(Color.init(hex: "004C98"))
                            .customFont(fontKey: .robotolight, size: 45)
                        Text(UserDefaults.standard.string(forKey: Settings.userFullNameKey) ?? "")
                            .foregroundColor(Color.init(hex: "004C98"))
                            .customFont(fontKey: .robotolight, size: 20)
                    }
                    Spacer()
                }
                .padding(.top)
            }
    }
}
// TODO: Analyze this component for tabBar
struct TabBarCustom: View {
    var body: some View{
        Button(action: {
            
        }, label: {
            GeometryReader { geo in
            Rectangle()
                .foregroundColor(Color.init(hex: "23294C"))
                .frame(width: geo.size.width/2, height: 4)
                .padding(.leading, geo.size.width/4)
            VStack(alignment: .center, spacing: 4) {
                Image(systemName: "person")
                    .foregroundColor(Color.init(hex: "23294C"))
                    .padding(.top)
                Text("Perfil")
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        })
       
    }
}

struct ResourcesRowView_Previews: PreviewProvider {
    static var previews: some View {
//        ResourcesRowView(item: String()
        TabBarCustom()
    }
}
