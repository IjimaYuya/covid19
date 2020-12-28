//
//  ViewController.swift
//  koronaDataFromAPI
//

import UIKit

// エリア一覧VCクラス

class AreaListViewController: UIViewController {

    // MARK: - Property
    
    /// プレゼンター
    private var presenter = AreaListPresenter()
    
    /// インジケーター
    private let indicator = UIActivityIndicatorView()
    /// 日付
    private let dete = Date()
    ///データフォーマッター
    private let dateFormatter = DateFormatter()

    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - IBOutlet
    
    /// テーブルビュー
    @IBOutlet weak var myTableView: UITableView!
    /// 更新ボタン
    @IBOutlet weak var reloadBtn: UIButton!
    
    // MARK: - IBAction
    
    /// 更新ボタン押下
    @IBAction func tappedReloadListBtn(_ sender: Any) {
        
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyyMdHm", options: 0, locale: Locale(identifier: "ja_JP"))
        self.navigationItem.title = "\(dateFormatter.string(from: dete)):取得"
        tuushinAPI()
    }
}

// MARK: - Private Method

private extension AreaListViewController {
    
    /// 初期処理
    private func setup() {
        setupProtocol()
        registerTableViewCell()
        setIndicate()
        tuushinAPI()
    }
    
    ///インジケーター設定
    func setIndicate() {
        indicator.center = view.center
        indicator.style = .large
        indicator.color = .blue
        view.addSubview(indicator)
    }
    
    /// API通信
    func tuushinAPI() {
        ///インジケーター開始
        self.indicator.startAnimating()
        ///API通信開始
        presenter.communicationAPI(
            sucsess: {
            self.myTableView.reloadData()
            self.indicator.stopAnimating()
            }
        )
    }
 
    /// プロトコルの設定
    private func setupProtocol() {
        myTableView.delegate = self
        myTableView.dataSource = self
    }
    
    /// セルの登録
    func registerTableViewCell() {
        myTableView.register(UINib(nibName: "CustomCell", bundle: nil) , forCellReuseIdentifier: "CustomCell")
    }
}

// MARK: - UITableViewDataSource

extension AreaListViewController: UITableViewDataSource {
    
    ///Rowの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getTodofukensuu(areaNum: section)
    }
    
    ///セルの表示内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as? CustomCell else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            return cell }
        let todofukenDetailforCell = presenter.getResponse(areaNum: indexPath.section, row: indexPath.row)
        
        //セル再利用防止
//        cell.kansennshaLabel.text = ""
//        cell.kansennshaLabel.text = ""
//        cell.kansennshaLabel.textColor = .black
        cell.setLabelText(response: todofukenDetailforCell)
        return cell
    }
  
    ///セクションのタイトル
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return presenter.getAreaName(areaNum: section)
    }
    
    ///セクションの数
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.getAreaNum()
    }
}

// MARK: - UITableViewDelegate

extension AreaListViewController: UITableViewDelegate {
    
    /// セルタッチ→各県詳細レポート画面
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let kenDetailsReportVCStoryboard = UIStoryboard(name: "KenDetailsReport", bundle: nil)
        guard let kenDetailsReportVC = kenDetailsReportVCStoryboard.instantiateViewController(identifier: "KenDetailsReportViewController") as? KenDetailsReportViewController else {
            return
        }
        kenDetailsReportVC.receiveCellSection = indexPath.section
        kenDetailsReportVC.receiveCellRow = indexPath.row
        navigationController?.pushViewController(kenDetailsReportVC, animated: true)
    }
    
    /// セクションタッチ
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let tablevewHeader = UITableViewHeaderFooterView()
        let gesturer = UITapGestureRecognizer(target: self, action: #selector(sectionTouch(sender:)))
        tablevewHeader.addGestureRecognizer(gesturer)
        tablevewHeader.tag = section
        return tablevewHeader
    }
    
    /// セクションタッチ→県名セルを表示
    @objc func sectionTouch(sender: UITapGestureRecognizer) {
        guard let section = sender.view?.tag else {
            return
        }
        /// セル表示Bool値の切り替え
//        presenter.setAreaSectionArrayIsshownToggle(areaNum: section)
        
        /// セルの表示
        myTableView.beginUpdates()
        myTableView.reloadSections([section], with: .automatic)
        myTableView.endUpdates()
    }
}

