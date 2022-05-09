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
    
    /// 영상이 실행되는 객체인 AVPlayer
    var player: AVPlayer?
    
    /// 애니메이션에 사용될 Timer객체 정의
    var timer: Timer?
    
    /// AVPlayer가 들어갈 UIView객체
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
    
    /// 재생 버튼
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
    
    /// 취소 버튼
    lazy var backButton: UIButton = {
        var config = UIButton.Configuration.borderless()
        config.baseForegroundColor = .white
        
        let button = UIButton(configuration: config)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.addTarget(self, action: #selector(didTapBackButton(_:)), for: .touchUpInside)
        
        return button
    }()
    
    /// 트레일러의 이름 Label
    lazy var videoTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16.0, weight: .regular)
        
        return label
    }()
    
    /// 트레일러의 남은 시간을 나타내주는 Label
    lazy var timeRemainingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16.0, weight: .regular)
        
        return label
    }()
    
    /// 트레일러의 동영상 길이 Slider
    lazy var progressBar: UISlider = {
        let slider = UISlider()
        slider.tintColor = .systemRed
        slider.addTarget(self, action: #selector(didChangedProgressBar(_:)), for: .valueChanged)
        
        return slider
    }()
    
    /// PlayerVC 객체가 표시될 때 가로모드로 설정
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeRight
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    /// UI들의 addSubview, AutoLayout 설정
    func setupUI() {
        view.addGestureRecognizer(backgroundTapGesture)
        
        [
            playButton,
            videoTitleLabel,
            progressBar,
            timeRemainingLabel,
            backButton,
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
        
        view.addSubview(videoPlayerView)
        
        videoPlayerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    /// urlString을 파라미터로 받아서 실제 동영상으로 준비해주는 Method
    func prepareVideo(url: String) {
        guard let url = URL(string: url) else { return }
        
        player = AVPlayer(url: url)
        
        /// AVPlayer를 View위에서 실행시키기 위해서는 AVPlayerLayer라는 객체가 필요함
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.height, height: UIScreen.main.bounds.width)
        
        /// UIView객체에 addSublayer를 하는 Method
        videoPlayerView.layer.addSublayer(playerLayer)
        
        /// 간격이 0.01초인 CMTime객체를 생성
        let interval = CMTime(seconds: 0.001, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        /// 현재 재생되는 동영상에 0.01초 마다 관찰하는  interval을 형성하는 addPeriodicTimeObserver Method를 실행
        /// 이 Method는 클로저인 콜백 함수로 받아서 0.01초마다 수행할 작업을 설정할 수 있다.
        /// interval: 몇초마다 영상을 관찰할 것인지에 대한 인자
        /// queue: UI작업인 Slider를 변경하는 작업이니까 main Thread에서 실행되어야 한다.
        /// using: 콜백함수의 인자로써 영상의 현재 시간을 나타내주는 CMTime객체가 내려온다.
        ///     여기서 CMTime객체는 내가 이전에 설정했던 CMTime객체의 타입으로 내려온다. 즉, 0.01초 간격인..
        player?.addPeriodicTimeObserver(forInterval:interval, queue: DispatchQueue.main, using: { [weak self] currentTime in
            // MARK: Closure안에 순환 참조
            /// weak self를 붙여주지 않으면, 현재 VCPlayer인스턴스와 클로저 간의 강한 순환 참조가 발생해서 메모리 누수가 발생 !
            /// 순환 참조 메모리 누수의 위험성을 보여줄 수 있는 보기 좋은 예시
            self?.updateSlider(currentTime)
            self?.updateRemainingText(currentTime)
        })
    }
    
    func updateRemainingText(_ currentTime: CMTime) {
        /// 영상의 전체 길이 가져오기 (CMTime)
        guard let duration = player?.currentItem?.duration else { return }
        
        /// 초로 표현된 영상 전체 길이
        let totalTime = CMTimeGetSeconds(duration)
        /// 초로 표현된 남은 영상 길이
        let remainingTime = totalTime - CMTimeGetSeconds(currentTime)
        /// 남은 영상 길이의 분과 초를 구하기 위한 작업
        let min = remainingTime / 60
        let sec = remainingTime.truncatingRemainder(dividingBy: 60)
        
        /// NumberFormatter Attributes 적용
        let formatter = NumberFormatter()
        /// 정수 자릿수 설정
        formatter.minimumIntegerDigits = 2
        /// 소수 자릿수 설정
        formatter.minimumFractionDigits = 0
        /// 소숫점 내림
        formatter.roundingMode = .down
        guard let minStr = formatter.string(from: NSNumber(value: min)),
              let secStr = formatter.string(from: NSNumber(value: sec)) else { return }
        
        self.timeRemainingLabel.text = "\(minStr):\(secStr)"
    }
    
    func updateSlider(_ currentTime: CMTime) {
        /// AVPlayer에서 현재 재생되는 아이템을 가져와서 옵셔널 바인딩
        if let currentItem = player?.currentItem {
            /// currentItem.duration은 현재 동영상의 전체 길이를 CMTime객체로 반환하여 준다.
            let duration = currentItem.duration
            /// CMTime 객체가 유효하지 않을 때는 그냥 반환될 수 있는 조건문
            if CMTIME_IS_INVALID(duration) {
                return
            }
            /// CMTime객체를 우리가 볼 수 있는 '초'단위로 변경해주는 Method인 CMTimeGetSeconds(_:)
            /// Slider의 값을 실시간으로 바꿔준다. currentTime은 계속해서 바뀌고 duration은 일정하기 때문
            progressBar.value = Float(CMTimeGetSeconds(currentTime) / CMTimeGetSeconds(duration))
        }
    }
    
    deinit {
        /// 참조가 해제 되는지 확인
        print("PlayerVC is deinited!")
    }
}

// MARK: @objc Method Collection
private extension PlayerViewController {
    @objc func didTapPauseButton(_ sender: UIButton) {
        guard let player = player else { return }
        
        /// 처음엔 sender.isSelected = false 가 들어오니까
        ///
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
    
    /// Slider를 드래그 하면 실행되는 Method
    @objc func didChangedProgressBar(_ sender: UISlider) {
        /// 동영상의 전체 길이를 가져오기
        guard let duration = player?.currentItem?.duration else { return }
        
        /// Slider의 value(0~1)를 전체 길이(duration)로 곱하면 슬라이드 된 영상 재생 시간을 흭득 가능
        let value = Float64(sender.value) * CMTimeGetSeconds(duration)
        /// 추출한 value값을 다시 CMTime으로 변환
        let seekTime = CMTime(value: CMTimeValue(value), timescale: 1)
        /// 재생중인 AVPlayer에 타겟이 되는 위치로 찾아감
        player?.seek(to: seekTime)
    }
    
    @objc func didTapBackground() {
        [
            playButton,
            videoTitleLabel,
            progressBar,
            timeRemainingLabel,
            backButton,
        ]
            .forEach { $0.isHidden = !$0.isHidden }
    }
}
