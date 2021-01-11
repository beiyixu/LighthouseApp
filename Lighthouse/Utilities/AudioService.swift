//
//  AudioService.swift
//  Lighthouse
//
//  Created by Beiyi Xu on 10/20/20.
//

import AudioToolbox

class AudioService {
  
  func playSound()  {
    var soundID: SystemSoundID = 0
    let soundURL = NSURL(fileURLWithPath: Bundle.main.path(forResource: "Message", ofType: "wav")!)
    AudioServicesCreateSystemSoundID(soundURL, &soundID)
    AudioServicesPlaySystemSound(soundID)
  }
}
