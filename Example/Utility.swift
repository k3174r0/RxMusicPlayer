//
//  Utility.swift
//  Example
//
//  Created by YOSHIMUTA YOHEI on 2019/09/13.
//  Copyright © 2019 YOSHIMUTA YOHEI. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class Utility {
    static func promptOKAlertFor(src: UIViewController,
                                 title: String?,
                                 message: String?) -> Driver<()> {
        return promptAlertFor(src: src,
                              title: title,
                              message: message,
                              cancelAction: "OK",
                              actions: [])
            .map { _ in }
    }

    static func promptAlertFor<Action: CustomStringConvertible>(src: UIViewController,
                                                                title: String?,
                                                                message: String?,
                                                                cancelAction: Action,
                                                                actions: [Action]) -> Driver<Action> {
        return promptFor(src, title, message, cancelAction, actions, .alert)
    }

    private static func promptFor<Action: CustomStringConvertible>(_ src: UIViewController,
                                                                   _ title: String?,
                                                                   _ message: String?,
                                                                   _ cancelAction: Action,
                                                                   _ actions: [Action],
                                                                   _ style: UIAlertController.Style
    ) -> Driver<Action> {
        return ControlEvent(events: Observable.create { observer in
            let alertController = UIAlertController(title: title,
                                                    message: message,
                                                    preferredStyle: style)
            alertController.addAction(UIAlertAction(title: cancelAction.description,
                                                    style: .cancel) { _ in
                    observer.on(.next(cancelAction))
                    observer.on(.completed)
            })

            for action in actions {
                alertController.addAction(UIAlertAction(title: action.description, style: .default) { _ in
                    observer.on(.next(action))
                    observer.on(.completed)
                })
            }

            src.present(alertController, animated: true, completion: nil)

            return Disposables.create {
                alertController.dismiss(animated: false, completion: nil)
            }
        }).asDriver()
    }
}
