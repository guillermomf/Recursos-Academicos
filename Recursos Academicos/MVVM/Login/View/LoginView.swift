//
//  LoginView.swift
//  Recursos Academicos
//
//  Created by Gil casimiro on 07/03/24.
//

import SwiftUI
import WebKit
import PDFKit

struct LoginView: View {
    @StateObject private var viewModel: LoginViewModel = LoginViewModel()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center){
                Image("logo_ra_login")
                    .resizable()
                    .frame(width: 150, height: 135)
                    .padding()
                    .padding(.bottom, 119)
                //TextField Usuario
                TextField("Usuario", text: $viewModel.user) {_ in
                    print(viewModel.user)
                }
                .customFont(fontKey: .robotoregular, size: 16)
                .foregroundColor(Color.init(hex: "#404547"))
                .padding(.horizontal, 20)
                .frame(width: 335, height: 50)
                .background(Color.init(hex: "#EFEFEF"))
                .cornerRadius(25)
                
                //TextField Password
                VStack(spacing: 10){
                    if !viewModel.showPassword {
                        HStack {
                            SecureField("Contraseña", text: $viewModel.password)
                                .onChange(of: viewModel.password, perform: {_ in
                                    print(viewModel.password)
                                })
                                .customFont(fontKey: .robotoregular, size: 16)
                                .foregroundColor(Color.init(hex: "#404547"))
                            Button(action: {
                                viewModel.showPassword.toggle()
                            }, label: {
                                Image(systemName: "eye")
                                    .foregroundColor(Color.init(hex: "#C6C6C6"))
                            })
                        }
                        .padding(.horizontal, 20)
                        .frame(width: 335, height: 50)
                        .background(Color.init(hex: "#EFEFEF"))
                        .cornerRadius(25)
                    } else {
                        HStack{
                            TextField("Contraseña", text: $viewModel.password, onEditingChanged: {_ in
                                print(viewModel.password)
                            })
                            .customFont(fontKey: .robotoregular, size: 16)
                            .foregroundColor(Color.init(hex: "#404547"))
                            Button(action: {
                                viewModel.showPassword.toggle()
                            }, label: {
                                Image(systemName: "eye.slash")
                                    .foregroundColor(Color.init(hex: "#C6C6C6"))
                            })
                            
                        }
                        .padding(.horizontal, 20)
                        .frame(width: 335, height: 50)
                        .background(Color.init(hex: "#EFEFEF"))
                        .cornerRadius(25)
                    }
                    Button(action: {
                        viewModel.showLoader = true
                        viewModel.isLoading = true
//                        viewModel.userLogIn(username: viewModel.user, password: viewModel.password)
//                        viewModel.userLogIn(username: "recursosacademicosra@gmail.com", password: "portal19")
                          viewModel.userLogIn(username: "vacosta@larousse.com.mx", password: "raAdmin08@")
                        print("Button Action")
                    }, label: {
                        HStack{
                            Text("Entrar")
                                .customFont(fontKey: .robotoBold, size: 18)
                            Spacer()
                            Image(systemName: "arrow.right")
                                .foregroundColor(.white)
                                .frame(width: 22, height: 24)
                        }
                        .padding(.horizontal, 20)
                    })
                    .frame(width: 335, height: 50)
                    .background(Color.init(hex: "#23294C"))
                    .cornerRadius(25)
                    .foregroundColor(.white)
                    //                    Button(action: {
                    //                        print("Button Recupera")
                    //                    }, label: {
                    //                        Text("Recuperar contraseña")
                    //                            .underline()
                    //                            .foregroundColor(Color.init(hex: "#404547"))
                    //                            .customFont(fontKey: .robotoMedium, size: 14)
                    //                    })
                }//VStack Password
                .padding(.bottom, 93)
                VStack{
                    Image("logo_hachette")
                }.padding(.bottom, 30)
                
                Button(action: {
                    viewModel.showPrivacityNotice.toggle()
                }, label: {
                    Text("Aviso de privaciad")
                        .foregroundColor(Color.init(hex: "#404547"))
                        .customFont(fontKey: .robotoregular, size: 14)
                })
            }//VStack
        }//Scroll
        .background(Color.white)
        .padding(20)
        .sheet(isPresented: $viewModel.showPrivacityNotice, content: {
            PrivacityNotice()
        })
        .overlay{
            if viewModel.showLoader {
                VStack{
                    Arcs(isAnimating: $viewModel.isLoading, count: 4, width: 50, spacing: 10)
                        .frame(width: 200, height: 200)
                        .foregroundColor(Color.init(hex: "#23294C"))
                }
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .background(Color.gray.opacity(0.5))
                .ignoresSafeArea()
                //                                ActivityIndicator(isAnimating: $viewModel.isLoading, style: .medium)
            }
        }
        .fullScreenCover(isPresented: $viewModel.goToTabBar, content: {TabBarView()})
    }//Body
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

struct ActivityIndicator: UIViewRepresentable {
    
    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style
    
    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}

struct PrivacityNotice: View {
    var body: some View {
        ScrollView {
            VStack{
                Image("privacy_policy")
                    .resizable()
            }
        }
    }
}

struct Arcs: View {
    @Binding var isAnimating: Bool
    let count: UInt
    let width: CGFloat
    let spacing: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            ForEach(0..<Int(count)) { index in
                item(forIndex: index, in: geometry.size)
                    .rotationEffect(isAnimating ? .degrees(360) : .degrees(0))
                    .animation(
                        Animation.default
                            .speed(Double.random(in: 0.2...0.5))
                            .repeatCount(isAnimating ? .max : 1, autoreverses: false)
                    )
            }
        }
        .aspectRatio(contentMode: .fit)
    }
    
    private func item(forIndex index: Int, in geometrySize: CGSize) -> some View {
        Group { () -> Path in
            var p = Path()
            p.addArc(center: CGPoint(x: geometrySize.width/2, y: geometrySize.height/2),
                     radius: geometrySize.width/2 - width/2 - CGFloat(index) * (width + spacing),
                     startAngle: .degrees(0),
                     endAngle: .degrees(Double(Int.random(in: 120...300))),
                     clockwise: true)
            return p.strokedPath(.init(lineWidth: width))
        }
        .frame(width: geometrySize.width, height: geometrySize.height)
    }
}
