//
//  VideoView.swift
//  ResearchWebRTC
//
//  Created by Qlue on 12/09/22.
//

import Foundation
import SwiftUI
import WebRTC

struct VideoView: UIViewRepresentable {
    let videoTrack: RTCVideoTrack?
    @Binding var refreshVideoTrack: Bool
    //RTCNSGLVideoView
    //RTCMTLNSVideoView
    func makeUIView(context: Context) -> RTCMTLVideoView {
        let view = RTCMTLVideoView(frame: .zero)
        view.videoContentMode = .scaleAspectFit
        return view
    }

    func updateUIView(_ view: RTCMTLVideoView, context: Context) {
        if(refreshVideoTrack){
            videoTrack?.add(view)
            refreshVideoTrack = false
        }

    }
}
