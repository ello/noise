//
//  ViewController.swift
//  Noise
//
//  Created by Sean on 1/26/15.
//  Copyright (c) 2015 Ello. All rights reserved.
//

import UIKit

class ViewController: UIViewController, StreamCollectionViewLayoutDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    let dataSource = NoiseDataSource()
    override func viewDidLoad() {
        super.viewDidLoad()

        let layout:StreamCollectionViewLayout = collectionView.collectionViewLayout as StreamCollectionViewLayout
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
        let layout:StreamCollectionViewLayout = collectionView.collectionViewLayout as StreamCollectionViewLayout
        layout.columnCount = size.width < size.height ? 2 : 3;
    }

    @IBAction func oneColumnTapped(sender: UIButton) {
        changeColumnCount(1)
    }

    @IBAction func twoColumnTapped(sender: UIButton) {
        changeColumnCount(2)
    }

    @IBAction func threeColumnTapped(sender: UIButton) {
        changeColumnCount(3)
    }

    private func changeColumnCount(count:Int) {
        let layout:StreamCollectionViewLayout = collectionView.collectionViewLayout as StreamCollectionViewLayout
        layout.columnCount = count
    }

}

