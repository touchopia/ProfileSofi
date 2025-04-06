//
//  SettingsViewController.swift
//  ProfileSofi
//
//  Created by Phil Wright on 6/12/22.
//

import UIKit
import MessageUI

class SettingsViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var biographyTextView: UITextView!
    
    private let reuseCellIdentifier = "ProfileCell"
    private var profiles = [Profile]()
    private let kMaxItems = 6
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let filepath = Bundle.main.path(forResource: "team", ofType: "json") {
            let url = URL(fileURLWithPath: filepath)
            let jsonData = try! Data.init(contentsOf:url)
            do {
                let profiles = try JSONDecoder().decode([Profile].self, from: jsonData)
                self.profiles = profiles.reversed()
            } catch let error {
                print("Error reading json file \(error.localizedDescription)")
            }
        }
    }
    
    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
        
        guard let image = self.view.window?.screenshot(), let data = image.pngData() else {
            debugPrint("could not create screenshot")
            return
        }
        
        if MFMailComposeViewController.canSendMail() {
            
            let mailController = MFMailComposeViewController()
            mailController.mailComposeDelegate = self
            mailController.setToRecipients(["touchopia@me.com"])
            mailController.setSubject("ScreenShot for SoFi")
            mailController.setMessageBody("Heya! Here is the screenshot for my sofi profile app.", isHTML: false)
            mailController.addAttachmentData(data, mimeType: "image/png", fileName: "image.png")
            mailController.modalPresentationStyle = .overFullScreen
            self.present(mailController, animated: true)
        } else {
            debugPrint("Must be on the simultor?")
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension SettingsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let cell = collectionView.cellForItem(at: indexPath) as? ProfileCollectionViewCell {
            if let profile = cell.profile {
                self.biographyTextView.text = profile.bio
                self.countLabel.text = "\(profile.id)/300"
                self.nameLabel.text = "\(profile.firstName) \(profile.lastName)"
            }
        }
    }
}

extension SettingsViewController: UICollectionViewDataSource, LongPressDelegate {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseCellIdentifier, for: indexPath) as! ProfileCollectionViewCell
        cell.delegate = self
        let profile = profiles[indexPath.row]
        cell.profile = profile
        
        // Ensure bio has text
        if self.biographyTextView.text.isEmpty {
            self.biographyTextView.text = profile.bio
            self.countLabel.text = "\(profile.id)/300"
            self.nameLabel.text = "\(profile.firstName) \(profile.lastName)"
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return kMaxItems
    }
    
    func longPressGesturedTapped() {
        for cell in collectionView.visibleCells {
            if let cell = cell as? ProfileCollectionViewCell {
                cell.showCloseButton()
            }
        }
    }
    
    func toggleButtonsOff() {
        for cell in collectionView.visibleCells {
            if let cell = cell as? ProfileCollectionViewCell {
                cell.hideCloseButton()
            }
        }
    }
}

