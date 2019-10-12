import UIKit
import RxSwift
import SnapKit
import AVKit
import AVFoundation

class SplashViewController: BaseViewController, BindableType {
    
    //MARK: - ViewModel
    var viewModel: SplashViewModelType!
    
    // MARK: - Properties
    lazy var explainLabel: UILabel = {
        let label = UILabel()
        label.text = "Play the video below and you will know how to use this app"
        label.numberOfLines = 2
        label.textAlignment = .center
        
        view.addSubview(label)
        return label
    }()
    
    lazy var videoButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "screenshot_video"), for: .normal)
        button.rx.tap.bind {
            self.playVideo()
        }
        .disposed(by: disposeBag)
        
        view.addSubview(button)
        return button
    }()
    
    lazy var continueButton: RoundButton = {
        let cnb = RoundButton()
        cnb.setTitle("Continue", for: .normal)
        cnb.cornerRadius = 8
        cnb.backgroundColor = .systemBlue
        cnb.rx.tap.bind {
            self.dismiss(animated: true, completion: nil)
        }
        .disposed(by: disposeBag)
        
        view.addSubview(cnb)
        return cnb
    }()
    
    // MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
    }
    
    @IBAction func videoButtonPressed(_ sender: UIButton) {
        playVideo()
    }
    
    func bindViewModel() {
        let inputs = viewModel.inputs
        let outputs = viewModel.outputs
        
        //continueButton.rx.action = inputs.continueAction
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
        videoButton.snp.makeConstraints { (make) in
            make.height.equalTo(200)
            make.top.equalTo(explainLabel.snp.bottom).offset(120)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
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
