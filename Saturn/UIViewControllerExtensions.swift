
import UIKit

extension UIViewController {
    
    private func addSaturnNavigationBar() -> UINavigationBar
    {
        let navBar : UINavigationBar = UINavigationBar()
        navigationController?.navigationBarHidden = true
        navBar.frame=CGRectMake(0, 0, self.view.frame.size.width, 70)
        self.view.addSubview(navBar)
        
        let lblSaturn : UILabel = UILabel(frame: CGRectMake(26, 0, 100, 60))
        lblSaturn.font = UIFont(name: "SanFranciscoText-Semibold", size: 14)
        lblSaturn.text = "S A T U R N"
        lblSaturn.textColor = UIColor.whiteColor()
        navBar.addSubview(lblSaturn)
        
        return navBar
    }
    
    func addSaturnNavigationBarWithCloseButton(selector : Selector)
    {
        let navBar = addSaturnNavigationBar()
        let menuButton : UIButton = UIButton(frame: CGRectMake(self.view.frame.width-85, 0, 60, 65))
        menuButton.setImage(UIImage(named: "closeButton"), forState: UIControlState.Normal)
        menuButton.addTarget(self, action: selector, forControlEvents: UIControlEvents.TouchUpInside)
        navBar.addSubview(menuButton)
    }
    
    func addSaturnNavigationBarWithMenuButton(selector : Selector)
    {
        let navBar = addSaturnNavigationBar()
        let menuButton : UIButton = UIButton(frame: CGRectMake(self.view.frame.width-85, 0, 60, 65))
        menuButton.setImage(UIImage(named: "menuButton"), forState: UIControlState.Normal)
        menuButton.addTarget(self, action: selector, forControlEvents: UIControlEvents.TouchUpInside)

        navBar.addSubview(menuButton)
    }
}