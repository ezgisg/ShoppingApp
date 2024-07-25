//
//  OnboardingViewController.swift
//  
//
//  Created by Ezgi Sümer Günaydın on 25.07.2024.
//

import UIKit

class OnboardingViewController: UIViewController {

    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var onboardingTitle: UILabel!
    @IBOutlet weak var onboardingDescriptiion: UILabel!
    @IBOutlet var skipButtonLabel: UIView!
    @IBOutlet weak var nextButtonLabel: UILabel!
    @IBOutlet weak var pageController: UIPageControl!
    
    @IBOutlet weak var bottomStackView: UIStackView!
    @IBOutlet weak var bottomView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

