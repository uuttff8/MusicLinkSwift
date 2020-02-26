import UIKit
import RxSwift
import Combine

enum ACTIONS {
    case OPEN
    case COPY
    case SHARE
    case BACK
}

struct ActionSheetResult {
    let action: ACTIONS
    let provider: SLProvider
}

func showServicesSheet(root: UIViewController, services: [SLProvider]) -> AnyPublisher<SLProvider, Error> {
    return SomePublisher { observer in
        let actionSheet = UIAlertController(title: NSLocalizedString("Select target music service", comment: ""), message: nil, preferredStyle: .actionSheet)
        
        for provider in services {
            let serviceAction = UIAlertAction(title: provider.label, style: .default) { action in
                observer(.value(provider))
                observer(.finished)
            }
            
            actionSheet.addAction(serviceAction)
        }
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel) { action in
            observer(.finished)
        }
        
        actionSheet.addAction(cancelAction)
        
        root.present(actionSheet, animated: true, completion: nil)
    }.eraseToAnyPublisher()
}

func showActionSheet(root: UIViewController, provider: SLProvider) -> AnyPublisher<ActionSheetResult, Error> {
    return SomePublisher { observer in
        let actionSheet = UIAlertController(title: provider.label, message: nil, preferredStyle: .actionSheet)
        
        let openAction = UIAlertAction(title: NSLocalizedString("Open", comment: ""), style: .default) { action in
            observer(.value(ActionSheetResult(action: .OPEN, provider: provider)))
        }
        
        let copyAction = UIAlertAction(title: NSLocalizedString("Copy", comment: ""), style: .default) { action in
            observer(.value(ActionSheetResult(action: .COPY, provider: provider)))
        }
        
        let shareAction = UIAlertAction(title: NSLocalizedString("Share", comment: ""), style: .default) { action in
            observer(.value(ActionSheetResult(action: .SHARE, provider: provider)))
        }
        
        let backAction = UIAlertAction(title: NSLocalizedString("Back", comment: ""), style: .default) { action in
            observer(.value(ActionSheetResult(action: .BACK, provider: provider)))
        }
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel) { action in
            observer(.finished)
        }
        
        actionSheet.addAction(openAction)
        actionSheet.addAction(copyAction)
        actionSheet.addAction(shareAction)
        actionSheet.addAction(backAction)
        actionSheet.addAction(cancelAction)
        
        root.present(actionSheet, animated: true, completion: nil)
    }.eraseToAnyPublisher()
}
