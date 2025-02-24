//
//  AudioPlayer.swift
//  HeadwayTestTask
//
//  Created by Andrii Kravtsov on 18.02.2025.
//

import AVKit
import Dependencies
import Combine

enum AudioPlayerDependencyKey: DependencyKey {
    static let liveValue: Player = AudioPlayer()
}

extension DependencyValues {
    var audioPlayer: Player {
        get { self[AudioPlayerDependencyKey.self] }
        set { self[AudioPlayerDependencyKey.self] = newValue }
    }
}

protocol Player {
    var isPlaying: Bool { get }
    var rate: Float { get set }
    
    func setup(with url: URL?) throws
    
    func play()
    func pause()
    
    func set(rate: Float)
    func set(currentTime: TimeInterval)

    func getCurrentTimeStream() -> AsyncStream<TimeInterval>
    func getDurationStream() -> AsyncStream<TimeInterval>
    func getPlaybackFinishedStream() -> AsyncStream<Void>
}
 
class AudioPlayer: NSObject, Player {
    var isPlaying: Bool {
        player?.timeControlStatus == .playing
    }
    
    var rate: Float = 1 {
        didSet {
            player?.rate = isPlaying ? rate : 0
        }
    }
    
    private var player: AVPlayer?

    func setup(with url: URL?) throws {
        guard let url else { throw AudioPlayerError.invalidURL }
        player?.pause()
        player = AVPlayer(url: url)
    }
    
    func play() {
        player?.rate = rate
    }
    
    func pause() {
        player?.pause()
    }
    
    func set(rate: Float) {
        self.rate = rate
    }
    
    func set(currentTime: TimeInterval) {
        let newTime = CMTime(seconds: currentTime, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        player?.seek(to: newTime)
    }
    
    func getCurrentTimeStream() -> AsyncStream<Double> {
        guard let player else { return .finished }
        
        return AsyncStream { continuation in
            let timeInterval = CMTime(seconds: 1, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
            
            let observer = player.addPeriodicTimeObserver(forInterval: timeInterval, queue: .main) { time in
                continuation.yield(CMTimeGetSeconds(time))
            }
            
            continuation.onTermination = { @Sendable _ in
                player.removeTimeObserver(observer)
            }
        }
    }
    
    func getDurationStream() -> AsyncStream<TimeInterval> {
        guard let player else { return .finished }
        
        return AsyncStream { continuation in
            let observer = player.currentItem?.publisher(for: \.duration)
                .compactMap { $0.seconds.isFinite ? $0.seconds : nil }
                .sink { duration in
                    continuation.yield(duration)
                }

            continuation.onTermination = { _ in
                observer?.cancel()
            }
        }
    }
    
    func getPlaybackFinishedStream() -> AsyncStream<Void> {
        return AsyncStream { continuation in
            let observer = NotificationCenter.default.publisher(
                for: .AVPlayerItemDidPlayToEndTime,
                object: player?.currentItem
            ).sink { _  in
                continuation.yield(())
            }
            
            continuation.onTermination = { _ in
                observer.cancel()
            }
        }
    }
}
