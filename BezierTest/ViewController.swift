//
//  ViewController.swift
//  BezierTest
//
//  Created by Ален Авако on 09.06.2022.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var player = AVPlayer()
    var playerLayer = AVPlayerLayer()
    let urlArray: [URL] = [URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!, URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4")!, URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4")!, URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4")!]
    private var timer: Timer!
    private var timeRemaining = 100
    
    private lazy var conteinerView: UIView = {
        let view = UIView()
        view.center = self.view.center
        let size = self.view.bounds.width / 6
        let width = size * 2
        view.frame = CGRect(x: size, y: 0, width: self.view.bounds.width - width, height: self.view.bounds.height)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(nextVideo)))
        view.addSubview(playView)
        return view
    }()
    
    private lazy var playView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "next")
        let size = self.view.bounds.height / 4
        view.frame = CGRect(x: 0, y: 0, width: size, height: size)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(nextVideo)))
        return view
    }()
    
    private lazy var leftCountDownLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "100"
        label.textColor = UIColor(named: "pinkColor")
        label.font = label.font.withSize(12)
        label.textAlignment = .right
        return label
    }()
    
    private lazy var rightCountDownLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "100"
        label.textColor = UIColor(named: "pinkColor")
        label.font = label.font.withSize(12)
        label.textAlignment = .left
        return label
    }()
    
    private let rightDownLine = CAShapeLayer()
    private let rightUpLine = CAShapeLayer()
    private let leftDownLine = CAShapeLayer()
    private let leftUpLine = CAShapeLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        playVideo()
        
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        mainRightDownLine()
        mainRightUpLine()
        mainLeftUpLine()
        mainLeftDownLine()
        drawInsideRightLine()
        drawInsideLeftLine()
        
        view.addSubview(leftCountDownLabel)
        view.addSubview(rightCountDownLabel)
        
        setUpCountdown()
        
        setUpPlayView()
    }
    
    func playVideo() {
        guard let videoURl = urlArray.first else { return }
        player = AVPlayer(url: videoURl)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = view.bounds
        playerLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(playerLayer)
    }
    
    override func viewWillLayoutSubviews() {
        
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }

    override var shouldAutorotate: Bool {
        return true
    }
    
    private func setUpPlayView() {
        view.addSubview(conteinerView)
    }
    
    private func setUpCountdown() {
        NSLayoutConstraint.activate([
            leftCountDownLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            leftCountDownLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            leftCountDownLabel.widthAnchor.constraint(equalToConstant: 34),
            leftCountDownLabel.heightAnchor.constraint(equalToConstant: 16),
            
            rightCountDownLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            rightCountDownLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            rightCountDownLabel.widthAnchor.constraint(equalToConstant: 34),
            rightCountDownLabel.heightAnchor.constraint(equalToConstant: 16)
        ])
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(startTimer), userInfo: nil, repeats: true)
        moveOutsideLines()
        moveLeftLine()
        moveRightLine()
        playPosition()
    }
    
    private func playPosition() {
        let size = self.view.bounds.height / 4
        let maxX = Int(conteinerView.bounds.width - size)
        let maxY = Int(conteinerView.bounds.height - size)
        var xPosition: [Int] = Array(0...maxX)
        let yPosition: [Int] = Array(0...maxY)
        guard let randomX = xPosition.randomElement(), let randomY = yPosition.randomElement() else { return }
        let x = CGFloat(randomX)
        let y = CGFloat(randomY)
        playView.frame = CGRect(x: x, y: y, width: size, height: size)
    }
    
    private func mainRightDownLine() {
        let path = drawLine(startRadians: 0, endRadians: 30, clockwise: true)
        
        let trackLayer = CAShapeLayer()
        trackLayer.strokeColor = UIColor.white.cgColor
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineWidth = 3
        trackLayer.path = path.cgPath
        
        rightDownLine.strokeColor = UIColor(named: "pinkColor")?.cgColor
        rightDownLine.lineWidth = 3
        rightDownLine.fillColor = UIColor.clear.cgColor
        rightDownLine.path = path.cgPath
        rightDownLine.strokeEnd = 0

        view.layer.addSublayer(trackLayer)
        view.layer.addSublayer(rightDownLine)
        
        moveOutsideLines()
    }
    
    private func mainRightUpLine() {
        let path = drawLine(startRadians: 0, endRadians: 330, clockwise: false)
        
        let trackLayer = CAShapeLayer()
        trackLayer.strokeColor = UIColor.white.cgColor
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineWidth = 3
        trackLayer.path = path.cgPath

        rightUpLine.strokeColor = UIColor(named: "pinkColor")?.cgColor
        rightUpLine.lineWidth = 3
        rightUpLine.fillColor = UIColor.clear.cgColor
        rightUpLine.path = path.cgPath
        rightUpLine.strokeEnd = 0

        view.layer.addSublayer(trackLayer)
        view.layer.addSublayer(rightUpLine)
        
        moveOutsideLines()
    }
    
    private func mainLeftDownLine() {
        let path = drawLine(startRadians: 180, endRadians: 150, clockwise: false)
        
        let trackLayer = CAShapeLayer()
        trackLayer.strokeColor = UIColor.white.cgColor
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineWidth = 3
        trackLayer.path = path.cgPath
        
        leftDownLine.strokeColor = UIColor(named: "pinkColor")?.cgColor
        leftDownLine.lineWidth = 3
        leftDownLine.fillColor = UIColor.clear.cgColor
        leftDownLine.path = path.cgPath
        leftDownLine.strokeEnd = 0

        view.layer.addSublayer(trackLayer)
        view.layer.addSublayer(leftDownLine)
        
        moveOutsideLines()
    }
    
    private func mainLeftUpLine() {
        let path = drawLine(startRadians: 180, endRadians: 210, clockwise: true)
        
        let trackLayer = CAShapeLayer()
        trackLayer.strokeColor = UIColor.white.cgColor
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineWidth = 3
        trackLayer.path = path.cgPath
        
        leftUpLine.strokeColor = UIColor(named: "pinkColor")?.cgColor
        leftUpLine.lineWidth = 3
        leftUpLine.fillColor = UIColor.clear.cgColor
        leftUpLine.path = path.cgPath
        leftUpLine.strokeEnd = 0

        view.layer.addSublayer(trackLayer)
        view.layer.addSublayer(leftUpLine)
        
        moveOutsideLines()
    }


    fileprivate func drawInsideRightLine() {
        let offset = view.bounds.width - view.bounds.height
        let indent = offset / 10
        let radius = Double(view.bounds.width) / 2 - indent
        let center = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2)
        let startRadians = Double(330) * Double.pi / 180
        let endRadians = Double(30) * Double.pi / 180
        let path = UIBezierPath(arcCenter: center,
                                radius: radius,
                                startAngle: startRadians,
                                endAngle: endRadians,
                                clockwise: true)
        path.addLine(to: CGPoint(x: center.x + radius * cos(endRadians) - 5,
                                 y: center.y + radius * sin(endRadians) - 30))
        
        path.addCurve(to: CGPoint(x: center.x + radius * cos(startRadians) - 5,
                                  y: center.y + radius * sin(startRadians) + 28),
                      controlPoint1: CGPoint(x: center.x + radius + 5, y: center.y + 50),
                      controlPoint2: CGPoint(x: center.x + radius + 5, y: center.y - 50))
        path.close()
//        moveLines(path, offset: center.y + radius * sin(startRadians))
    }
    
    private func drawInsideLeftLine() {
        let offset = view.bounds.width - view.bounds.height
        let indent = offset / 10
        let radius = Double(view.bounds.width) / 2 - indent
        let center = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2)
        let startRadians = Double(150) * Double.pi / 180
        let endRadians = Double(210) * Double.pi / 180
        let path = UIBezierPath(arcCenter: center,
                                radius: radius,
                                startAngle: startRadians,
                                endAngle: endRadians,
                                clockwise: true)
        path.addLine(to: CGPoint(x: center.x + radius * cos(endRadians) + 5,
                                 y: center.y + radius * sin(endRadians) + 30))

        path.addCurve(to: CGPoint(x: center.x + radius * cos(startRadians) + 5,
                                  y: center.y + radius * sin(startRadians) - 28),
                      controlPoint1: CGPoint(x: center.x - radius - 5, y: center.y - 50),
                      controlPoint2: CGPoint(x: center.x - radius - 5, y: center.y + 50))
        path.close()
//        moveLines(path, offset: center.y + radius * sin(endRadians))
    }
    
    func moveLeftLine() {
        let offset = view.bounds.width - view.bounds.height
        let indent = offset / 10
        let radius = Double(view.bounds.width) / 2 - indent
        let center = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2)
        let startRadians = Double(150) * Double.pi / 180
        let endRadians = Double(210) * Double.pi / 180
        let path = UIBezierPath(arcCenter: center,
                                radius: radius,
                                startAngle: startRadians,
                                endAngle: endRadians,
                                clockwise: true)
        path.addLine(to: CGPoint(x: center.x + radius * cos(endRadians) + 5,
                                 y: center.y + radius * sin(endRadians) + 30))

        path.addCurve(to: CGPoint(x: center.x + radius * cos(startRadians) + 5,
                                  y: center.y + radius * sin(startRadians) - 28),
                      controlPoint1: CGPoint(x: center.x - radius - 5, y: center.y - 50),
                      controlPoint2: CGPoint(x: center.x - radius - 5, y: center.y + 50))
        path.close()
        
        let trackLayer = CAShapeLayer()
        trackLayer.strokeColor = UIColor.clear.cgColor
        trackLayer.fillColor = UIColor(white: 1, alpha: 0.2).cgColor
        trackLayer.path = path.cgPath

        view.layer.addSublayer(trackLayer)
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = trackLayer.path
        maskLayer.fillColor = trackLayer.fillColor
        
        let rectangleLayer = CAShapeLayer()
        rectangleLayer.mask = maskLayer
        
        let maskOffset = center.y + radius * sin(endRadians)
        let heightOffset = maskOffset * 2
        let height = view.bounds.height - heightOffset
        
        let startPath = UIBezierPath(rect: CGRect(x: 0, y: view.bounds.height / 2, width: view.bounds.width, height: 0.0))
        let endPath = UIBezierPath(rect: CGRect(x: 0,
                                                y: maskOffset - 6,
                                                width: view.bounds.width,
                                                height: height + 6))
        rectangleLayer.path = startPath.cgPath
        rectangleLayer.fillColor = UIColor(named: "pinkColor")?.cgColor
        rectangleLayer.strokeColor = UIColor.clear.cgColor
        view.layer.addSublayer(rectangleLayer)

        let zoomAnimation = CABasicAnimation()
        zoomAnimation.keyPath = "path"
        zoomAnimation.duration = 10
        zoomAnimation.toValue = endPath.cgPath
        zoomAnimation.fillMode = CAMediaTimingFillMode.forwards
        zoomAnimation.isRemovedOnCompletion = true
        rectangleLayer.add(zoomAnimation, forKey: "zoom")
    }
    
    func moveRightLine() {
        let offset = view.bounds.width - view.bounds.height
        let indent = offset / 10
        let radius = Double(view.bounds.width) / 2 - indent
        let center = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2)
        let startRadians = Double(330) * Double.pi / 180
        let endRadians = Double(30) * Double.pi / 180
        let path = UIBezierPath(arcCenter: center,
                                radius: radius,
                                startAngle: startRadians,
                                endAngle: endRadians,
                                clockwise: true)
        path.addLine(to: CGPoint(x: center.x + radius * cos(endRadians) - 5,
                                 y: center.y + radius * sin(endRadians) - 30))
        
        path.addCurve(to: CGPoint(x: center.x + radius * cos(startRadians) - 5,
                                  y: center.y + radius * sin(startRadians) + 28),
                      controlPoint1: CGPoint(x: center.x + radius + 5, y: center.y + 50),
                      controlPoint2: CGPoint(x: center.x + radius + 5, y: center.y - 50))
        path.close()
        
        let trackLayer = CAShapeLayer()
        trackLayer.strokeColor = UIColor.clear.cgColor
        trackLayer.fillColor = UIColor(white: 1, alpha: 0.2).cgColor
        trackLayer.path = path.cgPath

        view.layer.addSublayer(trackLayer)
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = trackLayer.path
        maskLayer.fillColor = trackLayer.fillColor
        
        let rectangleLayer = CAShapeLayer()
        rectangleLayer.mask = maskLayer
        
        let maskOffset = center.y + radius * sin(startRadians)
        let heightOffset = maskOffset * 2
        let height = view.bounds.height - heightOffset
        
        let startPath = UIBezierPath(rect: CGRect(x: 0, y: view.bounds.height / 2, width: view.bounds.width, height: 0.0))
        let endPath = UIBezierPath(rect: CGRect(x: 0,
                                                y: maskOffset - 6,
                                                width: view.bounds.width,
                                                height: height + 6))
        rectangleLayer.path = startPath.cgPath
        rectangleLayer.fillColor = UIColor(named: "pinkColor")?.cgColor
        rectangleLayer.strokeColor = UIColor.clear.cgColor
        view.layer.addSublayer(rectangleLayer)

        let zoomAnimation = CABasicAnimation()
        zoomAnimation.keyPath = "path"
        zoomAnimation.duration = 10
        zoomAnimation.toValue = endPath.cgPath
        zoomAnimation.fillMode = CAMediaTimingFillMode.forwards
        zoomAnimation.isRemovedOnCompletion = true
        rectangleLayer.add(zoomAnimation, forKey: "zoom")
    }
    
    func moveOutsideLines() {
        let forwardAnimation = CABasicAnimation(keyPath: "strokeEnd")
        forwardAnimation.toValue = 1
        forwardAnimation.duration = 10
        
        forwardAnimation.fillMode = CAMediaTimingFillMode.forwards
        forwardAnimation.isRemovedOnCompletion = true
        
        rightDownLine.add(forwardAnimation, forKey: "urSoBasic")
        rightUpLine.add(forwardAnimation, forKey: "urSoBasic")
        leftDownLine.add(forwardAnimation, forKey: "urSoBasic")
        leftUpLine.add(forwardAnimation, forKey: "urSoBasic")
    }
    
    private func drawLine(startRadians: Double, endRadians: Double, clockwise: Bool) -> UIBezierPath {
        let offset = view.bounds.width - view.bounds.height
        let indent = offset / 10 - 5
        let radius = Double(view.bounds.width) / 2 - indent
        let center = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2)
        let radiansMain = startRadians * Double.pi / 180
        let endRadians = endRadians * Double.pi / 180
        let path = UIBezierPath(arcCenter: center,
                                radius: radius,
                                startAngle: radiansMain,
                                endAngle: endRadians,
                                clockwise: clockwise)
        return path
    }
    
    @objc func startTimer() {
        if timeRemaining > 10 {
            timeRemaining -= 10
            playerLayer.player?.play()
            
        } else if timeRemaining == 10 {
            playerLayer.player?.stop()
            setUpCountdown()
            timer.invalidate()
            timeRemaining = 100
        }
        
        leftCountDownLabel.text = "\(timeRemaining)"
        rightCountDownLabel.text = "\(timeRemaining)"
    }
    
    @objc func nextVideo() {
        print("Hello")
        timer.invalidate()
        timeRemaining = 100
        player.stop()
        guard let videoURL = urlArray.randomElement() else { return }
        player = AVPlayer(url: videoURL)
        setUpCountdown()
    }
}

extension AVPlayer {
    func stop() {
        self.pause()
        self.seek(to: CMTime.zero)
        
    }
}
