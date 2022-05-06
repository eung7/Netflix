//
//  PlayerViewController.swift
//  eung7_Netflix
//
//  Created by 김응철 on 2022/05/05.
//

import AVFoundation
import UIKit
import SnapKit

class PlayerViewController: UIViewController {
    
    var player: AVPlayer?
    
    lazy var videoPlayerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var playButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.baseForegroundColor = .white
        config.baseBackgroundColor = .systemBackground
        
        let button = UIButton(configuration: config)
        button.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        button.setImage(UIImage(systemName: "play.fill"), for: .selected)
        button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 30), forImageIn: .normal)
        button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 30), forImageIn: .selected)
        button.addTarget(self, action: #selector(didTapPauseButton), for: .touchUpInside)
        
        return button
    }()
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeRight
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    func setupUI() {
        [ playButton ]
            .forEach { videoPlayerView.addSubview($0) }
        
        playButton.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        
        view.addSubview(videoPlayerView)
        
        videoPlayerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
    
    func prepareVideo(url: String) {
        guard let url = URL(string: url) else { return }
        
        player = AVPlayer(url: url)
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.height, height: UIScreen.main.bounds.width)
        
        videoPlayerView.layer.addSublayer(playerLayer)
    }
}

private extension PlayerViewController {
    @objc func didTapPauseButton(_ button: UIButton) {
        button.isSelected = !button.isSelected
    }
}
