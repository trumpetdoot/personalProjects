//
//  ViewController.swift
//  randomPhoto
//
//  Created by Andy Yin on 2023-02-24.
//

import UIKit

class ViewController: UIViewController {
    let colors: [UIColor] = [
        .systemPink,
        .systemBlue,
        .systemCyan,
        .systemTeal,
        .systemMint,
        .systemIndigo,
        .systemOrange,
        .systemPurple,
        .systemYellow,
        .systemGreen
    ]
    
    private let imageView: UIImageView = {
        let imageView  = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .white
        return imageView
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPink
        view.addSubview(imageView)
        imageView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        imageView.center = view.center
        
        getRandomPhoto()
        view.addSubview(button)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        button.frame = CGRect(
            x : 30,
            y: view.frame.size.height-150 - view.safeAreaInsets.bottom,
            width: view.frame.size.width - 60,
            height: 55
        )
    }
    private let button: UIButton = {
        let button  = UIButton()
        button.backgroundColor = .white
        button.setTitle("Random Photo", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
        
    }()
    @objc func didTapButton(){
        getRandomPhoto()
        view.backgroundColor = colors.randomElement()
    }
    
    
    func getRandomPhoto(){
        let urlString = "https://source.unsplash.com/random/600x600"
        let url = URL(string: urlString)!
        guard let data = try? Data(contentsOf: url) else {
            return
        }
        imageView.image = UIImage(data: data)
    }


}

