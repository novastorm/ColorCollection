//
//  ColorCell
//

import UIKit

class ColorCell: UICollectionViewCell {
    
    @IBOutlet weak var colorPanel: UIView!
    @IBOutlet weak var rgbLabel: UILabel!
    
    var color: UIColor {
        get {
            return self.colorPanel.backgroundColor ?? UIColor.white
        }
        set {
            self.colorPanel.backgroundColor = newValue
        }
    }
}
