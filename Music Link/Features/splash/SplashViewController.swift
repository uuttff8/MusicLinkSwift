import UIKit
import RxSwift
import SnapKit
import AVKit
import AVFoundation

class SplashViewController: ViewController {
    // MARK: - Properties
    lazy var explainLabel: UILabel = {
        let label = UILabel()
        label.text = "HOW TO"
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 24)
        view.addSubview(label)
        return label
    }()
    
    lazy var howToFirst: MLCircleNumberLabel = {
        let label = MLCircleNumberLabel(index: 1, text: "Copy song link from streaming service such as Apple Music", width: Int(self.view.frame.size.width))
        view.addSubview(label)
        return label
    }()
    
    lazy var howToSecond: MLCircleNumberLabel = {
        let label = MLCircleNumberLabel(index: 2, text: "Press Paste button", width: Int(self.view.frame.size.width))
        view.addSubview(label)
        return label
    }()
    
    lazy var howToThird: MLCircleNumberLabel = {
        let label = MLCircleNumberLabel(index: 3, text: "You're done! Get links to all streaming services in the world", width: Int(self.view.frame.size.width))
        view.addSubview(label)
        return label
    }()
    
    lazy var continueButton: RoundButton = {
        let cnb = RoundButton()
        cnb.setTitle("Continue", for: .normal)
        cnb.cornerRadius = 8
        cnb.backgroundColor = .systemBlue
        cnb.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            self.navigator.dismiss(sender: self)
        }
        .disposed(by: rx.disposeBag)
        view.addSubview(cnb)
        return cnb
    }()
    
    // MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
    }
    
    // MARK: - Private
    private func makeUI() {
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }
        
        explainLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
        }
        
        howToFirst.snp.makeConstraints { (make) in
            make.top.equalTo(explainLabel).inset(100)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.height.equalTo(60)
        }
        howToSecond.snp.makeConstraints { (make) in
            make.top.equalTo(howToFirst).inset(80)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.height.equalTo(60)
        }
        howToThird.snp.makeConstraints { (make) in
            make.top.equalTo(howToSecond).inset(80)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.height.equalTo(60)
        }
        
        continueButton.snp.makeConstraints { (make) in
            make.trailing.leading.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(50)
            make.height.equalTo(50)
        }
        
    }
    
    private func playVideo() {
        guard let path = Bundle.main.path(forResource: "start_video", ofType:"MP4") else {
            debugPrint("video.m4v not found")
            return
        }
        let player = AVPlayer(url: URL(fileURLWithPath: path))
        let playerController = AVPlayerViewController()
        playerController.player = player
        self.present(playerController, animated: true) {
            player.play()
        }
    }
}
