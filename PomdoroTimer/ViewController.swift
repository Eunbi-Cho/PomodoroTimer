//
//  ViewController.swift
//  PomdoroTimer
//
//  Created by 조은비 on 2022/07/14.
//

import UIKit

// 타이머 상태
enum TimerStatus {
    case start
    case pause
    case end
}

class ViewController: UIViewController {
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var toggleButton: UIButton!
    
    // 타이머에 설정된 시간을 초로 저장
    // date picker가 기본적으로 1분으로 설정되어 있어서 60초로 초기화
    var duration = 60
    // 타이머 상태 초기값이 종료된 상태
    var timerStatus: TimerStatus = .end
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureToggleButton()
    }
    
    // 버튼이 눌렸을 때 가려지고 나타나는 기능
    func setTimerInfoViewVisable(isHidden: Bool) {
        self.timerLabel.isHidden = isHidden
        self.progressView.isHidden = isHidden
    }
    
    // 버튼이 눌렸을 때 버튼 타이틀 바뀌는 기능
    func configureToggleButton() {
        self.toggleButton.setTitle("Start", for: .normal)
        self.toggleButton.setTitle("Pause", for: .selected)
    }
    
    // 취소 버튼 기능
    @IBAction func tabCancelButton(_ sender: UIButton) {
        switch self.timerStatus {
        case .start, .pause:
            // 시작, 정지 상태일 때 버튼이 활성화되고, 정지 상태로 변함
            self.timerStatus = .end
            self.cancelButton.isEnabled = false
            // 타이머뷰 가려지고 피커 나타남
            self.setTimerInfoViewVisable(isHidden: true)
            self.datePicker.isHidden = false
            // 무조건 시작 버튼으로 변함
            self.toggleButton.isSelected = false
            
        default:
            break
        }
    }
    
    // 토글 버튼 기능
    @IBAction func tabToggleButton(_ sender: UIButton) {
        self.duration = Int(self.datePicker.countDownDuration)
        switch self.timerStatus {
            
        // 시작 상태일 때 멈춤 상태로 바꾸기
        case .start:
            self.timerStatus = .pause
            self.toggleButton.isSelected = false
        
        case .end:
            // 종료 상태일 때 시작 상태로 바꾸기
            self.timerStatus = .start
            self.toggleButton.isSelected = true
            // 피커 사라지고 타이머 나타남
            self.setTimerInfoViewVisable(isHidden: false)
            self.datePicker.isHidden = true
            // 취소 버튼 활성화됨
            self.cancelButton.isEnabled = true
            
        case .pause:
            // 멈춤 상태일 때 시작 상태로 바꾸기
            self.timerStatus = .start
            self.toggleButton.isSelected = true
        }
    }

}

