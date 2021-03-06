//
//  NTWaterfallViewCell.swift
//  PinterestSwift
//
//  Created by Nicholas Tau on 6/30/14.
//  Copyright (c) 2014 Nicholas Tau. All rights reserved.
//

import UIKit

class NTWaterfallViewCell :UICollectionViewCell, NTTansitionWaterfallGridViewProtocol{
    var imageName : String?
    var imageViewContent : UIImageView = UIImageView()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.lightGray
        contentView.addSubview(imageViewContent)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        imageViewContent.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        imageViewContent.image = UIImage(named: imageName!)
    }
    
    func snapShotForTransition() -> UIView! {
        let snapShotView = UIImageView(image: self.imageViewContent.image)
        snapShotView.frame = imageViewContent.frame
        return snapShotView
    }
}

class NTWaterfallViewCellType1 :UICollectionViewCell, NTTansitionWaterfallGridViewProtocol{
   
    var imageName : String?
    var imageViewContent : UIImageView = UIImageView()
    
    var containerView = UIView()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        containerView.backgroundColor = UIColor.lightGray
        
        containerView.addSubview(imageViewContent)
        contentView.addSubview(containerView)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
       
        imageViewContent.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height - 60)
        imageViewContent.contentMode = .scaleAspectFill
        imageViewContent.image = UIImage(named: imageName!)
        imageViewContent.clipsToBounds = true
        
        containerView.clipsToBounds = true
        containerView.frame = CGRect(x: 0, y: 5, width: frame.size.width, height: frame.size.height)
        containerView.layer.cornerRadius = 15
        containerView.layer.borderWidth = 2
        containerView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func snapShotForTransition() -> UIView! {
        let snapShotView = UIImageView(image: self.imageViewContent.image)
        snapShotView.frame = imageViewContent.frame
        return snapShotView
    }
}
