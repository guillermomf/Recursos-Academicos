//
//  VisualComponents.swift
//  Recursos Academicos
//
//  Created by Gil casimiro on 20/03/24.
//

import SwiftUI

///Custom navigation view to use arround application and the function to close the View is already apply
/// - Parameters:
///    - title:this will be the title of the view
///

struct NavigationBarCustom: View {
    @Environment(\.presentationMode) var presentationMode
    @State var title: String
    var body: some View {
        HStack{
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Image(systemName: "chevron.left")
                    .resizable()
                    .frame(width: 12, height: 20)
                    .foregroundColor(Color.init(hex: "#004C98"))
            })
            Text(title)
                .foregroundColor(Color.init(hex: "#004C98"))
                .customFont(fontKey: .robotolight, size: 26)
                .padding(.leading)
            Spacer()
        }
    }
}

///Same custom navigation view above but this will can use this one with two lines title to use arround application and the function to close the View is already apply
/// - Parameters:
///    - title:this will be the title of the view
///
///
struct NavigationBarCustomTwoLines: View {
    @Environment(\.presentationMode) var presentationMode
    @State var title: String
    @State var numberLines: Int = 2
    var body: some View {
        HStack{
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Image(systemName: "chevron.left")
                    .resizable()
                    .frame(width: 12, height: 20)
                    .foregroundColor(Color.init(hex: "#004C98"))
            })
            .padding(.bottom, 25)
            Text(title)
                .foregroundColor(Color.init(hex: "#004C98"))
                .customFont(fontKey: .robotolight, size: 26)
                .padding(.leading)
                .lineLimit(2)
            Spacer()
        }
    }
}

/// Background that you can use arround app
struct GeneralBackground: View {
    var body: some View {
        Color.init(hex: "#F4F4F4").ignoresSafeArea()
    }
}

/// This blue gradient button appear in the different sections in the app
/// - Parameters:
///    - title: This will be the title of the button
///    - image: Will be the image on the button
///
// TODO: Remove "systemName" of the Image

struct ButtonOrangeCustom: View {
    @State var title: String
    @State var image: String
    var body: some View{
        HStack{
            Image(systemName: "eye")
                .foregroundStyle(Color.white)
            Text(title)
                .foregroundColor(Color.white)
                .customFont(fontKey: .robotoBold, size: 16)
        }
        .background(
            RoundedCorner(radius: 16)
                .foregroundStyle(LinearGradient(colors: [Color.init(hex: "#FFC69F")!, Color.init(hex: "#FF5793")!], startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/))
                .frame(width: 335, height: 50)
        )
    }
}

/// This blue gradient button appear in the different sections in the app
/// - Parameters:
///    - title: This will be the title of the button
///    - image: Will be the image on the button
///
struct ButtonBlueCustom: View {
    @State var title: String
    @State var image: String
    var body: some View{
        HStack{
            Image(systemName: image)
            Text(title)
                .foregroundColor(Color.white)
                .customFont(fontKey: .robotoBold, size: 16)
        }
        .background(
            RoundedCorner(radius: 16)
                .foregroundStyle(LinearGradient(colors: [Color.init(hex: "#0083C9")!, Color.init(hex: "#004C98")!], startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/))
                .frame(width: 335, height: 50)
        )
    }
}

/// This blue gradient button appear in the different sections in the app
/// - Parameters:
///    - title: This will be the title of the button
///    - isActiveDownLoad: Will be the flag to check is we want download the file
///
struct downLoadToSeeOfflineComponent: View {
    @State var title: String
    @State var isActiveDownLoad: Bool
    var body: some View{
        HStack{
            Button(action: {
                isActiveDownLoad.toggle()
            }, label: {
                    Image(systemName: "checkmark")
                    .foregroundColor(.white)
            })
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.init(hex: "#E9E9E9")!, lineWidth: 1.5)                    
                    .frame(width: 30, height: 30)
                    .background((isActiveDownLoad ? Color.orange : Color.white) .cornerRadius(8))
            )
            Text(title)
                .foregroundColor(Color.init(hex: "#252B33"))
                .customFont(fontKey: .robotoregular, size: 16)
                .padding(.leading)
            Spacer()
            if isActiveDownLoad{
                ProgressView()
                    .scaleEffect(1.5, anchor: .center)
                    .progressViewStyle(CircularProgressViewStyle(tint: .orange))
                    .frame(width: 20, height: 20)
            }
        }
        .padding(.horizontal)
        .frame(width: 335, height: 50)
        .background(
            RoundedCorner(radius: 16)
                .foregroundStyle(Color.white)
                .frame(width: 335, height: 50)
                .shadow(color: Color.gray, radius: 5)
        )
    }
}

/// Search bar custom
///
/// - Parameters:
///  - textToSearch: text that we wnat to find
///

struct SearchBarCustom: View {
    @State var textToSearch: String
    var body: some View{
        HStack{
            HStack{
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(Color.init(hex: "#A09898")!)
                TextField("Buscar", text: $textToSearch)
            }
            .padding(.leading)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .foregroundStyle(Color.white)
                    .frame(height: 50)
            )
            Image(systemName: "slider.horizontal.3")
                .foregroundStyle(Color.white)
                .frame(width: 50, height: 50)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundStyle(LinearGradient(colors: [Color.init(hex: "#B47AED")!, Color.init(hex: "#FF5793")! ], startPoint: .leading, endPoint: .trailing))
                        .frame(width: 50, height: 50)
                )
        }
    }
}
struct VisualComponents_Previews: PreviewProvider {
    static var previews: some View {
//        NavigationBarCustom(title: String())
//        ButtonBlueCustom(title: String("hola"), image: "eye")
//        downLoadToSeeOfflineComponent(title: "hola", isActiveDownLoad: false)
//        NavigationBarCustomTwoLines(title: "hola\n hola")
        SearchBarCustom(textToSearch: String())
    }
}
