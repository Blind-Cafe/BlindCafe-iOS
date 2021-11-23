//
//  RegionChangeViewController.swift
//  BlindCafe
//
//  Created by 권하은 on 2021/11/23.
//

import UIKit

struct Region {
    var region: String
    var states: [String]
}

class RegionChangeViewController: BaseViewController {
    
    let States = [Region(region: "서울", states: ["강남구", "강동구", "강북구","강서구", "관악구", "광진구", "구로구", "금천구", "노원구", "도봉구", "동대문구", "동작구", "마포구", "서대문구", "서초구", "성동구", "성북구", "송파구", "양천구", "영등포구", "용산구", "은평구", "종로구", "중구", "중랑구"]), Region(region: "경기", states: ["가평군", "고양시", "과천시", "광명시", "광주시", "구리시", "군포시", "김포시", "남양주시", "동두천시", "부천시", "성남시", "수원시", "시흥시", "안산시", "안성시", "안양시", "양주시", "양평군", "여주시", "연천군", "오산시", "용인시", "의왕시", "의정부시", "이천시", "파주시", "평택시", "포천시", "하남시", "화성시"]), Region(region: "인천", states: ["강화군", "계양구", "남동구", "동구", "미추홀구", "부평구", "서구", "연수구", "옹진군", "중구"]), Region(region: "강원", states: ["강릉시", "고성군", "동해시", "삼척시", "속초시", "양구군", "양양군", "영월군", "원주시", "인제군", "정선군", "철원군", "춘천시", "태백시", "평창군", "홍천군", "화천군", "횡성군"]), Region(region: "경남", states: ["거제시", "거창군", "고성군", "김해시", "남해군", "밀양시", "사천시", "산청군", "양산시", "의령군", "진주시", "창녕군", "창원시", "통영시", "하동군", "함안군", "함양군", "합천군"]), Region(region: "경북", states: ["경산시", "경주시", "고령군", "구미시", "군위군", "김천시", "문경시", "봉화군", "상주시", "성주군", "안동시", "영덕군", "영양군", "영주시", "영천시", "예천군", "울릉군", "울진군", "의성군", "청도군", "청송군", "칠곡군", "포항시"]), Region(region: "광주", states: ["광산구", "남구", "동구", "북구", "서구"]), Region(region: "대구", states: ["남구", "달서구", "달성군", "동구", "북구", "서구", "수성구", "중구"]), Region(region: "대전", states: ["대덕구", "동구", "서구", "유성구", "중구"]), Region(region: "부산", states: ["강서구", "금정구", "기장군", "남구", "동구", "동래구", "부산진구", "북구", "사상구", "사하구", "서구", "수영구", "연제구", "영도구", "중구", "해운대구"]), Region(region: "세종", states: ["세종시"]), Region(region: "울산", states: ["남구", "동구", "북구", "울주군", "중구"]), Region(region: "전남", states: ["강진군", "고흥군", "곡성군", "광양시", "구례군", "나주시", "담양군", "목포시", "무안군", "보성군", "순천시", "신안군", "여수시", "영광군", "영암군", "완도군", "장성군", "장흥군", "진도군", "함평군", "해남군", "화순군"]), Region(region: "전북", states: ["고창군", "군산시", "김제시", "남원시", "무주군", "부안군", "순창군", "완주군", "익산시", "임실군", "장수군", "전주시", "정읍시", "진안군"]), Region(region: "제주", states: ["서귀포시", "제주시"]), Region(region: "충남", states: ["계룡시", "공주시", "금산군", "논산시", "당진시", "보령시", "부여군", "서산시", "서천군", "아산시", "예산군", "천안시", "청양군", "태안군", "홍성군"]), Region(region: "충북", states: ["괴산군", "단양군", "보은군", "영동군", "옥천군", "음성군", "제천시", "증평군", "진천군", "청주시", "충주시"])]
    
    @IBOutlet weak var regionCollectionView: UICollectionView!
    @IBOutlet weak var stateCollectionView: UICollectionView!
    
    var selectedRegion: Int = 0
    var selectedState: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        regionCollectionView.register(UINib(nibName: "RegionCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RegionCollectionViewCell")
        regionCollectionView.delegate = self
        regionCollectionView.dataSource = self
        
        stateCollectionView.register(UINib(nibName: "StateCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "StateCollectionViewCell")
        stateCollectionView.delegate = self
        stateCollectionView.dataSource = self
        
        setNavigation()
    }
    
    func setNavigation() {
        let backButton: UIButton = UIButton()
        backButton.setImage(UIImage(named: "backbutton"), for: .normal)
        backButton.addTarget(self, action: #selector(popToVC), for: .touchUpInside)
        backButton.frame = CGRect(x: 18, y: 0, width: 44, height: 44)
        let addBackButton = UIBarButtonItem(customView: backButton)
        
        self.navigationItem.setLeftBarButton(addBackButton, animated: false)
        
        let titleview = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
        titleLabel.text = "지역설정"
        titleLabel.font = .SpoqaSans(.bold, size: 16)
        titleLabel.textColor = .white2
        titleLabel.textAlignment = .center
        titleview.addSubview(titleLabel)
        self.navigationItem.titleView = titleview
    }

}

extension RegionChangeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == regionCollectionView {
            return States.count
        } else {
            return States[selectedRegion].states.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == regionCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RegionCollectionViewCell", for: indexPath) as! RegionCollectionViewCell
            cell.cornerRadius = regionCollectionView.frame.width / 2 - 1
            cell.regionLabel.text = States[indexPath.row].region
            if indexPath.row == selectedRegion {
                cell.backgroundColor = .mainGreen
            } else {
                cell.backgroundColor = .clear
            }
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StateCollectionViewCell", for: indexPath) as! StateCollectionViewCell
            cell.stateLabel.text = States[selectedRegion].states[indexPath.row]
            if indexPath.row == selectedState {
                cell.backgroundColor = .darkSage
            }
            else {
                cell.backgroundColor = .clear
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == regionCollectionView {
            selectedRegion = indexPath.row
            collectionView.reloadData()
            stateCollectionView.reloadData()
        }
        else {
            selectedState = indexPath.row
            collectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == regionCollectionView {
            return CGSize(width: regionCollectionView.frame.width, height: regionCollectionView.frame.width)
        } else {
            return CGSize(width: stateCollectionView.frame.width, height: regionCollectionView.frame.width)
        }
    }
    
}
