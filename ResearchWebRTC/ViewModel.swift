//
//  ViewModel.swift
//  ResearchWebRTC
//
//  Created by Qlue on 09/09/22.
//

import Foundation
import SwiftUI
import WebRTC

class ViewModel: ObservableObject {
    @Published var webRTCStatus = ""
    @Published var refreshRemoteVideoTrack: Bool = false
    @Published var remoteVideoTrack : RTCVideoTrack?
    private let config = Config.default
    private var hasLocalSdp: Bool = false
    private var hasRemoteSdp: Bool = false
    private var webRTCClient: WebRTCClient?
    private var remoteSdp: RTCSessionDescription?
    private var localSdp: RTCSessionDescription?

    func start() {
        prepare()
    }
    
    private func prepare() {
        webRTCClient = WebRTCClient(iceServers: self.config.webRTCIceServers)
        webRTCClient?.delegate = self
        offer()
    }
    
    func offer() {
        webRTCClient?.offer {[weak self] (sdp) in
            self?.localSdp = sdp
            self?.offerToServer(sdp: sdp)
        }
//            remoteVideoTrack = self.webRTCClient?.remoteVideoTrack
//            refreshRemoteVideoTrack = true
        
    }
    
    private func setAnswer(sdp: String?) {
        guard let sdp = sdp else {
            return
        }

        let newSdp = RTCSessionDescription(type: .answer, sdp: sdp)
        remoteSdp = newSdp
        print("answer sdp => \(sdp)")
        webRTCClient?.set(remoteSdp: newSdp) { (error) in
            print("error here => \(error)")
        }
    }
    
    private func offerToServer(sdp: RTCSessionDescription) {
        let demoUrl = "http://unity-stg.qlue.ai:12400/offer"
        let devUrl = "http://dev-vision.qlue.id:12500/offer"
        let stgUrl = "https://vision-moratelindo.qlue.ai:2500/offer"
        
        guard let url = URL(string: stgUrl) else {
            print("Your API end point is Invalid")
            return
        }
        
    
        //Mark: Demo Body
//        let body: [String: Any] = [
//            "company_id":"4f5ec182-e22e-11ec-93ae-0ae178bd1794",
//            "engine_name":"vehicle_counting_classification_engine",
//            "feed_name":"VCC_Kecapi_1661769603224",
//            "resolution":"None",
//            "type": "offer",
//            "sdp" : sdp.sdp,
//        ]
//
        
        let body: [String: Any] = [
            "type": "offer",
            "feed_name": "Jalan_Tun_Sambanthan_1660883156247",
            "engine_name": "vehicle_counting_classification_engine",
            "company_id": "e4525a60-a999-11ec-a201-0ae178bd1794",
            "resolution": "None",
            "sdp" : sdp.sdp,
        ]
        
        
        
//        let body: [String: Any] = [
//            "company_id": "30d55858-1b1f-0a10-a942-8000021623e7",
//            "engine_name": "dummy_engine",
//            "feed_name": "test_0",
//            "resolution" : "None",
//            "type": "offer",
//            "sdp" : sdp.sdp,
//        ]
        
//        print("sdp data: ----> \(sdp.debugDescription)")
        let jsonData = try? JSONSerialization.data(withJSONObject: body)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("\(String(describing: jsonData?.count))", forHTTPHeaderField: "Content-Length")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            
            let responseData = String(data: data, encoding: String.Encoding.utf8)
            print("response data => \(responseData ?? "no data")")
            
            if let response = try? JSONDecoder().decode(SdpEntity.self, from: data) {
                DispatchQueue.main.async {
                    self.setAnswer(sdp: response.sdp)
                }
                return
            }
        }
        task.resume()
    }
}

extension ViewModel: WebRTCClientDelegate {
    func webRTCCLient(_ client: WebRTCClient, didAdd stream: RTCMediaStream) {
        DispatchQueue.main.async {
            self.remoteVideoTrack = stream.videoTracks.first
            self.refreshRemoteVideoTrack = true
        }
    }
    
    func webRTCCLient(_ client: WebRTCClient, didIceGatheringState state: RTCIceGatheringState) {
        if(state == .complete) {
            guard let sdp = localSdp else {
                return
            }
//            offerToServer(sdp: sdp)
        }
    }
    
    func webRTCClient(_ client: WebRTCClient, didDiscoverLocalCandidate candidate: RTCIceCandidate) {
        print("discover candidate => \(candidate.debugDescription)")
    //        webRTCClient?.set(remoteCandidate: candidate, completion: { error in
//            print("error candidate -> \(error.debugDescription)")
//        })
    }
    
    func webRTCClient(_ client: WebRTCClient, didChangeConnectionState state: RTCIceConnectionState) {
        print("connection State => \(state)" )
        DispatchQueue.main.async {
//        if (state == .connected) {
//            self.remoteVideoTrack = self.webRTCClient?.remoteVideoTrack
//            self.refreshRemoteVideoTrack = true
//        }
            self.webRTCStatus = state.description.capitalized
        }
    }
    
    func webRTCClient(_ client: WebRTCClient, didReceiveData data: Data) {
        print("receive data")
    }
}
