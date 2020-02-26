import UIKit
import Social
import MobileCoreServices
import RxSwift
import Combine

class ShareViewController: UIViewController {
    
    @Published var reload = Bool()
    var cancellable = Set<AnyCancellable>()
    let songLink = SongLink()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        wrapLoadWithReload()
//
////                onNext: { self.handleAction(result: $0) },
////                onError: { self.handleError(error: $0) }
////
//            .store(in: &self.cancellable)
//
        self.reload = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.view.alpha = 0.0
        
        UIView.animate(withDuration: 0.3) {
            self.view.alpha = 1.0
        }
    }
    
    private func wrapLoadWithReload() -> AnyPublisher<ActionSheetResult, Error> {
        return SomePublisher { observer in
            observer(.value(ActionSheetResult(action: .BACK, provider: SLProvider(name: "", label: "", url: ""))))
            
        }.eraseToAnyPublisher()
//        $reload.flatMap {_ in
//                return self.getIncomingUrl()
//                    .flatMap({ self.songLink.load($0.absoluteString) })
//                    .receive(on: RunLoop.main)
//                    .flatMap({ showServicesSheet(root: self, services: $0) })
//                    .flatMap({ showActionSheet(root: self, provider: $0) })
//                .eraseToAnyPublisher()
//        }
    }
    
    private func getIncomingUrl() -> AnyPublisher<URL, Error> {
        return SomePublisher { publisher in
            let URL_TYPE = kUTTypeURL as String
            
            if let item = self.extensionContext?.inputItems.first as? NSExtensionItem,
                let itemProvider = item.attachments?.first,
                itemProvider.hasItemConformingToTypeIdentifier(URL_TYPE) {
                
                itemProvider.loadItem(forTypeIdentifier: URL_TYPE, options: nil) { (url, error) in
                    if let error = error {
                        publisher(.failure(error))
                        publisher(.finished)
                        return
                    }
                    
                    publisher(.value(url as! URL))
                    publisher(.finished)
                }
            }
        }.eraseToAnyPublisher()
    }
    
    @objc private func openURL(_ url: URL) {
        var responder: UIResponder? = self
        
        while responder != nil {
            if let app = responder as? UIApplication {
                app.perform(#selector(openURL(_:)), with: url)
                return
            }
            
            responder = responder?.next
        }
    }
    
    private func handleAction(result: ActionSheetResult) {
        let url = URL(string: result.provider.url)!
        
        switch result.action {
        case .OPEN:
            self.openURL(url)
        case .COPY:
            UIPasteboard.general.string = result.provider.url
        case .SHARE:
            let shareView = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            
            shareView.popoverPresentationController?.sourceView = self.view
            shareView.completionWithItemsHandler = { (_, _, _, _) in
                self.exit()
            }
            
            self.present(shareView, animated: true, completion: nil)
        default:
            self.reload = true
        }
        
        if result.action != .SHARE && result.action != .BACK {
            self.exit()
        }
    }
    
    private func handleError(error: Error) {
        let alert = UIAlertController(title: NSLocalizedString("An error occured", comment: ""), message: error.localizedDescription, preferredStyle: .alert)
        let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .destructive) { _ in
            self.exit()
        }
        
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func exit(callback: ((Bool) -> Void)? = nil) {
        self.extensionContext!.completeRequest(returningItems: nil, completionHandler: callback)
    }
    
}


struct SomePublisher<Output, Failure: Swift.Error>: Publisher {
    enum Event {
        case value(Output)
        case finished
        case failure(Failure)
    }
    typealias Handler = (Event) -> Void
    private let handler: (@escaping Handler) -> Void

    private class Subscription<S: Subscriber>: Combine.Subscription where S.Input == Output, S.Failure == Failure {
        private var subscriber: S?
        private let handler: (@escaping Handler) -> Void

        init(subscriber: S, handler: @escaping (@escaping Handler) -> Void) {
            self.subscriber = subscriber
            self.handler = handler
        }

        func request(_ demand: Subscribers.Demand) {
            self.handler(self.handle)
        }

        func cancel() {
            self.subscriber = nil
        }

        private func handle(_ event: Event) {
            guard let subscriber = self.subscriber else {
                return
            }

            switch event {
            case .value(let input):
                _ = subscriber.receive(input)
            case .finished:
                subscriber.receive(completion: .finished)
            case .failure(let error):
                subscriber.receive(completion: .failure(error))
            }
        }
    }

    init(_ handler: @escaping (@escaping Handler) -> Void) {
        self.handler = handler
    }

    func receive<S>(subscriber: S) where S : Subscriber, S.Failure == Failure, S.Input == Output {
        let subscription = Subscription(subscriber: subscriber, handler: self.handler)
        subscriber.receive(subscription: subscription)
    }
}
