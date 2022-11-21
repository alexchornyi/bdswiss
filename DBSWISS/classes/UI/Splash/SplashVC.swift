//
//  SplashVC.swift
//  DBSWISS
//
//  Created by Oleksandr Chornyi on 19.11.2022.
//

import UIKit

class SplashVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        Timer.scheduledTimer(withTimeInterval: 2.5, repeats: false) { [weak self] _ in
            self?.showMainScreen()
        }
    }
    

    private func showMainScreen() {
        DispatchQueue.main.async { [weak self] in
            self?.performSegue(withIdentifier: MainVC.className, sender: nil)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
