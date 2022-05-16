//
//  AVPlayer.swift
//  eung7_Netflix
//
//  Created by 김응철 on 2022/05/06.
//

import AVFoundation

extension AVPlayer {
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}
