//
//  CountryCell.swift
//  TableViewJson
//
//  Created by Trinath Vikkurthi on 3/21/24.
//

import UIKit

class CountryCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var code: UILabel!
    @IBOutlet weak var capital: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
extension CountryCell {
    func setupData(model: CountryListM, query: String) {
        name.text = model.name + ", " + model.region
        code.text = model.code
        capital.text = model.capital
//        // Highlight search text
//        let attributedString = NSMutableAttributedString(string: model.name)
//        if query.count > 0 {
//            let range = (model.name as NSString).range(of: query, options: .caseInsensitive)
//            attributedString.addAttribute(.backgroundColor, value: UIColor.yellow, range: range)
//            name.attributedText = attributedString
//        } else {
//            name.text = model.name
//        }
    }
}
