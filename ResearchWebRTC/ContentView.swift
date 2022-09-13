//
//  ContentView.swift
//  ResearchWebRTC
//
//  Created by Qlue on 08/09/22.
//

import SwiftUI
import WebRTC

struct SdpEntity: Codable  {
    let sdp: String?
}

struct ContentView: View {
    @ObservedObject var viewModel = ViewModel()

    var body: some View {
        VStack {
            VideoView(videoTrack: self.viewModel.remoteVideoTrack,refreshVideoTrack: Binding<Bool>(get: {return self.viewModel.refreshRemoteVideoTrack}, set: { p in self.viewModel.refreshRemoteVideoTrack = p})).background(.brown)

            Text("Status: \(viewModel.webRTCStatus)")
            Button("Start") {
                viewModel.start()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
