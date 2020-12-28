//
//  CustomCell.swift
//  koronaDataFromAPI
//

import UIKit


//エリア一覧セルクラス

class CustomCell: UITableViewCell {
    
    // MARK: - IBOutlet
    
    /// 都道府県名
    @IBOutlet weak var todoufukenLabel: UILabel!
    /// 総感染者数
    @IBOutlet weak var kansennshaLabel: UILabel!
    
    // MARK: - Property
    
    // MARK: - Initializer
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Method
    func setLabelText(response: Covid19ReportStruct) {
        guard let responseDate = response.responseData else {
            return
        }
        todoufukenLabel.text = response.responseData?.name_ja
        if responseDate.cases > 5000{
            kansennshaLabel.textColor = .red
        }
        kansennshaLabel.text = String(responseDate.cases)
    }
}
