//
//  TabBarView.swift
//  Recursos Academicos
//
//  Created by Gil casimiro on 08/03/24.
//

import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView {
            NavigationView{
                HomeView()
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .tabItem({
                Image("icon-home")
                    .renderingMode(.template)
                    .foregroundColor(Color.init(hex: "#004C98"))
                Text("Inicio")
            })
            
            Text("Cursos")
            //TODO: Check asset of courses
                .tabItem({
                    Image("icon-home")
                        .renderingMode(.template)
                        .foregroundColor(Color.init(hex: "#004C98"))
                    Text("Cursos")
                })
            NavigationView{
                DetailAccountView()
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .tabItem({
                //                        TabBarCustom()
                Image("icon-user")
                    .renderingMode(.template)
                    .foregroundColor(Color.init(hex: "#004C98"))
                Text("Perfil")
            })
            
        }
        .accentColor(Color.init(hex: "#23294C"))
        .onAppear{
            UITabBar.appearance().backgroundColor = UIColor(named: "background_tabbar")
            SecuritySrv.getUserProfileImage{ (result, string) in
                if result {
                    print("profile image loaded")
                } else {
                    print("unable to load profile image")
                }
            }
        }
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}



