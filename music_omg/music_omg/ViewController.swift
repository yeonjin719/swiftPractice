//
//  ViewController.swift
//  music_omg
//
//  Created by 김연진 on 2023/01/13.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate {
    
    var player : AVAudioPlayer!
    var timer : Timer!
    var audioFile : URL!
    
    @IBOutlet weak var lyrics: UILabel!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var playTimeLabel: UILabel!
    @IBOutlet weak var playSilder: UISlider!
    @IBOutlet weak var totalMusicTime: UILabel!

    
    // 재생 버튼을 클릭하면
    @IBAction func touchUpPlayPauseBtn( sender : UIButton){
        
        sender.isSelected = !sender.isSelected

        // sender가 선택되면 플레이어가 재생중인지 확인하고 처리
        if sender.isSelected {
            self.player?.play()
        } else {
            self.player?.pause()
        }
        
        // sender가 선택되면 타이머 처리를 할 것인지 확인
        if sender.isSelected{
            self.mamkeAndFireTimer()
        } else{
            self.invalidateTimer()
        }
        if sender.isSelected {
            playBtn.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        } else {
            playBtn.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }
    }
    
    
    //슬라이더를 이용한 제어
    @IBAction func sliderValueControl(_ sender: UISlider) {
        let value = playSilder.value
        self.playTimeLabel.text = updateTimeLabelText(TimeInterval(sender.value))
        if sender.isTracking{ return }
        player.currentTime = TimeInterval(playSilder.value)
        
    }

    // 플레이어 초기화.
    func initplay(){
        do {
            player = try AVAudioPlayer(contentsOf: audioFile)
        } catch let error as NSError {
            print("error-initPlay : \(error)") }
        self.playSilder.maximumValue = Float(self.player.duration);
        self.playSilder.minimumValue = 0;
        self.playSilder.value = Float(self.player.currentTime);
    }
    
    // 레이블 업데이트.
    func updateTimeLabelText(_ time:TimeInterval) -> String {
        let minute : Int = Int(time/60)
        let second : Int = Int(time.truncatingRemainder(dividingBy: 60))
        let milisecond : Int = Int(time.truncatingRemainder(dividingBy: 1)*100)
        let timeText = String(format : "%02ld:%02ld:%02ld", minute, second, milisecond)
        return timeText
    }

    // 타이머를 만들고 수행해줄 메소드
    func mamkeAndFireTimer(){
        self.timer = Timer.scheduledTimer(withTimeInterval : 0.01, repeats: true, block : { [unowned self] (timer : Timer) in
            if self.playSilder.isTracking { return };
            self.playTimeLabel.text = updateTimeLabelText(player.currentTime)
            self.playSilder.value = Float(self.player.currentTime);
        })
        self.timer.fire();
    }
    
    // 음악 재생이 끝나면
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.playBtn.isSelected = false;
        self.playSilder.value = 0;
        playTimeLabel.text = "00:00:00"
        self.invalidateTimer()
    }
    
    // 타이머 해제
    func invalidateTimer(){
        self.timer.invalidate();
        self.timer = nil;
    }
    
    //시작되면
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        audioFile = Bundle.main.url(forResource: "NewJeans OMG", withExtension: "m4a")
        initplay()
        totalMusicTime.text = updateTimeLabelText(player.duration)
        playBtn.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
    }
    
}
