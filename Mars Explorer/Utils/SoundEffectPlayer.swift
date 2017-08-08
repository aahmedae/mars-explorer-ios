//
//  SoundEffectPlayer.swift
//  Mars Explorer
//
//  Created by Asad Ahmed on 8/8/17.
//  Copyright © 2017 Asad Ahmed. All rights reserved.
//
//  Plays Sound effects throughout the app
//

import AVFoundation

class SoundEffectPlayer
{
    // MARK:- Variables
    
    // Singleton
    static var shared = SoundEffectPlayer()
    private init() {}
    
    fileprivate var effectPlayer: AVAudioPlayer? = nil
    fileprivate var backgroundAmbiencePlayer: AVAudioPlayer? = nil
    
    // MARK:- Public API
    
    // Play one shot of the given sound file
    func playSoundEffectOnce(filename: String)
    {
        if let player = effectPlayer {
            if player.isPlaying {
                player.stop()
            }
        }
        
        let url = URL(fileURLWithPath: filename)
        
        do {
            effectPlayer = try AVAudioPlayer(contentsOf: url)
            effectPlayer!.numberOfLoops = 0
            effectPlayer!.play()
        }
        catch {
            print("Error in setting file with path: \(url.absoluteString)")
        }
    }
    
    // Play background ambience indefintely
    func playBackgroundAmbience(filename: String)
    {
        stopBackgroundAmbience()
        
        let url = URL(fileURLWithPath: filename)
        
        do {
            backgroundAmbiencePlayer = try AVAudioPlayer(contentsOf: url)
            backgroundAmbiencePlayer!.numberOfLoops = -1
            backgroundAmbiencePlayer!.play()
        }
        catch {
            print("Error in setting file with path: \(url.absoluteString)")
        }
    }
    
    // Stops the playing ambience
    func stopBackgroundAmbience()
    {
        if let player = backgroundAmbiencePlayer {
            if player.isPlaying {
                player.stop()
            }
        }
    }
}
