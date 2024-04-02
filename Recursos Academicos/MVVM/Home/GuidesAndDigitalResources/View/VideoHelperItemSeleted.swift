//
//  VideoHelperItemSeleted.swift
//  Recursos Academicos
//
//  Created by Gil casimiro on 29/03/24.
//

import SwiftUI

struct VideoHelperItemSeleted: View {
    @StateObject var viewModel = ViewModel()
    @StateObject var vm: DownloadViewModel = .init()
    @State var title: String
    @State var video: Videos
    
    var body: some View {
        ScrollView{
            VStack{
                NavigationBarCustom(title: title)
                    .padding()
                HStack{
                    VStack(alignment: .leading, spacing: 20){
                        Text(video.user.name)
                            .customFont(fontKey: .robotoBold, size: 20)
                            .foregroundColor(Color.init(hex: "#252B33"))
                        Text("Duracion del video: \(video.duration)")
                            .customFont(fontKey: .robotoregular, size: 16)
                            .foregroundColor(Color.init(hex: "#252B33"))
                    }
                    Spacer()
                }
                .padding()
                NavigationLink(destination: VideoView(video: video), label: {
                    ZStack{
                        AsyncImage(url: URL(string: video.image)) { img in
                            img.resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 335, height: 150)
                                .cornerRadius(15)
                        } placeholder: {
                            Rectangle()
                                .foregroundStyle(Color.gray.opacity(0.3))
                                .frame(width: 335, height: 150)
                                .cornerRadius(15)
                        }
                        Image(systemName: "play.fill")
                            .foregroundStyle(Color.white)
                            .font(.title)
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(50)
                    }
                })
                //viewModel.isDownLoadTrue
                downLoadToSeeOfflineComponent(title: "Descargar para ver Offline\(vm.progress)", isActiveDownLoad: vm.isDowloadLoading)
                    .padding(.vertical, 10)
                    .onTapGesture {
                        if let urlVideo = video.videoFiles.first?.link {
//                            print("linkVideo\(video.videoFiles.first?.link)")
                            vm.downloadVideo(url: URL(string: urlVideo)!)
                        }
                    }
                Text("Al activar la casilla podrás visualizar el archivo aunque tu dispositivo no esté contectado a una red de internet.")
                    .customFont(fontKey: .robotoregular, size: 12)
                    .foregroundStyle(Color.init(hex: "#949494")!)
                    .padding(.horizontal)
            }
            
        }
        .padding(.horizontal)
        .background(GeneralBackground())
        .navigationBarBackButtonHidden(true)
        .alert(isPresented: $vm.showAlert) {
            Alert(
                title: Text(vm.succesMessage),
                message: Text(vm.succesMessage)
            )
        }
    }
}

#Preview {
    VideoHelperItemSeleted(title: String("hola"), video: Videos(id: 3571264, image: "https://images.pexels.com/videos/3571264/free-video-3571264.jpg?auto=compress&cs=tinysrgb&fit=crop&h=630&w=1200", duration: 33, user: Videos.User(id: 1498112, name: "Enrique Hoyos", url: "https://www.pexels.com/@enrique"), videoFiles: [Videos.VideoFiles(id: 9326361, quality: "sd", fileType: "video/mp4", link: "https://videos.pexels.com/video-files/3571264/3571264-sd_640_360_30fps.mp4")]))
}
