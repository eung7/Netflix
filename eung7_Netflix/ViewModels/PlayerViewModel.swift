//
//  PlayerViewModel.swift
//  eung7_Netflix
//
//  Created by 김응철 on 2022/05/13.
//

import Foundation
import AVFoundation

class PlayerViewModel {
    var currentMovie: StarMovie!
}

extension PlayerViewModel {
    var trailerURL: URL { return URL(string: currentMovie.trailer)! }
    var movieName: String { return currentMovie.movieName }
}

extension PlayerViewModel {
    func prepareVideo(_ movie: StarMovie, _ completion: (URL) -> Void) {
        currentMovie = movie
        let url = trailerURL
        completion(url)
    }
    
    func updateRemainingText(_ duration: CMTime, currentTime: CMTime) -> String {
        let totalTime = CMTimeGetSeconds(duration)
        let remainingTime = totalTime - CMTimeGetSeconds(currentTime)
        let min = remainingTime / 60
        let sec = remainingTime.truncatingRemainder(dividingBy: 60)
        
        let formatter = NumberFormatter()
        formatter.minimumIntegerDigits = 2
        formatter.minimumFractionDigits = 0
        formatter.roundingMode = .down
        guard let minStr = formatter.string(from: NSNumber(value: min)),
              let secStr = formatter.string(from: NSNumber(value: sec)) else { return "" }

        return "\(minStr):\(secStr)"
    }
    
    func didChangedProgressBar(_ duration: CMTime, value: Float64) -> CMTime {
        let value = Float64(value) * CMTimeGetSeconds(duration)
        let seekTime = CMTime(value: CMTimeValue(value), timescale: 1)
        return seekTime
    }
    
    func didTapStarbutton(_ isStar: Bool) {
        if isStar == true {
            currentMovie.updateIsStar(isStar)
            StarMovie.movies.append(currentMovie)
        } else {
            if let index = StarMovie.movies.firstIndex(where: { $0.trailer == currentMovie.trailer }) {
                StarMovie.movies.remove(at: index)
            }
        }
    }
}
