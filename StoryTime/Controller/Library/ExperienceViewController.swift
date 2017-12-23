//
//  ExperienceViewController.swift
//  StoryTime
//
//  Created by Administrator on 12/20/17.
//

import UIKit
import SwiftSiriWaveformView
class ExperienceViewController: BaseViewController {
    
    var timer:Timer?
    var change:CGFloat = 0.01
    var story: Library.Level.Story?
    @IBOutlet weak var audioView: SwiftSiriWaveformView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var animatedScene: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
   
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.audioView.density = 1.0
        
        timer = Timer.scheduledTimer(timeInterval: 0.009,
                                     target: self,
                                     selector: #selector(refreshAudioView(_:)),
                                     userInfo: nil,
                                     repeats: true)
        //Get Animated Scene
        if let  story = self.story {
            Library.loadStoryScreenshot(story, { (image) in
                self.animatedScene.image = image!
            })
        }
        //Get User Photo
        GameCenter().currentPlayer.loadPhoto(for: .normal, withCompletionHandler: {(image, error) in
            if image && !error {
                userImage.image = image
            }
            
        })
        //Make Horizontal TextView
        MakescrollTextView(scrollView: scrollView, displayStr: self.story?.sentences[0])
        
    }
    
    @objc internal func refreshAudioView(_:Timer) {
        if self.audioView.amplitude <= self.audioView.idleAmplitude || self.audioView.amplitude > 1.0 {
            self.change *= -1.0
        }
        
        // Simply set the amplitude to whatever you need and the view will update itself.
        self.audioView.amplitude += self.change
    }
    
    func MakescrollTextView(scrollView: UIScrollView, displayStr:String) {
        //Make Scroll Text View
        let maxSize = CGSize(width: 9999, height: 9999)
        let font = UIFont(name: "Menlo", size: 16)!
        //key function is coming!!!
        let strSize = (displayStr as NSString).boundingRect(with: maxSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font : font], context: nil)
        
        let frame = CGRect(x: 10, y: 0, width: strSize.width+50, height: scrollView.frame.size.height)
        let textView = UITextView(frame: frame)
        textView.isEditable = false
        textView.isScrollEnabled = false//let textView becomes unScrollable
        textView.font = font
        textView.text = displayStr
        
        scrollView.contentSize = CGSize(width: strSize.width, height: 50)
        
        scrollView.addSubview(textView)
    }
    @IBAction func btnBackClicked(_ sender: Any) {
        let preView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PreviewViewController") as! PreviewViewController
        preView.isHeroEnabled = true
        preView.heroModalAnimationType = .pull(direction: .right)
        
        self.hero_replaceViewController(with: preView)
    }
    
}
