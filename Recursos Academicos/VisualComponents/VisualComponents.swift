//
//  VisualComponents.swift
//  Recursos Academicos
//
//  Created by Gil casimiro on 20/03/24.
//

import SwiftUI
import SwiftUIX

// MARK: Navigations view

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
        }.padding(.top)
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

// MARK: Buttons

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

/// This gradient button appear in the different sections in the app
/// - Parameters:
///    - title: This will be the title of the button, string type
///    - colorOne: Color in hexadecimal, string type
///    - colorTwo: Color in hexadecimal, string type
struct ButtonGradientCustom: View {
    @State var title: String
    @State var colorOne: String
    @State var colorTwo: String
    @State var width: CGFloat
    @State var height: CGFloat
    var body: some View{
        HStack{
            Text(title)
                .frame(width: width, height: height)
        }
        .background(
            RoundedCorner(radius: 16)
                .foregroundStyle(LinearGradient(colors: [Color.init(hex: colorOne)!, Color.init(hex: colorTwo)!], startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/))
                .frame(width: width, height: height)
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

// MARK: Search bar

/// Search bar custom
///
/// - Parameters:
///  - textToSearch: text that we want to find
///
struct SearchBarCustomWithFilter: View {
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

/// Search bar custom
///
/// - Parameters:
///  - textToSearch: text that we want to find
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
        }
    }
}

// MARK: Text fields and interactives fields

/// TextField custom
///
/// - Parameters:
///  - text: text
///
struct TextFieldCustom: View {
    @Binding var text: String
    @State var placeHolder: String
    var body: some View{
        VStack{
            TextField(placeHolder, text: $text)
                .customFont(fontKey: .robotoregular, size: 17)
                .foregroundColor(Color.init(hex: "#444444"))
        } .padding(16)
            .frame(height: 50)
            .background(Color.init(hex: "#F4F4F4")!)
            .cornerRadius(15)
    }
}

/// Field interantive custom
///
/// - Parameters:
///  - name: text
///  - imageName: image name icon
///  - actionButton: Action to do in the field
///  - optionArray: array of options
///  - isSelected: bool to know if show the options
struct InteractiveFieldCustom: View {
    @State var actionButton: () -> Void
    @Binding var name: String
    @State var imageName: String
    @State var optionArray: [String]
    @Binding var isSelected: Bool
    @State var picker: String = String()
    var body: some View{
        VStack {
            HStack{
                Text(name)
                    .customFont(fontKey: .robotoregular, size: 17)
                    .foregroundColor(Color.init(hex: "#444444"))
                Spacer()
                Image(systemName: "chevron.down")
            } .padding(16)
                .frame(height: 50)
            if isSelected {
                VStack {
                    ForEach(optionArray, id: \.self) { index in
                        HStack {
                            Circle()
                                .foregroundStyle(Color.blue)
                                .frame(width: 20, height: 20)
                            Text(index)
                            Spacer()
                        }
                        .onTapGesture{
                            name = index
                            isSelected.toggle()
                        }
                    }
                }.padding()
            }
        }.background(
            RoundedRectangle(cornerRadius: 15)
                .border(Color.init(hex: "#E9E9ED")!, width: 1, cornerRadius: 15)
                .foregroundStyle(Color.white)
        )
        .onTapGesture {
            actionButton()
        }
    }
}

///
/// Calendar picker custom
/// - Parameters:
///  - name: This will be the placeholder and the date that you want. String type
///  - date: The date select to show and send. Date type
///
struct CalendarFieldCustom: View {
    @Binding var name: String
    @Binding var date: Date
    var body: some View{
        HStack{
            TextField("", text: $name)
                .customFont(fontKey: .robotoregular, size: 17)
                .foregroundStyle(Color.init(hex: "#444444")!)
                .disabled(true)
            Spacer()
            Image(systemName: "calendar")
                .background(
                    Color.init(hex: "#F4F4F6")
                        .frame(width: 51 ,height: 50)
                        .cornerRadius([.topTrailing, .bottomTrailing], 15)
                )
        } .padding(16)
            .frame(height: 50)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .border(Color.init(hex: "#E9E9ED")!, width: 1, cornerRadius: 15)
                    .foregroundStyle(Color.white)
            )
            .overlay{
                DatePicker(
                    "",
                    selection: $date,
                    displayedComponents: [.date]
                )
                .blendMode(.destinationOver)
                .onChange(of: date, perform: {_ in
                    name = formatDateToString(date: date, format: "yyyy-MM-dd")
                })
            }
    }
}

struct VisualComponents_Previews: PreviewProvider {
    static var previews: some View {
        //        NavigationBarCustom(title: String())
        //        ButtonBlueCustom(title: String("hola"), image: "eye")
        //        ButtonGradientCustom(title: "test", colorOne: "#BD76E2", colorTwo: "FF5793", width: 100, height: 50)
        //        downLoadToSeeOfflineComponent(title: "hola", isActiveDownLoad: |false)
        //        NavigationBarCustomTwoLines(title: "hola\n hola")
        //        SearchBarCustom(textToSearch: String())
        //        TextFieldCustom(text: "", placeHolder: "Write here")
        InteractiveFieldCustom(actionButton: {print("hola")}, name: .constant("Hola"), imageName: "chevron.down", optionArray: ["hola", "adios"], isSelected: .constant(true))
    }
}
