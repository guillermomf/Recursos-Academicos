//
//  SeriesHelpContentSeleted.swift
//  Recursos Academicos
//
//  Created by Gil casimiro on 22/03/24.
//

import SwiftUI
import Foundation
import AVKit

struct SeriesHelpContentSeleted: View {
    @StateObject var viewModel = ViewModel()
    @StateObject var vm: DownloadViewModel = .init()
    @State var title: String
    @State var itemSelected: String
    @State var isDownLoadTrue: Bool = Bool()
    
    var body: some View {
        ScrollView{
            VStack{
                NavigationBarCustom(title: title)
                    .padding()
                HStack{
                    VStack(alignment: .leading, spacing: 20){
                        Text(itemSelected)
                            .customFont(fontKey: .robotoBold, size: 20)
                            .foregroundColor(Color.init(hex: "#252B33"))
                        Text("Larousse - Help! - \(itemSelected)")
                            .customFont(fontKey: .robotoregular, size: 16)
                            .foregroundColor(Color.init(hex: "#252B33"))
                    }
                    Spacer()
                }
                .padding()
                    NavigationLink(destination: {ShowContentSelected()}, label: {
                        ButtonOrangeCustom(title: "Visualizar", image: "eye")
                    })
                    .padding(.vertical)
                downLoadToSeeOfflineComponent(title: "Descargar para ver Offline\(vm.progress)", isActiveDownLoad: vm.isDowloadLoading)
                    .padding(.vertical, 10)
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
    SeriesHelpContentSeleted(title: "Hola", itemSelected: "Secundaria")
}


//TODO: Remove this part when integrate the BACKEND
class ViewModel: ObservableObject {
    
    @Published var videos: [Videos] = []
    
    init() {
        Task.init{
            await findvideos()
        }
    }
    
    func findvideos () async {
        do {
            guard let url = URL(string: "https://api.pexels.com/videos/search?query=nature&per_page=10&oritation=portrait") else
            { fatalError ("Missing URL") }
            
            var urlRequest = URLRequest(url: url)
            
            urlRequest.setValue("9D41ucw1tzstUk7FHJZ5bM5JIRoMolUkZJAEjBmxrvxBGMGGc3Nsjufs",forHTTPHeaderField: "Authorization")
            
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error while fetching data") }
            
            let decoder = JSONDecoder ( )
            
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            let decodedData = try decoder.decode (ResponseBody.self, from: data)
            DispatchQueue.main.async {
                self.videos = []
                self.videos = decodedData.videos
                print(self.videos)
            }
        } catch {
            print ("Error fetching data from Pexels: \(error)")
        }
    }
}
struct ResponseBody: Decodable {
    var page: Int
    var perPage: Int
    var totalResults: Int
    var url: String
    var videos: [Videos]
}


struct Videos: Identifiable, Decodable {
    var id: Int
    var image: String
    var duration: Int
    var user: User
    var videoFiles: [VideoFiles]
    
    struct User: Decodable {
        var id: Int
        var name: String
        var url: String
    }
    struct VideoFiles: Decodable  {
        var id: Int
        var quality: String
        var fileType: String
        var link: String
    }
}
