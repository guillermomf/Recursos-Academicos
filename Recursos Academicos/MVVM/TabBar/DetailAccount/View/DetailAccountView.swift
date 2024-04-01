//
//  DetailAccountView.swift
//  Recursos Academicos
//
//  Created by Gil casimiro on 11/03/24.
//

import SwiftUI

struct DetailAccountView: View {
    @StateObject var viewModel: AccountViewModel = AccountViewModel()
    var body: some View {
        VStack{
            AsyncImage(url: URL(string: viewModel.userImage)) { image in
                image.image?
                    .resizable()
                    .cornerRadius(100)
                    .frame(width: 194, height: 194)
                    .background(
                        Circle()
                            .stroke(Color.white, lineWidth: 5)
                    )
                    .padding(.top, 70)
                    .padding(.bottom, 14)
            }
            Group{
                Text(UserDefaults.standard.string(forKey: Settings.userFullNameKey) ?? "")
                    .foregroundColor(Color.init(hex: "#252B33"))
                    .customFont(fontKey: .robotoBold, size: 25)
                Text(UserDefaults.standard.string(forKey: Settings.userRoleKey) ?? "")
                    .foregroundColor(Color.init(hex: "#23294C"))
                    .customFont(fontKey: .robotoregular, size: 14)
            }
            
            List(viewModel.actionsMenuAccount, id: \.self) {item in
                ZStack{
                    NavigationLink(destination: viewModel.goToViewSelected(name: item), label: {
                        EmptyView()
                    }).opacity(0.0)
                    HStack{
                        Text(item)
                            .customFont(fontKey: .robotoregular, size: 16)
                            .foregroundColor(Color.init(hex: "#444444"))
                        Spacer()
                        Image(viewModel.getIconAction(action: item))
                            .frame(width: 24, height: 19)
                            .foregroundColor(Color.init(hex: "#004C98"))
                    }
                    .padding(.vertical, 8)
                }
            }
            .padding(.horizontal)
            VStack{
                Image("logo-hachette")
                    .resizable()
                    .frame(width: 87, height: 25)
                Text("Copyright © Todos los Derechos Reservados 2024.")
                    .customFont(fontKey: .robotoregular, size: 12)
                    .foregroundColor(Color.init(hex: "#A0A0A0"))
            }
        }
        .padding(.bottom)
        .background(
            ZStack{
                Color.init(hex: "#F4F4F4")
                VStack{
                    LinearGradient(colors: [Color.init(hex: "#FFC69F")!,Color.init(hex: "#FF5793")!], startPoint: .leading, endPoint: .trailing)
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 4)
                    Spacer()
                }
            }.ignoresSafeArea()
        )
        .onAppear{
            viewModel.onAppear()
        }
    }
}


struct DetailAccountView_Previews: PreviewProvider {
    static var previews: some View {
        DetailAccountView()
    }
}

