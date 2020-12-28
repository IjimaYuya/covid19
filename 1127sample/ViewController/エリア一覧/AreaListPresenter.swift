//
//  AreaListPresenter.swift
//  koronaDataFromAPI
//

import Foundation
import Alamofire

class AreaListPresenter: NSObject {

    //MARK: - Proprety
    
    /// デコーダー
    let decode = JSONDecoder()
    /// APIレスポンスデータのデコード用配列
    var covid19Array = [Covid19ReportStruct]()
    /// APIレスポンス 以下のオプショナルは変更必要
    var responseData: ResponseData?
    
    //MARK: - Init
    ///セット
    override init() {
        /// エリア一覧の配列に挿入
        for i in 1...47 {
            switch i {
            case 1:
                covid19Array.append(Covid19ReportStruct(areaName: "北海道", areaID: 0, todofukenID: i, responseData: nil))
            case 2...7:
                covid19Array.append(Covid19ReportStruct(areaName: "東北",  areaID: 1, todofukenID: i, responseData: nil))
            case 8...14:
                covid19Array.append(Covid19ReportStruct(areaName: "関東",  areaID: 2, todofukenID: i, responseData: nil))
            case 15...23:
                covid19Array.append(Covid19ReportStruct(areaName: "中部",  areaID: 3, todofukenID: i, responseData: nil))
            case 24...30:
                covid19Array.append(Covid19ReportStruct(areaName: "近畿",  areaID: 4, todofukenID: i, responseData: nil))
            case 31...35:
                covid19Array.append(Covid19ReportStruct(areaName: "中国",  areaID: 5, todofukenID: i, responseData: nil))
            case 36...39:
                covid19Array.append(Covid19ReportStruct(areaName: "四国",  areaID: 6, todofukenID: i, responseData: nil))
            case 40...47:
                covid19Array.append(Covid19ReportStruct(areaName: "九州",  areaID: 7, todofukenID: i, responseData: nil))
            default:
                print("error:covid19arrayに挿入失敗")
            }
        }
    }
    
    //MARK: - Method
    
    ///covid19のAPIに通信
    func communicationAPI(sucsess: @escaping () -> () ) {
        AF.request("https://covid19-japan-web-api.now.sh/api/v1/prefectures").responseJSON { response in
            guard let data = response.data else{
                return
            }
            do{
                let decodeData = try JSONDecoder().decode([ResponseData].self, from: data)
                
                //レスポンスのidの値とエリア一覧のtodofukenIDの値をマッピング
                decodeData.forEach{ decodeDataElement in
                    var responseID = 0
                    responseID = decodeDataElement.id
                    self.covid19Array.forEach{ covid19ArrayElement in
                        if covid19ArrayElement.todofukenID == responseID{
                            
//                            covid19Array. = decodeDataElement
                            print(self.covid19Array.enumerated())
                        }
                    }
                    
                }
            }catch let error{
                print(error)
            }
            sucsess()
        }
    }
    
    /// tableviewのrowの数
    func getTodofukensuu(areaNum: Int) -> Int {
        let filterCovid19Array = covid19Array.filter{
            $0.areaID == areaNum
        }
        return filterCovid19Array.count
    }
    
    /// tableviewのcellの情報
    func getResponse(areaNum: Int, row: Int) -> Covid19ReportStruct {
        let filterCobid19Array = covid19Array.filter{
            $0.areaID == areaNum
        }
        return filterCobid19Array[row]
    }
    
    /// エリア名の取得
    func getAreaName(areaNum: Int) -> String {
        var areaName = ""
        covid19Array.forEach{
            if $0.areaID == areaNum{
                areaName = $0.areaName
            }
        }
        return areaName
    }
    
    ///　エリア数の取得
    func getAreaNum() -> Int {
        var maxAreaID = 0
        covid19Array.forEach{
            if maxAreaID < $0.areaID{
                maxAreaID = $0.areaID
            }
        }
        return maxAreaID + 1
    }
    
    /// AreaSectionArrayのisShownのtoggle
    func setAreaSectionArrayIsshownToggle(areaNum: Int){
//        return areaSectionArray[areaNum].isShown.toggle()
    }
//}
}
