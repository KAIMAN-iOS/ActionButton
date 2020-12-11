//
//  ViewController.swift
//  ios-Example
//
//  Created by GG on 11/12/2020.
//

import UIKit
import ActionButton

class ViewController: UIViewController {

    @IBOutlet weak var button: ActionButton!  {
        didSet {
            button.actionButtonType = .primary
            button.setTitle("Changer", for: .normal)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    @IBAction func changeButtonType(_ sender: Any) {
        let alertController = UIAlertController(title: "Type de bouton", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in }))
        let actions: [ActionButtonType] = [.primary, .secondary, .alert, .smoked, .swipeCardButton(isYesButton: true), .progress(backgroundColor: .black, fillColor: .red)]
        actions.forEach { action in
            alertController.addAction(UIAlertAction(title: String(describing: action), style: .default, handler: { [weak self] _ in
                self?.button.actionButtonType = action
                if case let ActionButtonType.progress(_, _) = action {
                    self?.button.startProgressUpdate(for: 5) {
                        
                    }
                }
            }))
        }
        present(alertController, animated: true, completion: nil)
    }
}

