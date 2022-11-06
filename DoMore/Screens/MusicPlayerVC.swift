//
//  MusicPlayerScreen.swift
//  DoMore
//
//  Created by Josue Cruz on 10/19/22.
//

import UIKit
import MediaPlayer

class MusicPlayerVC: UIViewController {
    
    let artwork = DMImageView(frame: .zero)
    let songName = DMSubtitleLabel(fontSize: 19, textAlignment: .left)
    let artistName = DMBodyLabel(fontSize: 17, textAlignment: .left)
    let songDuration = DMBodyLabel(fontSize: 19, textAlignment: .center)
    var timerLabel = DMTitleLabel(fontSize: 43, textAlignment: .center)
    let playPauseButton = DMButton(systemImageName: SFSymbols.pause, backgroudColor: .systemPink, foregroundColor: .white)
    let backwardButton = DMButton(systemImageName: SFSymbols.backward, backgroudColor: .systemPink, foregroundColor: .white)
    let forwardButton = DMButton(systemImageName: SFSymbols.forward, backgroudColor: .systemPink, foregroundColor: .white)
    let finishButton = DMButton(title: "FINISH", backgroundColor: .systemPink)
    let musicPlayer = MPMusicPlayerController.applicationMusicPlayer
    let notificationCenter = UNUserNotificationCenter.current()
    var tracks = [String]()
    var imagesDict = [String: String]()
    var timer: Timer?
    var timerSeconds: Int?
    var songSeconds: Int?
    var timerValve = false

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureUI()
        configureMusicPlayer()
        setTimerLabel(timerSeconds!)
        setupTimer()
        setLocalNotificationAlert(timerSeconds!)
        NotificationCenter.default.post(name: NSNotification.Name.MPMusicPlayerControllerNowPlayingItemDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(itemDidChange), name: NSNotification.Name.MPMusicPlayerControllerNowPlayingItemDidChange, object: nil)
        NotificationCenter.default.post(name: NSNotification.Name.MPMusicPlayerControllerPlaybackStateDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(stateDidChange), name: NSNotification.Name.MPMusicPlayerControllerPlaybackStateDidChange, object: nil)
    }
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        title = "DoMore..."
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.setHidesBackButton(true, animated: true)
    }

    private func configureUI() {
        view.addSubviews(artwork, songName, artistName, songDuration, timerLabel, playPauseButton, backwardButton, forwardButton, finishButton)
        playPauseButton.addTarget(self, action: #selector(playPauseButtonTapped), for: .touchUpInside)
        playPauseButton.configuration?.cornerStyle = .large
        backwardButton.addTarget(self, action: #selector(backwardButtonTapped), for: .touchUpInside)
        forwardButton.addTarget(self, action: #selector(forwardButtonTapped), for: .touchUpInside)
        finishButton.addTarget(self, action: #selector(finishButtonTapped), for: .touchUpInside)
        finishButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 19)
        
        NSLayoutConstraint.activate([
            artwork.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            artwork.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            artwork.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            artwork.heightAnchor.constraint(equalToConstant: 250),
            
            songName.topAnchor.constraint(equalTo: artwork.bottomAnchor, constant: 5),
            songName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35),
            songName.widthAnchor.constraint(equalToConstant: 250),
            
            artistName.topAnchor.constraint(equalTo: songName.bottomAnchor, constant: 0),
            artistName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35),
            artistName.widthAnchor.constraint(equalToConstant: 250),
            
            songDuration.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            songDuration.topAnchor.constraint(equalTo: artwork.bottomAnchor, constant: 65),
            songDuration.widthAnchor.constraint(equalToConstant: 250),
            
            timerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timerLabel.topAnchor.constraint(equalTo: songDuration.bottomAnchor, constant: 0),
            timerLabel.widthAnchor.constraint(equalToConstant: 250),
            
            playPauseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playPauseButton.topAnchor.constraint(equalTo: timerLabel.bottomAnchor, constant: 10),
            playPauseButton.widthAnchor.constraint(equalToConstant: 75),
            playPauseButton.heightAnchor.constraint(equalToConstant: 75),
            
            backwardButton.topAnchor.constraint(equalTo: playPauseButton.topAnchor),
            backwardButton.trailingAnchor.constraint(equalTo: playPauseButton.leadingAnchor, constant: -15),
            backwardButton.widthAnchor.constraint(equalToConstant: 75),
            backwardButton.heightAnchor.constraint(equalToConstant: 75),
        
            forwardButton.topAnchor.constraint(equalTo: playPauseButton.topAnchor),
            forwardButton.leadingAnchor.constraint(equalTo: playPauseButton.trailingAnchor, constant: 15),
            forwardButton.widthAnchor.constraint(equalToConstant: 75),
            forwardButton.heightAnchor.constraint(equalToConstant: 75),
            
            finishButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            finishButton.topAnchor.constraint(equalTo: playPauseButton.bottomAnchor, constant: 15),
            finishButton.widthAnchor.constraint(equalToConstant: 200),
            finishButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    private func updateUI() {
        songName.text = musicPlayer.nowPlayingItem?.title ?? "Not playing"
        artistName.text = musicPlayer.nowPlayingItem?.artist ?? ""
        guard let title = musicPlayer.nowPlayingItem?.title else { return }
        guard let imageURL = imagesDict[title] else { return }
        artwork.downloadImage(fromURL: imageURL)
        updateSongDurationLabel()
    }
    
    private func configureMusicPlayer() {
        musicPlayer.setQueue(with: tracks)
        musicPlayer.shuffleMode = .songs
        musicPlayer.repeatMode = .all
        musicPlayer.prepareToPlay()
        musicPlayer.play()
        updateUI()
    }
            
    @objc func playPauseButtonTapped() {
        if self.musicPlayer.playbackState == .paused || musicPlayer.playbackState == .stopped {
            if timerSeconds! >= 1 {
                playPauseButton.setImage(UIImage(systemName: SFSymbols.pause), for: .normal)
                musicPlayer.play()
                timerValve = false
                setupTimer()
                setLocalNotificationAlert(timerSeconds!)
            }
        } else {
            animatePlayPauseButton()
            playPauseButton.setImage(UIImage(systemName: SFSymbols.play), for: .normal)
            musicPlayer.pause()
            timerValve = true
            timer?.invalidate()
            notificationCenter.removeAllPendingNotificationRequests()
        }
    }
    
    @objc func forwardButtonTapped() {
        musicPlayer.skipToNextItem()
        updateUI()
    }
    
    @objc func backwardButtonTapped() {
        musicPlayer.skipToPreviousItem()
        updateUI()
    }
        
    @objc func finishButtonTapped() {
        animateFinishButton()
        if timerSeconds! >= 1 {
            // Create alert
            let alert = UIAlertController(title: "Are you sure?", message: "You are about to end your session.", preferredStyle: .alert)
            // Create actions
            let yesAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) { [weak self] UIAlertAction in
                guard let self = self else { return }
                self.musicPlayer.stop()
                self.notificationCenter.removeAllPendingNotificationRequests()
                self.navigationController?.popViewController(animated: true)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { UIAlertAction in
            }
            // Add actions
            alert.addAction(yesAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true)
        }
        self.notificationCenter.removeAllPendingNotificationRequests()
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func itemDidChange() {
        updateUI()
    }
    
    @objc func stateDidChange() {
        let secondsToDelay = 0.5
        perform(#selector(remotePlayPause), with: nil, afterDelay: secondsToDelay)
    }
    
    @objc func remotePlayPause() {
        if musicPlayer.playbackState == .paused {
            playPauseButton.setImage(UIImage(systemName: SFSymbols.play), for: .normal)
            timerValve = true
            timer?.invalidate()
            notificationCenter.removeAllPendingNotificationRequests()
        } else {
            if timerSeconds! >= 1 {
                playPauseButton.setImage(UIImage(systemName: SFSymbols.pause), for: .normal)
                if timerValve {
                    timerValve = false
                    setupTimer()
                    setLocalNotificationAlert(timerSeconds!)
                }
            }
        }
    }
    
    private func setLocalNotificationAlert(_ sec: Int) {
        notificationCenter.getNotificationSettings { [weak self] settings in
            guard let self = self else { return}
            if settings.authorizationStatus == .authorized {
                // Content
                let content = UNMutableNotificationContent()
                content.title = "Your task has ended"
                content.body = "You're doing great!"
                content.sound = .default
                
                // Trigger
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Double(sec), repeats: false)
                
                // Request
                let uuidString = UUID().uuidString
                let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
                
                self.notificationCenter.add(request) { [weak self] error in
                    guard let self = self else { return}
                    if error != nil {
                        DispatchQueue.main.async {
                            self.presentDMAlertOnMainThread(title: "Something went wrong", message: error.debugDescription, buttonTitle: "OK")
                        }
                    }
                }
            }
        }
    }
    
    private func animatePlayPauseButton() {
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position.x"
        animation.values = [0, 10, -10, 10, 0]
        animation.duration = 0.25
        animation.isAdditive = true
        playPauseButton.layer.add(animation, forKey: "shake")
    }
    
    private func animateFinishButton() {
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position.y"
        animation.values = [0, 10, -10, 10, -10, 10, 0]
        animation.duration = 0.25
        animation.isAdditive = true
        finishButton.layer.add(animation, forKey: "shake")
    }
}

    //MARK: Timer
extension MusicPlayerVC {
    
    func secondsToMinutesSeconds(_ sec: Int) -> (Int, Int) {
        let min = (sec / 60)
        let sec = (sec % 60)
        return (min, sec)
    }
    
    func makeTimeString(min: Int, sec: Int) -> String {
        var timeString = ""
        timeString += String(format: "%02d", min)
        timeString += ":"
        timeString += String(format: "%02d", sec)
        return timeString
    }
    
    func setTimerLabel(_ sec: Int) {
        let time = secondsToMinutesSeconds(sec)
        let timeString = makeTimeString(min: time.0, sec: time.1)
        timerLabel.text = timeString
    }
    
    func setSongDurationLabel(_ sec: Int) {
        let time = secondsToMinutesSeconds(sec)
        let timeString = makeTimeString(min: time.0, sec: time.1)
        songDuration.text = timeString
    }
    
    func updateSongDurationLabel() {
        songSeconds = Int(musicPlayer.nowPlayingItem!.playbackDuration)
        setSongDurationLabel(songSeconds ?? 0)
    }
    
    private func setupTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        if timerSeconds == 1 {
            playPauseButton.setImage(UIImage(systemName: SFSymbols.play), for: .normal)
            musicPlayer.pause()
            timer?.invalidate()
        }
        songSeconds! -= 1
        setSongDurationLabel(songSeconds!)
        
        timerSeconds! -= 1
        setTimerLabel(timerSeconds!)
    }
}

