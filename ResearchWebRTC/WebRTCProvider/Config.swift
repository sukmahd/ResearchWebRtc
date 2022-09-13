//
//  Config.swift
//  ResearchWebRTC
//
//  Created by Qlue on 08/09/22.
//

import Foundation

fileprivate let defaultSignalingServerUrl = URL(string: "https://unity-stg.qlue.ai:2501/offer")!

// We use Google's public stun servers. For production apps you should deploy your own stun/turn servers.
fileprivate let defaultIceServers = ["stun:stun.l.google.com:19302"]

struct Config {
    let signalingServerUrl: URL
    let webRTCIceServers: [String]
    
    static let `default` = Config(signalingServerUrl: defaultSignalingServerUrl, webRTCIceServers: defaultIceServers)
}
