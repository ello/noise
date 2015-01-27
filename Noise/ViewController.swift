//
//  ViewController.swift
//  Noise
//
//  Created by Sean on 1/26/15.
//  Copyright (c) 2015 Ello. All rights reserved.
//

import UIKit

class ViewController: UIViewController, NoiseCollectionViewLayoutDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    let dataSource = NoiseDataSource()
    override func viewDidLoad() {
        super.viewDidLoad()

        let layout:NoiseCollectionViewLayout = collectionView.collectionViewLayout as NoiseCollectionViewLayout
        layout.columnCount = 1
        layout.sectionInset = UIEdgeInsetsZero
        layout.minimumColumnSpacing = 12
        layout.minimumInteritemSpacing = 0

        collectionView.dataSource = dataSource
        collectionView.delegate = self
        collectionView.reloadData()
    }

    func collectionView (collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let noiseCell:NoiseDataSource.NoiseCell = dataSource.cells[indexPath.item]
        return noiseCell.kind.size
    }

    func collectionView (collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,
        groupForItemAtIndexPath indexPath: NSIndexPath) -> Int {
        return self.dataSource.cells[indexPath.item].groupIndex
    }


    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        let layout:NoiseCollectionViewLayout = collectionView.collectionViewLayout as NoiseCollectionViewLayout
        layout.columnCount = size.width < size.height ? 2 : 3;
    }

    @IBAction func oneColumnTapped(sender: UIButton) {
        let layout:NoiseCollectionViewLayout = collectionView.collectionViewLayout as NoiseCollectionViewLayout
        layout.columnCount = 1
    }

    @IBAction func twoColumnTapped(sender: UIButton) {
        let layout:NoiseCollectionViewLayout = collectionView.collectionViewLayout as NoiseCollectionViewLayout
        layout.columnCount = 2
    }

    @IBAction func threeColumnTapped(sender: UIButton) {
        let layout:NoiseCollectionViewLayout = collectionView.collectionViewLayout as NoiseCollectionViewLayout
        layout.columnCount = 3
    }

}

