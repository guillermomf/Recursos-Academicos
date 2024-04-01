//
//  AudioContentCtr.swift
//  Recursos Academicos
//
//  Created by Daniel Cab Hernández on 01/03/19.
//  Copyright © 2019 Integra IT Soluciones. All rights reserved.
//

import UIKit
import AVKit

class AudioContentCtr: UIViewController {

    @IBOutlet weak var downloadIndicator: UIActivityIndicatorView!
    @IBOutlet weak var lblContentName: UILabel!
    @IBOutlet weak var lblContentDescription: UILabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var imgContentInfo: UIImageView!
    @IBOutlet var viewContentInfo: UIView!
    @IBOutlet weak var btnOffline: UIButton!
    @IBOutlet weak var relatedContentCollection: UICollectionView!
    @IBOutlet weak var lblPurpose: UILabel!
    @IBOutlet var titles: [UILabel]!
    
    var selectedContent : ModelContentFile!
    var player: AVPlayer?
    let playerViewController = AVPlayerViewController()
    var isOffline : Bool = false
    var relatedContent : [ModelContentFile] = []
    var selectedNode : ModelContentFile!
    
    //Variables para modo offline
    var downloadTask: URLSessionDownloadTask!
    var backgroundSession: URLSession!
    var documentDirectoryPath : URL?
    let fileManager = FileManager()
    var destinationURLForFile : URL?
    var isDownloading : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
        loadContent()
    }
    
    override func viewDidLayoutSubviews() {
        viewContentInfo.frame = cardView.layer.bounds
    }
    
    func setupView() {
        relatedContentCollection.register( MainNodeCell.nib, forCellWithReuseIdentifier: MainNodeCell.identifier)
        
        title = selectedContent.fileTypeDesc
        lblContentName.text = selectedContent.name
        lblContentDescription.text = selectedContent.description
        lblPurpose.text = selectedContent.purpose
        
        for label in titles {
            label.textColor = Settings.getBrandingScheme()?.componentColor
        }
        
        //Dar formato a la vista Info
        imgContentInfo.image = #imageLiteral(resourceName: "thumb-audio")
        btnOffline.layer.cornerRadius = 10
        btnOffline.layer.borderWidth = 1
        viewContentInfo.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        cardView.layer.cornerRadius = 5
        btnOffline.layer.borderColor = Settings.getBrandingScheme()?.componentColor.cgColor
        
        //Registrar visita
        ContentSrv.SharedInstance.registerVisit(contentId: selectedContent.id)
        
        offlineCheckup()
        loadRelatedContent()
    }
    
    func offlineCheckup() {
        let url = URL(string: selectedContent.urlContent ?? "")!
        let documentDirectoryPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let destinationURLForFile = documentDirectoryPath!.appendingPathComponent(selectedContent.name + ".\(url.pathExtension)")
        
        if FileManager.default.fileExists(atPath: destinationURLForFile.path){
            btnOffline.setImage(UIImage(named: "icon-boxOn"), for: .normal)
            btnOffline.setTitle("Disponible offline", for: .normal)
            btnOffline.backgroundColor = Settings.getBrandingScheme()?.componentColor.withAlphaComponent(0.7)
            btnOffline.setTitleColor(Settings.getBrandingScheme()?.backgroundColor, for: .normal)
            btnOffline.tintColor = Settings.getBrandingScheme()?.backgroundColor
            isOffline = true
        }
        else{
            btnOffline.setImage(UIImage(named: "icon-boxOff"), for: .normal)
            btnOffline.setTitle("Descargar offline", for: .normal)
            btnOffline.backgroundColor = Settings.getBrandingScheme()?.backgroundColor
            btnOffline.setTitleColor(Settings.getBrandingScheme()?.componentColor, for: .normal)
            btnOffline.tintColor = Settings.getBrandingScheme()?.componentColor
            isOffline = false
        }
    }
    
    func offlineSave() {
        if isOffline {
            downloadIndicator.startAnimating()
            btnOffline.isEnabled = false
            let url = URL(string: selectedContent.urlContent ?? "")!
            let documentDirectoryPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            let destinationURLForFile = documentDirectoryPath!.appendingPathComponent(selectedContent.name + ".\(url.pathExtension)")
            
            do {
                try FileManager.default.removeItem(at: destinationURLForFile)
                
                btnOffline.setImage(UIImage(named: "icon-boxOff"), for: .normal)
                btnOffline.setTitle("Descargar offline", for: .normal)
                btnOffline.backgroundColor = Settings.getBrandingScheme()?.backgroundColor
                btnOffline.setTitleColor(Settings.getBrandingScheme()?.componentColor, for: .normal)
                btnOffline.tintColor = Settings.getBrandingScheme()?.componentColor
                isOffline = false
                downloadIndicator.stopAnimating()
                btnOffline.isEnabled = true
                
                loadContent()
            } catch {
                print("Unable to delete file")
                downloadIndicator.stopAnimating()
                btnOffline.isEnabled = true
            }
            
            
        } else {
            ///Configurar el gestor de descarga
            downloadIndicator.startAnimating()
            btnOffline.isEnabled = false
            documentDirectoryPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            let backgroundSessionConfiguration = URLSessionConfiguration.background(withIdentifier: "backgroundSession\(selectedContent.id)_\(selectedContent.fileTypeId)")
            backgroundSession = Foundation.URLSession(configuration: backgroundSessionConfiguration, delegate: self, delegateQueue: OperationQueue.main)
            
            let url = URL(string: selectedContent.urlContent ?? "")!
            destinationURLForFile = documentDirectoryPath!.appendingPathComponent(selectedContent.name + ".\(url.pathExtension)")
            downloadTask = backgroundSession.downloadTask(with: url)
            downloadTask.resume()
        }
    }

    func loadContent() {
        if isOffline {
            let url = URL(string: selectedContent.urlContent ?? "")!
            let documentDirectoryPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            let destinationURLForFile = documentDirectoryPath!.appendingPathComponent(selectedContent.name + ".\(url.pathExtension)")
            
            //Configurar el reproductor de medios nativo
            let audioURL = destinationURLForFile
            player = AVPlayer(url: audioURL)
            playerViewController.player = player
            playerViewController.view.frame = cardView.layer.bounds
            playerViewController.contentOverlayView?.addSubview(viewContentInfo)
            self.addChild(playerViewController)
            cardView.addSubview(playerViewController.view)
            playerViewController.didMove(toParent: self)
        } else {
            //Configurar el reproductor de medios nativo
            let audioUrlString = selectedContent.urlContent
            let audioURL = URL(string: audioUrlString ?? "hi")
            player = AVPlayer(url: audioURL!)
            playerViewController.player = player
            playerViewController.view.frame = cardView.layer.bounds
            playerViewController.contentOverlayView?.addSubview(viewContentInfo)
            self.addChild(playerViewController)
            cardView.addSubview(playerViewController.view)
            playerViewController.didMove(toParent: self)
        }
    }
    
    func loadRelatedContent() {
        ContentSrv.SharedInstance.getRelatedContent(nodeId: selectedContent.id) { (result, list) in
            if result {
                DispatchQueue.main.async {
                    self.relatedContent = list.filter({$0.id != self.selectedContent.id})
                    self.relatedContentCollection.reloadData()
                }
            }
        }
    }
    
    @IBAction func setOffline(_ sender: Any) {
        offlineSave()
    }
}

extension AudioContentCtr : URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        do {
            try self.fileManager.moveItem(at: location, to: destinationURLForFile!)
            
            DispatchQueue.main.async {
                self.btnOffline.setImage(UIImage(named: "icon-boxOn"), for: .normal)
                self.btnOffline.setTitle("Disponible offline", for: .normal)
                self.btnOffline.backgroundColor = Settings.getBrandingScheme()?.componentColor.withAlphaComponent(0.7)
                self.btnOffline.setTitleColor(Settings.getBrandingScheme()?.backgroundColor, for: .normal)
                self.btnOffline.tintColor = Settings.getBrandingScheme()?.backgroundColor
                self.isOffline = true
                
                self.btnOffline.isEnabled = true
                self.downloadIndicator.stopAnimating()
            }
        } catch {
            self.downloadIndicator.stopAnimating()
            
            let Alert = UIAlertController(title: nil, message: "No es posible descargar el contenido por el momento, intente de nuevo mas tarde", preferredStyle: .alert)
            let Action = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
            
            Alert.addAction(Action)
            self.present(Alert, animated: true, completion: nil)
        }
    }
    
    /*
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
     
        progressBar.setProgress(Float(totalBytesWritten)/Float(totalBytesExpectedToWrite), animated: true)
        let progress = Float(totalBytesWritten)/Float(totalBytesExpectedToWrite)
        let progressString = (progress.rounded() * 100).description
     
        DispatchQueue.main.async {
            self.lblProgress.text = progressString + "%"
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
     
        self.progressBar.setProgress(Float(fileOffset)/Float(expectedTotalBytes), animated: true)
     
    }*/
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        downloadTask = nil
        
        if (error != nil) {
            print(error!.localizedDescription)
        }else{
            print("The task finished transferring data successfully")
        }
    }
}

extension AudioContentCtr : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return relatedContent.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainNodeCell.identifier, for: indexPath) as! MainNodeCell
        
        let nodeItem = relatedContent[indexPath.row]
        
        cell.lblName.text = nodeItem.name
        
        switch nodeItem.fileTypeId {
        case 6:
            cell.imgNode.image = #imageLiteral(resourceName: "icon-audio.png")
        case 5:
            cell.imgNode.image = #imageLiteral(resourceName: "icon-video2.png")
        case 7:
            cell.imgNode.image = #imageLiteral(resourceName: "icon-notes.png")
        default:
            cell.imgNode.image = #imageLiteral(resourceName: "icon-idea.png")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedNode = relatedContent[indexPath.row]
        
        switch selectedNode.fileTypeId {
        case 6:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "audioView") as! AudioContentCtr
            vc.selectedContent = selectedNode
            navigationController?.pushViewController(vc, animated: true)
        case 7:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "documentView") as! DocumentContentCtr
            vc.selectedContent = selectedNode
            navigationController?.pushViewController(vc, animated: true)
        case 5:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "audioView") as! AudioContentCtr
            vc.selectedContent = selectedNode
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            return CGSize(width: relatedContentCollection.bounds.width * 0.4, height: relatedContentCollection.bounds.height * 1)
        case .phone:
            return CGSize(width: relatedContentCollection.bounds.width * 0.4, height: relatedContentCollection.bounds.height * 1)
        default:
            return CGSize(width: relatedContentCollection.bounds.width * 0.8, height: view.bounds.height * 0.3)
        }
        
    }
}
