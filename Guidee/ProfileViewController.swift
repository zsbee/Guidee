import UIKit
import youtube_ios_player_helper

class ProfileViewController: UIViewController {

    let videoPlayer = YTPlayerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        videoPlayer.backgroundColor = UIColor.black
        
        self.view.addSubview(videoPlayer)
        
        videoPlayer.load(withVideoId: "WGsugZ9CcNI")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.videoPlayer.frame = CGRect(x: 375/2-162/2, y: self.view.frame.height/2-81, width: 162, height: 162)
    }

}

