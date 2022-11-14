//
//  ConnectionManager.swift
//  BestStudies
//
//  Created by Jack Si on 11/8/22.
//

import Foundation
import MultipeerConnectivity
import FirebaseAuth


class ConnectionManager: NSObject {
    private static let service = "bs-session"
    let myPeerId = MCPeerID(displayName: AuthManager.shared.getCurrentEmail())

    private var advertiserAssistant: MCNearbyServiceAdvertiser?
    private var session: MCSession?
    var connectedPeers:[MCPeerID] = [] {
        didSet {
            DispatchQueue.main.async {
                self.membersTableView?.reloadData()
            }
        }
    }

    var membersTableView:UITableView?
    var waitingRoomViewController:UIViewController?
    var homeViewController: UIViewController?
    var sessionViewController: SessionViewController?
    var isHosting = false
    
    var isStopwatch: Bool?
    var remainingTime: TimeInterval?
    
    func join() {
        connectedPeers = [self.myPeerId]
        session = MCSession(peer: myPeerId, securityIdentity: nil, encryptionPreference: .none)
        session?.delegate = self
        guard let session = session else {
            return
        }
                
        let mcBrowserViewController = MCBrowserViewController(serviceType: ConnectionManager.service, session: session)
        mcBrowserViewController.delegate = self
        homeViewController!.present(mcBrowserViewController, animated: true)
    }
    
    func host() {
        connectedPeers = [self.myPeerId]
        isHosting = true
        session = MCSession(peer: myPeerId, securityIdentity: nil, encryptionPreference: .none)
        session?.delegate = self
        
        advertiserAssistant = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: nil, serviceType: ConnectionManager.service)
        advertiserAssistant?.delegate = self
        advertiserAssistant?.startAdvertisingPeer()
    }
    
    func leave() {
        advertiserAssistant?.stopAdvertisingPeer()
        
        if isHosting {
            send(message: "Host left")
        }
        
        session = nil
        isHosting = false
        advertiserAssistant = nil
        isStopwatch = nil
        remainingTime = nil
        
        self.sessionViewController?.dismiss(animated: true)
        self.waitingRoomViewController?.dismiss(animated: true)
    }
    
    func send(message: String) {
        let data: Data? = "\(message)".data(using: .utf8)
        
        if message == "Start" {
            self.advertiserAssistant?.stopAdvertisingPeer()
        }
        
        if session!.connectedPeers.count > 0 {
            do {
                try session!.send(data!, toPeers: session!.connectedPeers, with: .reliable)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func send(message: String, destination: [MCPeerID]) {
        let data: Data? = "\(message)".data(using: .utf8)

        do {
            try session!.send(data!, toPeers: destination, with: .reliable)
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension ConnectionManager: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            print("\(peerID.displayName) connected")
            connectedPeers = session.connectedPeers
            connectedPeers.insert(self.myPeerId, at: 0)
            
            // Informs other devices session info
            if isHosting {
                if !isStopwatch! {
                    send(message: "!\(String(describing: isStopwatch!)),\(String(describing: remainingTime!))", destination: [peerID]) // Format of this message is "!isStopwatch,remainingTime"
                } else {
                    send(message: "!\(String(describing: isStopwatch!))", destination: [peerID])
                }

                print("\(isStopwatch), \(remainingTime)")
                
            }
//            send(message: "!\(String(describing: isStopwatch));\(String(describing: remainingTime))", destination: [peerID])
        case .connecting:
            print("\(peerID.displayName) connecting")
            
        case .notConnected:
            let sessionVC = sessionViewController as? SessionViewController
            print("\(peerID.displayName) not connected")
            connectedPeers = session.connectedPeers
            connectedPeers.insert(self.myPeerId, at: 0)
            
            // TODO: JANKY WAY TO REMOVE session members who left (and are not host)
            sessionVC?.members = connectedPeers
            
            sessionVC?.updatingVariables(index: (sessionVC?.indexDict![peerID])!)
        @unknown default:
            print("Unknown state: \(state)")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        let str = String(data: data, encoding: .utf8)
        
        if (str == "Host left") {
            DispatchQueue.main.async {
                
                self.sessionViewController?.leavePressed(UIButton())
                // TODO: Dismiss sessionviewcontroller?
                self.sessionViewController?.dismiss(animated: true)
                self.waitingRoomViewController?.dismiss(animated: true)
            }
        } else if (str![str!.startIndex] == "!") {
            let delimiterIndex = str!.firstIndex(of: ",") ?? str!.endIndex
            let firstIndex = str!.index(str!.startIndex, offsetBy: 1)
            print("\(str![firstIndex..<delimiterIndex])")
            let isStopwatchStr = String(str![firstIndex..<delimiterIndex])
            isStopwatch = Bool(isStopwatchStr)
            
            if !isStopwatch! {
                let afterDelimiterIndex = str!.index(delimiterIndex, offsetBy: 1)
                print("\(str![afterDelimiterIndex..<str!.endIndex])")
                remainingTime = Double(str![afterDelimiterIndex..<str!.endIndex])
            }
            
            //  print("\(remainingTime),\(isStopwatch)")
        } else if (str == "Start") {
            DispatchQueue.main.async {
                self.waitingRoomViewController!.performSegue(withIdentifier: "SessionSegueIdentifier", sender: nil)
            }
        } else if (str == "False") {
            let sessionVC = sessionViewController as? SessionViewController
            // peerID -> sessionvc dict will return index which used to update bool array
            sessionVC!.updateOtherDeviceStatus(index: sessionVC!.indexDict![peerID]!, value: false)
        } else if (str == "True") {
            let sessionVC = sessionViewController as? SessionViewController
            // peerID --> sessionvc dict will return index which used to update bool array
            sessionVC!.updateOtherDeviceStatus(index: sessionVC!.indexDict![peerID]!, value: true)
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        print("didReceive InputStream: \(stream)")
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        print("didStartReceivingResourceWithName: \(resourceName)")
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        print("didFinishReceivingResourceWithName: \(resourceName)")
    }
}

extension ConnectionManager: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationHandler(true, session)
    }
}

extension ConnectionManager: MCBrowserViewControllerDelegate {
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        browserViewController.dismiss(animated: true)
        homeViewController!.performSegue(withIdentifier: "WaitingRoomSegueIdentifier1", sender: nil)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        session?.disconnect()
        browserViewController.dismiss(animated: true)
    }
}


