import UIKit
import SnapKit
import AVKit
import AVFoundation

class SplashViewController: ViewController {
    // MARK: - Properties
    lazy var titlesStackView: StackView = {
        let subv: [UIView] = [self.explainLabel, self.howToFirst, self.howToSecond, self.howToSecond, self.howToThird]
        let stack = StackView(arrangedSubviews: subv)
        stack.spacing = 20
        stack.sizeToFit()
        view.addSubview(stack)
        return stack
    }()
    
    lazy var explainLabel: UILabel = {
        let label = UILabel()
        label.text = "HOW TO"
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 24)
        return label
    }()
    
    lazy var howToFirst: MLCircleNumberLabel = {
        let label = MLCircleNumberLabel(index: 1, text: "Copy song link from streaming service such as Apple Music", width: Int(self.view.frame.size.width))
        label.snp.makeConstraints { (make) in
            make.height.equalTo(label.frame.size.height)
        }
        return label
    }()
    
    lazy var howToSecond: MLCircleNumberLabel = {
        let label = MLCircleNumberLabel(index: 2, text: "Press Paste button", width: Int(self.view.frame.size.width))
        label.snp.makeConstraints { (make) in
            make.height.equalTo(label.frame.size.height)
        }
        return label
    }()
    
    lazy var howToThird: MLCircleNumberLabel = {
        let label = MLCircleNumberLabel(index: 3, text: "You're done! Get links to all streaming services in the world", width: Int(self.view.frame.size.width))
        label.snp.makeConstraints { (make) in
            make.height.equalTo(label.frame.size.height)
        }
        return label
    }()
    
    lazy var continueButton: RoundButton = {
        let cnb = RoundButton(type: UIButton.ButtonType.system)
        cnb.titleLabel?.font = UIFont().withSize(18)
        cnb.setTitleColor(UIColor.white, for: .normal)
        cnb.setTitle("Continue", for: .normal)
        cnb.cornerRadius = 8
        cnb.backgroundColor = .systemBlue
        cnb.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            Navigator.default.show(segue: .tabs, sender: self, transition: .present(true))
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
    override func makeUI() {
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }
        
        titlesStackView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
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
