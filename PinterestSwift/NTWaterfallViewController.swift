//
//  ViewController.swift
//  PinterestSwift
//
//  Created by Nicholas Tau on 6/30/14.
//  Copyright (c) 2014 Nicholas Tau. All rights reserved.
//

import UIKit
import Persei

let waterfallViewCellIdentify = "waterfallViewCellIdentify"

class NavigationControllerDelegate: NSObject, UINavigationControllerDelegate{
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        
        let fromVCConfromA = (fromVC as? NTTransitionProtocol)
        let fromVCConfromB = (fromVC as? NTWaterFallViewControllerProtocol)
        let fromVCConfromC = (fromVC as? NTHorizontalPageViewControllerProtocol)
        
        let toVCConfromA = (toVC as? NTTransitionProtocol)
        let toVCConfromB = (toVC as? NTWaterFallViewControllerProtocol)
        let toVCConfromC = (toVC as? NTHorizontalPageViewControllerProtocol)
        if((fromVCConfromA != nil)&&(toVCConfromA != nil)&&(
            (fromVCConfromB != nil && toVCConfromC != nil)||(fromVCConfromC != nil && toVCConfromB != nil))){
            let transition = NTTransition()
            transition.presenting = operation == .pop
            return  transition
        }else{
            return nil
        }
        
    }
}

class NTWaterfallViewController:UICollectionViewController,CHTCollectionViewDelegateWaterfallLayout, NTTransitionProtocol, NTWaterFallViewControllerProtocol{
//    class var sharedInstance: NSInteger = 0 Are u kidding me?
    var imageNameList : Array <NSString> = []
    let delegateHolder = NavigationControllerDelegate()
    
    fileprivate weak var menu: MenuView!
    
    
    fileprivate func loadMenu() {
        menu = {
            let menu = MenuView()
            menu.delegate = self
            menu.items = items
            return menu
        }()
        
        collectionView!.addSubview(menu)
    }
    
    fileprivate let items = (0..<5).map {
        MenuItem(image: UIImage(named: "menu_icon_\($0)")!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController!.delegate = delegateHolder
        self.view.backgroundColor = UIColor.yellow
        
        var index = 0
        while(index<14){
            let imageName = NSString(format: "%d.jpg", index)
            imageNameList.append(imageName)
            index += 1
        }
        
        let collection :UICollectionView = collectionView!;
        loadMenu()
        collection.frame = screenBounds
        collection.setCollectionViewLayout(CHTCollectionViewWaterfallLayout(), animated: false)
        collection.backgroundColor = UIColor.white
        collection.register(NTWaterfallViewCellType1.self, forCellWithReuseIdentifier: waterfallViewCellIdentify)
        collection.reloadData()
        
    

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize{
        let image:UIImage! = UIImage(named: self.imageNameList[(indexPath as NSIndexPath).row] as String)
        let imageHeight = image.size.height*gridWidth/image.size.width
        print(CGSize(width: gridWidth, height: imageHeight))
        return CGSize(width: gridWidth, height: imageHeight + 60)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let collectionCell: NTWaterfallViewCellType1 = collectionView.dequeueReusableCell(withReuseIdentifier: waterfallViewCellIdentify, for: indexPath) as! NTWaterfallViewCellType1
        collectionCell.imageName = self.imageNameList[(indexPath as NSIndexPath).row] as String
        collectionCell.setNeedsLayout()
        return collectionCell;
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return imageNameList.count;
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        let pageViewController =
        NTHorizontalPageViewController(collectionViewLayout: pageViewControllerLayout(), currentIndexPath:indexPath)
        pageViewController.imageNameList = imageNameList
        collectionView.setToIndexPath(indexPath)
        navigationController!.pushViewController(pageViewController, animated: true)
    }
    
    func pageViewControllerLayout () -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        let itemSize  = self.navigationController!.isNavigationBarHidden ?
        CGSize(width: screenWidth, height: screenHeight+20) : CGSize(width: screenWidth, height: screenHeight-navigationHeaderAndStatusbarHeight)
        flowLayout.itemSize = itemSize
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.scrollDirection = .horizontal
        return flowLayout
    }
    
    func viewWillAppearWithPageIndex(_ pageIndex : NSInteger) {
        var position : UICollectionViewScrollPosition =
        UICollectionViewScrollPosition.centeredHorizontally.intersection(.centeredVertically)
        let image:UIImage! = UIImage(named: self.imageNameList[pageIndex] as String)
        let imageHeight = image.size.height*gridWidth/image.size.width
        if imageHeight > 400 {//whatever you like, it's the max value for height of image
           position = .top
        }
        let currentIndexPath = IndexPath(row: pageIndex, section: 0)
        let collectionView = self.collectionView!;
        collectionView.setToIndexPath(currentIndexPath)
        if pageIndex<2{
            collectionView.setContentOffset(CGPoint.zero, animated: false)
        }else{
            collectionView.scrollToItem(at: currentIndexPath, at: position, animated: false)
        }
    }
    
    func transitionCollectionView() -> UICollectionView!{
        return collectionView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension NTWaterfallViewController: MenuViewDelegate {
    
    func menu(_ menu: MenuView, didSelectItemAt index: Int) {
       // model = model.next()
        
        let center: CGPoint = {
            let itemFrame = menu.frameOfItem(at: menu.selectedIndex!)
            let itemCenter = CGPoint(x: itemFrame.midX, y: itemFrame.midY)
            var convertedCenter = collectionView!.convert(itemCenter, from: menu)
            convertedCenter.y = 0
            
            return convertedCenter
        }()
        
        let transition = CircularRevealTransition(layer: collectionView!.layer, center: center)
        transition.start()
    }
}

