//
//  UpImageCarouselDemoViewController.swift
//  TMShared
//
//  Created by Travis Ma on 8/30/19.
//  Copyright © 2019 Travis Ma. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 4
    }

}

class UpImageCarouselDemoViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = UPCarouselFlowLayout()
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width * 0.8), height: (UIScreen.main.bounds.height * 0.8))
        layout.spacingMode = .fixed(spacing: 8)
        collectionView.collectionViewLayout = layout
    }
}

extension UpImageCarouselDemoViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as? PhotoCollectionViewCell else {
            preconditionFailure()
        }
        return cell
    }
    
    
}
