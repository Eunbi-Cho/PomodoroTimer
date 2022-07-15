//
//  ViewController.swift
//  PomdoroTimer
//
//  Created by 조은비 on 2022/07/14.
//

import UIKit

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
    
    func setTimerInfoViewVisable(isHidden: Bool) {
        self.timerLabel.isHidden = isHidden
        self.progressView.isHidden = isHidden
    }
    
    func configureToggleButton() {
        self.toggleButton.setTitle("Start", for: .normal)
        self.toggleButton.setTitle("Pause", for: .selected)
    }
    
    @IBAction func tabCancelButton(_ sender: UIButton) {
        switch self.timerStatus {
        case .start, .pause:
            self.timerStatus = .end
            self.cancelButton.isEnabled = false
            self.setTimerInfoViewVisable(isHidden: true)
            self.datePicker.isHidden = false
            self.toggleButton.isSelected = false
            
        default:
            break
        }
    }
    
    @IBAction func tabToggleButton(_ sender: UIButton) {
        self.duration = Int(self.datePicker.countDownDuration)
        switch self.timerStatus {
        case .start:
            self.timerStatus = .pause
            self.toggleButton.isSelected = false
            
        case .end:
            self.timerStatus = .start
            self.setTimerInfoViewVisable(isHidden: false)
            self.datePicker.isHidden = true
            self.toggleButton.isSelected = true
            self.cancelButton.isEnabled = true
            
        case .pause:
            self.timerStatus = .start
            self.toggleButton.isSelected = true
            
        }
    }

}

