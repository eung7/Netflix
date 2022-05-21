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
    var viewModel: PlayerViewModel!
    var player: AVPlayer?
    var timer: Timer?
    
    lazy var videoPlayerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var backgroundTapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapBackground))
        
        return gesture
    }()
    
    lazy var playButton: UIButton = {
        var config = UIButton.Configuration.borderless()
        config.baseForegroundColor = .white
        config.baseBackgroundColor = UIColor.clear
        config.preferredSymbolConfigurationForImage =  UIImage.SymbolConfiguration(pointSize: 30)
        
        let button = AnimationButton(configuration: config)
        button.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        button.setImage(UIImage(systemName: "play.fill"), for: .selected)
        button.addTarget(self, action: #selector(didTapPauseButton), for: .touchUpInside)
        
        return button
    }()
    
    lazy var starButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = .systemYellow
        config.baseBackgroundColor = .clear
        
        let button = UIButton(configuration: config)
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.setImage(UIImage(systemName: "star.fill"), for: .selected)
        button.addTarget(self, action: #selector(didTapStarButton(_:)), for: .touchUpInside)
        
        return button
    }()
    
    lazy var backButton: UIButton = {
        var config = UIButton.Configuration.borderless()
        config.baseForegroundColor = .white
        
        let button = UIButton(configuration: config)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.addTarget(self, action: #selector(didTapBackButton(_:)), for: .touchUpInside)
        
        return button
    }()
    
    lazy var videoTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16.0, weight: .regular)
        
        return label
    }()
    
    lazy var timeRemainingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16.0, weight: .regular)
        
        return label
    }()
    
    lazy var progressBar: UISlider = {
        let slider = UISlider()
        slider.tintColor = .systemRed
        slider.addTarget(self, action: #selector(didChangedProgressBar(_:)), for: .valueChanged)
        
        return slider
    }()
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeRight
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        view.addGestureRecognizer(backgroundTapGesture)
        
        [
            playButton,
            videoTitleLabel,
            progressBar,
            timeRemainingLabel,
            backButton,
            starButton
        ]
            .forEach { videoPlayerView.addSubview($0) }
        
        playButton.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        videoTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(64)
        }
        
        timeRemainingLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(64)
            make.trailing.equalToSuperview().inset(80)
        }

        progressBar.snp.makeConstraints { make in
            make.centerY.equalTo(timeRemainingLabel)
            make.leading.equalToSuperview().inset(80)
            make.trailing.equalTo(timeRemainingLabel.snp.leading).offset(-8)
        }
        
        backButton.snp.makeConstraints { make in
            make.centerY.equalTo(videoTitleLabel)
            make.centerX.equalTo(timeRemainingLabel)
        }
        
        starButton.snp.makeConstraints { make in
            make.centerY.equalTo(videoTitleLabel)
            make.trailing.equalTo(backButton.snp.leading).offset(-8)
        }
        
        view.addSubview(videoPlayerView)
        
        videoPlayerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func prepareVideo(_ movie: StarMovie) {
        viewModel = PlayerViewModel(movie)
        starButton.isSelected = viewModel.currentMovie.isStar
        
        let url = viewModel.trailerURL
        player = AVPlayer(url: url)
        videoTitleLabel.text = viewModel.movieName
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.height, height: UIScreen.main.bounds.width)
        videoPlayerView.layer.addSublayer(playerLayer)
        
        let interval = CMTime(seconds: 0.001, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        player?.addPeriodicTimeObserver(forInterval:interval, queue: DispatchQueue.main, using: { [weak self] currentTime in
            self?.updateSlider(currentTime)
            self?.updateRemainingText(currentTime)
        })
    }
}

/// Slider, RemainingText Update
extension PlayerViewController {
    func updateRemainingText(_ currentTime: CMTime) {
        guard let duration = player?.currentItem?.duration else { return }
        
        let totalTime = CMTimeGetSeconds(duration)
        let remainingTime = totalTime - CMTimeGetSeconds(currentTime)
        let min = remainingTime / 60
        let sec = remainingTime.truncatingRemainder(dividingBy: 60)
        
        let formatter = NumberFormatter()
        formatter.minimumIntegerDigits = 2
        formatter.minimumFractionDigits = 0
        formatter.roundingMode = .down
        guard let minStr = formatter.string(from: NSNumber(value: min)),
              let secStr = formatter.string(from: NSNumber(value: sec)) else { return }
        
        self.timeRemainingLabel.text = "\(minStr):\(secStr)"
    }
    
    func updateSlider(_ currentTime: CMTime) {
        if let currentItem = player?.currentItem {
            let duration = currentItem.duration
            if CMTIME_IS_INVALID(duration) {
                return
            }
            progressBar.value = Float(CMTimeGetSeconds(currentTime) / CMTimeGetSeconds(duration))
        }
    }
}

/// @objc methods
extension PlayerViewController {
    @objc func didTapPauseButton(_ sender: UIButton) {
        guard let player = player else { return }
        
        let highlightImage = sender.isSelected ? UIImage(systemName: "pause.fill") : UIImage(systemName: "play.fill")

        if sender.isSelected == false {
            sender.setImage(highlightImage, for: .normal)
            sender.isSelected = !sender.isSelected
            player.pause()
        } else {
            sender.setImage(highlightImage, for: .normal)
            sender.isSelected = !sender.isSelected
            player.play()
        }
    }

    @objc func didTapBackButton(_ sender: UIButton) {
        player?.pause()
        dismiss(animated: true)
    }
    
    @objc func didTapStarButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        viewModel.didTapStarbutton(sender.isSelected)
    }
    
    @objc func didChangedProgressBar(_ sender: UISlider) {
        guard let duration = player?.currentItem?.duration else { return }
        
        let value = Float64(sender.value) * CMTimeGetSeconds(duration)
        let seekTime = CMTime(value: CMTimeValue(value), timescale: 1)
        player?.seek(to: seekTime)
    }
    
    @objc func didTapBackground() {
        [
            self.playButton,
            self.videoTitleLabel,
            self.progressBar,
            self.timeRemainingLabel,
            self.backButton,
            self.starButton
        ]
            .forEach { $0.isHidden = !$0.isHidden }
    }
}
