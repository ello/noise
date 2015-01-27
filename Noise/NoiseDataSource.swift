//
//  NoiseDataSource.swift
//  Noise
//
//  Created by Sean on 1/26/15.
//  Copyright (c) 2015 Ello. All rights reserved.
//

import UIKit

class NoiseDataSource: NSObject, UICollectionViewDataSource {

    var cells = [
        NoiseCell(kind: .Header, groupIndex: 0),
        NoiseCell(kind: .Body, groupIndex: 0),
        NoiseCell(kind: .Body, groupIndex: 0),
        NoiseCell(kind: .Footer, groupIndex: 0),
        NoiseCell(kind: .Header, groupIndex: 1),
        NoiseCell(kind: .Body, groupIndex: 1),
        NoiseCell(kind: .Footer, groupIndex: 1),
        NoiseCell(kind: .Header, groupIndex: 2),
        NoiseCell(kind: .Body, groupIndex: 2),
        NoiseCell(kind: .Body, groupIndex: 2),
        NoiseCell(kind: .Body, groupIndex: 2),
        NoiseCell(kind: .Footer, groupIndex: 2),
        NoiseCell(kind: .Header, groupIndex: 3),
        NoiseCell(kind: .Body, groupIndex: 3),
        NoiseCell(kind: .Footer, groupIndex: 3),
        NoiseCell(kind: .Header, groupIndex: 4),
        NoiseCell(kind: .Body, groupIndex: 4),
        NoiseCell(kind: .Footer, groupIndex: 4)
    ]

    struct NoiseCell {

        let kind:Kind
        let groupIndex:Int
        init(kind:Kind, groupIndex:Int) {
            self.kind = kind
            self.groupIndex = groupIndex
        }

        enum Kind {
            case Header
            case Body
            case Footer

            var size: CGSize {
                switch self {
                case .Header: return CGSize(width: 200.0, height: 50.0)
                case .Body: return CGSize(width: 200.0, height: 100.0)
                case .Footer: return CGSize(width: 200.0, height: 30.0)
                }
            }

            var identifier: String {
                switch self {
                case .Header: return "headerCell"
                case .Body: return "bodyCell"
                case .Footer: return "footerCell"
                }
            }
        }
    }


    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return countElements(cells)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let data = cells[indexPath.item]
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(data.kind.identifier, forIndexPath: indexPath) as UICollectionViewCell

        return cell
    }
}
