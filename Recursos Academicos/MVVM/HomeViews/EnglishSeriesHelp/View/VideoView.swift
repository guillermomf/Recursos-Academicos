//
//  VideoView.swift
//  Recursos Academicos
//
//  Created by Gil casimiro on 27/03/24.
//

import SwiftUI
import AVKit

struct VideoView: View {
    var video: Videos
    @State var player = AVPlayer()
    var body: some View {
        VideoPlayer(player: player)
            .edgesIgnoringSafeArea(.all)
            .onAppear{
                if let link = video.videoFiles.first?.link {
                    player = AVPlayer(url: URL(string: link)!)
                    player.play()
                }
            }
    }
}

#Preview {
    VideoView(video: Videos(id: 1, image: String(), duration: 0, user: Videos.User(id: 0, name: "", url: ""), videoFiles: []))
}
