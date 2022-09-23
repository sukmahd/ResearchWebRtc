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
        GeometryReader { geometry in
        VStack {
            if #available(iOS 15.0, *) {
                VideoView(videoTrack: viewModel.remoteVideoTrack,refreshVideoTrack: Binding<Bool>(get: {return viewModel.refreshRemoteVideoTrack}, set: { p in viewModel.refreshRemoteVideoTrack = p})).background(Color.brown)
            } else {
                VideoView(videoTrack: viewModel.remoteVideoTrack,refreshVideoTrack: Binding<Bool>(get: {return viewModel.refreshRemoteVideoTrack}, set: { p in viewModel.refreshRemoteVideoTrack = p})).frame(width: 100, height: 100)
                // Fallback on earlier versions
            }
//            WebView(url: URL(string: "http://unity-stg.qlue.ai:12400/QVAIM/live_webrtc?company_id=4f5ec182-e22e-11ec-93ae-0ae178bd1794&feed_name=VCC_Kecapi_1661769603224&engine_name=vehicle_counting_classification_engine&resolution=720")!)

            Text("Status: \(viewModel.webRTCStatus)")
            Text("Video Status: \(viewModel.refreshRemoteVideoTrack ? "True": "False") ")
            Button("Start") {
                viewModel.start()
            }
            Button("offer") {
                viewModel.offer()
            }
        }
    }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
