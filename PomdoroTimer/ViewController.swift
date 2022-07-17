//
//  ViewController.swift
//  PomdoroTimer
//
//  Created by 조은비 on 2022/07/14.
//

import UIKit
import AudioToolbox

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
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var toggleButton: UIButton!
    
    // 타이머에 설정된 시간을 초로 저장
    // date picker가 기본적으로 1분으로 설정되어 있어서 60초로 초기화
    var duration = 60
    // 타이머 상태 초기값이 종료된 상태
    var timerStatus: TimerStatus = .end
    var timer: DispatchSourceTimer?
    var currentSeconds = 0
    
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
    
    // 타이머가 동작할 때 메인에서 계속 뷰를 바꿔주도록 함
    func startTimer() {
        if self.timer == nil {
            self.timer = DispatchSource.makeTimerSource(flags: [], queue: .main)
            // 타이머가 시작되면 즉시 실행되고, 1초마다 반복되도록 설정
            self.timer?.schedule(deadline: .now(), repeating: 1)
            // 타이머가 동작할때마다 핸들러 클로저 함수가 호출됨
            self.timer?.setEventHandler(handler: { [weak self] in
                guard let self = self else { return }
                self.currentSeconds -= 1
                let hour = self.currentSeconds / 3600
                let minutes = (self.currentSeconds % 3600) / 60
                let seconds = (self.currentSeconds % 3600) % 60
                // string 포매터의 포매터 파라미터 숫자 2자리로 출력되도록 함
                self.timerLabel.text = String(format: "%02d:%02d:%02d", hour, minutes, seconds)
                // 카운트다운되고 있는 시간을 타이머에 설정된 시간으로 나누기
                self.progressView.progress = Float(self.currentSeconds) / Float(self.duration)
                // 0도에서 180도로 0.5초동안 회전
                UIView.animate(withDuration: 0.5, delay: 0, animations: {
                    self.imageView.transform = CGAffineTransform(rotationAngle: .pi)
                })
                // 180도에서 360도로 0.5초동안 회전
                UIView.animate(withDuration: 0.5, delay: 0.5, animations: {
                    self.imageView.transform = CGAffineTransform(rotationAngle: .pi * 2)
                })
                
                if self.currentSeconds <= 0 {
                    self.stopTimer()
                    // 아이폰 시스템 효과음 재생
                    AudioServicesPlaySystemSound(1005)
                }
            })
            self.timer?.resume()
        }
    }
    
    func stopTimer() {
        // 중지했다가 종료했을 때 런타임 에러를 막기 위함
        if self.timerStatus == .pause {
            self.timer?.resume()
        }
        // 시작, 정지 상태일 때 버튼이 활성화되고, 정지 상태로 변함
        self.timerStatus = .end
        self.cancelButton.isEnabled = false
        UIView.animate(withDuration: 0.5, animations: {
            self.timerLabel.alpha = 0
            self.progressView.alpha = 0
            self.datePicker.alpha = 1
            // 이미지 원상복구
            self.imageView.transform = .identity
        })
        // 무조건 시작 버튼으로 변함
        self.toggleButton.isSelected = false
        // 타이머 종료
        self.timer?.cancel()
        self.timer = nil
    }
    
    // 취소 버튼 기능
    @IBAction func tabCancelButton(_ sender: UIButton) {
        switch self.timerStatus {
        case .start, .pause:
            // 타이머 종료
            self.stopTimer()
            
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
            self.timer?.suspend()
        
        case .end:
            self.currentSeconds = self.duration
            // 종료 상태일 때 시작 상태로 바꾸기
            self.timerStatus = .start
            self.toggleButton.isSelected = true
            UIView.animate(withDuration: 0.5, animations: {
                self.timerLabel.alpha = 1
                self.progressView.alpha = 1
                self.datePicker.alpha = 0
            })
            // 취소 버튼 활성화됨
            self.cancelButton.isEnabled = true
            self.startTimer()
            
        case .pause:
            // 멈춤 상태일 때 시작 상태로 바꾸기
            self.timerStatus = .start
            self.toggleButton.isSelected = true
            self.timer?.resume()
        }
    }

}

