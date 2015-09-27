//
//  PeerController.swift
//  ispotyfest
//
//  Created by Raphael Haase on 2015-09-27.
//  Copyright © 2015 Spotyfest. All rights reserved.
//

import Foundation

class PeerController: NSObject, PPKControllerDelegate {
  
  private var appState: AppState?
  
  init(_appState: AppState) {
    super.init()
    appState = _appState
    PPKController.enableWithConfiguration(p2pkitAPIKey, observer:self)
    
    appState!.addObserver(self, forKeyPath: "person", options: [.New, .Old], context: nil)
  }
  
  deinit {
    appState!.removeObserver(self, forKeyPath: "person")
    appState!.person?.removeObserver(self, forKeyPath: "email")
  }
  
  func PPKControllerInitialized() {
    var email = appState?.person?.email
    if email == nil {
      email = "empty@raph.de"
    }
    startDiscovering(email!)
    PPKController.startGeoDiscovery()
    PPKController.startOnlineMessaging()
  }
  
  private func startDiscovering(email: String) {
    let myDiscoveryInfo = email.dataUsingEncoding(NSUTF8StringEncoding)
    // TODO add number of seats and other params. Convert dictionary to string?
    PPKController.startP2PDiscoveryWithDiscoveryInfo(myDiscoveryInfo)
  }
  
  func p2pPeerDiscovered(peer: PPKPeer!) {
    let discoveryInfoString = NSString(data: peer.discoveryInfo, encoding:NSUTF8StringEncoding)
    NSLog("%@ is here with discovery info: %@", peer.peerID, discoveryInfoString!)
  }
  
  func p2pPeerLost(peer: PPKPeer!) {
    NSLog("%@ is no longer here", peer.peerID)
  }
  
  func didUpdateP2PDiscoveryInfoForPeer(peer: PPKPeer!) {
    let discoveryInfo = NSString(data: peer.discoveryInfo, encoding: NSUTF8StringEncoding)
    NSLog("%@ has updated discovery info: %@", peer.peerID, discoveryInfo!)
  }
  
  override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
    
    if keyPath != nil {
      switch (keyPath!) {
      case "person":
        let oldValue = change![NSKeyValueChangeOldKey] as? Person
        if oldValue != nil {
          oldValue!.removeObserver(self, forKeyPath: "email")
        }
        let newValue = change![NSKeyValueChangeNewKey] as? Person
        if newValue != nil {
          newValue!.addObserver(self, forKeyPath: "email", options: [.New, .Old], context: nil)
        }
      case "email":
        let newValue = change![NSKeyValueChangeNewKey] as? String
        if newValue != nil {
          startDiscovering(newValue!)
        }
        
      default:
        break
      }
    }
    
  }
  
}