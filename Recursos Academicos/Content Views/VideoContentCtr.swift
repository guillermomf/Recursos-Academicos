////
////  VideoContentCtr.swift
////  Recursos Academicos
////
////  Created by Daniel Cab Hernández on 01/03/19.
////  Copyright © 2019 Integra IT Soluciones. All rights reserved.
////
//
//import UIKit
//import AVKit
//import VimeoNetworking
//import SwiftyJSON
//
//class VideoContentCtr: UIViewController {
//
//    @IBOutlet weak var lblContentName: UILabel!
//    @IBOutlet weak var lblContentDescription: UILabel!
//    @IBOutlet weak var cardView: UIView!
//    @IBOutlet weak var imgContentInfo: UIImageView!
//    @IBOutlet var viewContentInfo: UIView!
//    @IBOutlet weak var downloadIndicator: UIActivityIndicatorView!
//    @IBOutlet weak var btnOffline: UIButton!
//    @IBOutlet weak var relatedContentCollection: UICollectionView!
//    @IBOutlet weak var lblPurpose: UILabel!
//    @IBOutlet weak var lblNombre: UILabel!
//    @IBOutlet var titles: [UILabel]!
//
//    var selectedContent : ModelContentFile!
//    var player: AVPlayer?
//    let playerViewController = AVPlayerViewController()
//    var relatedContent : [ModelContentFile] = []
//    var selectedNode : ModelContentFile!
//
//    //Variables para modo offline
//    var downloadTask: URLSessionDownloadTask!
//    var backgroundSession: URLSession!
//    var documentDirectoryPath : URL?
//    let fileManager = FileManager()
//    var destinationURLForFile : URL?
//    var videoUrl : String?
//    var isDownloading : Bool = false
//    var isOffline : Bool = false
//
//    //Variables del cliente Vimeo
//
//    let vimeoClient = VimeoClient(appConfiguration: Settings.vimeoAppConfiguration, configureSessionManagerBlock: nil)
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//        setupView()
//        setupVimeoClient()
//    }
//
//    override func viewDidLayoutSubviews() {
//        viewContentInfo.frame = cardView.layer.bounds
//    }
//
//    func setupView() {
//        relatedContentCollection.register( MainNodeCell.nib, forCellWithReuseIdentifier: MainNodeCell.identifier)
//
//        title = selectedContent.fileTypeDesc
//        lblContentName.text = selectedContent.name
//        lblContentDescription.text = selectedContent.description
//        lblPurpose.text = selectedContent.purpose
//        lblNombre.text = selectedContent.name
//
//        for label in titles {
//            label.textColor = Settings.getBrandingScheme()?.componentColor
//        }
//
//        //Dar formato a la vista Info
//        imgContentInfo.image = #imageLiteral(resourceName: "thumb-audio")
//        viewContentInfo.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        cardView.layer.cornerRadius = 5
//        btnOffline.layer.cornerRadius = 10
//        btnOffline.layer.borderColor = Settings.getBrandingScheme()?.componentColor.cgColor
//        btnOffline.layer.borderWidth = 1
//
//        btnOffline.isEnabled = false
//
//        //Registrar visita
//        ContentSrv.SharedInstance.registerVisit(contentId: selectedContent.id)
//
//        loadRelatedContent()
//    }
//
//
//    func loadContent() {
//        let videoRequest = Request<VIMVideo>(path: "/me/videos/\(selectedContent.urlContent!)")
//
//        vimeoClient.request(videoRequest) { (Resultado) in
//            switch Resultado {
//            case .success(let result):
//                let videoJson = JSON(result.json)
//
//                self.videoUrl = videoJson["files"][1]["link"].string ?? ""
//                self.offlineCheckup()
//            case .failure(let error):
//                print("error retrieving videos: \(error)")
//            }
//        }
//    }
//
//    func loadVideo() {
//        if self.isOffline {
//            DispatchQueue.main.async {
//                let url = URL(string: self.videoUrl ?? "")!
//                let documentDirectoryPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
//                let destinationURLForFile = documentDirectoryPath!.appendingPathComponent(self.selectedContent.name + ".\(url.pathExtension)")
//                let videoURL = destinationURLForFile
//                self.player = AVPlayer(url: videoURL)
//                self.playerViewController.player = self.player
//                self.playerViewController.view.frame = self.cardView.layer.bounds
//                self.addChild(self.playerViewController)
//                self.cardView.addSubview(self.playerViewController.view)
//                self.playerViewController.didMove(toParent: self)
//            }
//        } else {
//            DispatchQueue.main.async {
//                let fileWebUrl : String? = self.videoUrl
//                //Configurar el reproductor de medios nativo
//                let videoUrlString = fileWebUrl ?? ""
//                let videoURL = URL(string: videoUrlString)
//                self.player = AVPlayer(url: videoURL!)
//                self.playerViewController.player = self.player
//                self.playerViewController.view.frame = self.cardView.layer.bounds
//                self.addChild(self.playerViewController)
//                self.cardView.addSubview(self.playerViewController.view)
//                self.playerViewController.didMove(toParent: self)
//            }
//        }
//    }
//
//    /// Configura una instancia del cliente de Vimeo y solicita identificación en caso de no existir una cuenta/token previo
//    func setupVimeoClient() {
//        //Inicializar una instancia del cliente con la configuración establecida
//        let authenticationController = AuthenticationController(client: vimeoClient, appConfiguration: Settings.vimeoAppConfiguration, configureSessionManagerBlock: nil)
//        do
//        {
//            if let account = try authenticationController.loadUserAccount()
//            {
//                //print("account loaded successfully: \(account.user?.account)")
//                authenticationController.accessToken(token: "562d9d102ad27fa8433abfdc7efc06ef") { result in
//                    switch result {
//                    case .success(let account):
//                        print("Successfully authenticated with account: \(account)")
//                        self.loadContent()
//                    case .failure(let error):
//                        print("error authenticating: \(error)")
//                    }
//                }
//            }
//            else
//            {
//                print("no saved account found, authenticate...")
//                authenticationController.accessToken(token: "562d9d102ad27fa8433abfdc7efc06ef") { result in
//                    switch result {
//                    case .success(let account):
//                        print("Successfully authenticated with account: \(account)")
//                    case .failure(let error):
//                        print("error authenticating: \(error)")
//                    }
//                }
//            }
//        }
//        catch let error
//        {
//            print("error loading account: \(error)")
//        }
//    }
//
//    func offlineCheckup() {
//
//        let url = URL(string: videoUrl ?? "")!
//        let documentDirectoryPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
//        let destinationURLForFile = documentDirectoryPath!.appendingPathComponent(selectedContent.name + ".\(url.pathExtension)")
//
//        if FileManager.default.fileExists(atPath: destinationURLForFile.path){
//            btnOffline.setImage(UIImage(named: "icon-boxOn"), for: .normal)
//            btnOffline.setTitle("Disponible offline", for: .normal)
//            btnOffline.backgroundColor = Settings.getBrandingScheme()?.componentColor.withAlphaComponent(0.7)
//            btnOffline.setTitleColor(Settings.getBrandingScheme()?.backgroundColor, for: .normal)
//            btnOffline.tintColor = Settings.getBrandingScheme()?.backgroundColor
//            isOffline = true
//            btnOffline.isEnabled = true
//        }
//        else{
//            btnOffline.setImage(UIImage(named: "icon-boxOff"), for: .normal)
//            btnOffline.setTitle("Descargar offline", for: .normal)
//            btnOffline.backgroundColor = Settings.getBrandingScheme()?.backgroundColor
//            btnOffline.setTitleColor(Settings.getBrandingScheme()?.componentColor, for: .normal)
//            btnOffline.tintColor = Settings.getBrandingScheme()?.componentColor
//            isOffline = false
//            btnOffline.isEnabled = true
//
//        }
//
//        loadVideo()
//    }
//
//    func offlineSave() {
//        if isOffline {
//            downloadIndicator.startAnimating()
//            btnOffline.isEnabled = false
//            let url = URL(string: videoUrl ?? "")!
//            let documentDirectoryPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
//            let destinationURLForFile = documentDirectoryPath!.appendingPathComponent(selectedContent.name + ".\(url.pathExtension)")
//
//            do {
//                try FileManager.default.removeItem(at: destinationURLForFile)
//
//                btnOffline.setImage(UIImage(named: "icon-boxOff"), for: .normal)
//                btnOffline.setTitle("Descargar offline", for: .normal)
//                btnOffline.backgroundColor = Settings.getBrandingScheme()?.backgroundColor
//                btnOffline.setTitleColor(Settings.getBrandingScheme()?.componentColor, for: .normal)
//                btnOffline.tintColor = Settings.getBrandingScheme()?.componentColor
//                isOffline = false
//                downloadIndicator.stopAnimating()
//                btnOffline.isEnabled = true
//
//                offlineCheckup()
//            } catch {
//                print("Unable to delete file")
//                downloadIndicator.stopAnimating()
//                btnOffline.isEnabled = true
//            }
//
//
//        } else {
//            ///Configurar el gestor de descarga
//            downloadIndicator.startAnimating()
//            btnOffline.isEnabled = false
//            documentDirectoryPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
//            let backgroundSessionConfiguration = URLSessionConfiguration.background(withIdentifier: "backgroundSession\(selectedContent.id)_\(selectedContent.fileTypeId)")
//            backgroundSession = Foundation.URLSession(configuration: backgroundSessionConfiguration, delegate: self, delegateQueue: OperationQueue.main)
//
//            let url = URL(string: videoUrl ?? "")!
//            destinationURLForFile = documentDirectoryPath!.appendingPathComponent(selectedContent.name + ".\(url.pathExtension)")
//            downloadTask = backgroundSession.downloadTask(with: url)
//            downloadTask.resume()
//        }
//    }
//
//    func loadRelatedContent() {
//        ContentSrv.SharedInstance.getRelatedContent(nodeId: selectedContent.id) { (result, list) in
//            if result {
//                DispatchQueue.main.async {
//                    self.relatedContent = list.filter({$0.id != self.selectedContent.id})
//                    self.relatedContentCollection.reloadData()
//                }
//            }
//        }
//    }
//
//    @IBAction func setOffline(_ sender: Any) {
//        offlineSave()
//    }
//}
//
//extension VideoContentCtr : URLSessionDownloadDelegate {
//    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
//
//        do {
//            try self.fileManager.moveItem(at: location, to: destinationURLForFile!)
//
//            DispatchQueue.main.async {
//                self.btnOffline.setImage(UIImage(named: "icon-boxOn"), for: .normal)
//                self.btnOffline.setTitle("Disponible offline", for: .normal)
//                self.btnOffline.backgroundColor = Settings.getBrandingScheme()?.componentColor.withAlphaComponent(0.7)
//                self.btnOffline.setTitleColor(Settings.getBrandingScheme()?.backgroundColor, for: .normal)
//                self.btnOffline.tintColor = Settings.getBrandingScheme()?.backgroundColor
//                self.isOffline = true
//
//                self.btnOffline.isEnabled = true
//                self.downloadIndicator.stopAnimating()
//            }
//        } catch {
//            self.downloadIndicator.stopAnimating()
//
//            let Alert = UIAlertController(title: nil, message: "No es posible descargar el contenido por el momento, intente de nuevo mas tarde", preferredStyle: .alert)
//            let Action = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
//
//            Alert.addAction(Action)
//            self.present(Alert, animated: true, completion: nil)
//        }
//    }
//
//    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
//        downloadTask = nil
//
//        if (error != nil) {
//            print(error!.localizedDescription)
//        }else{
//            print("The task finished transferring data successfully")
//        }
//    }
//}
//
//extension VideoContentCtr : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return relatedContent.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainNodeCell.identifier, for: indexPath) as! MainNodeCell
//
//        let nodeItem = relatedContent[indexPath.row]
//
//        cell.lblName.text = nodeItem.name
//
//        switch nodeItem.fileTypeId {
//        case 6:
//            cell.imgNode.image = #imageLiteral(resourceName: "icon-audio.png")
//        case 5:
//            cell.imgNode.image = #imageLiteral(resourceName: "icon-video2.png")
//        case 7:
//            cell.imgNode.image = #imageLiteral(resourceName: "icon-notes.png")
//        default:
//            cell.imgNode.image = #imageLiteral(resourceName: "icon-idea.png")
//        }
//
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//        selectedNode = relatedContent[indexPath.row]
//
//        switch selectedNode.fileTypeId {
//        case 6:
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "audioView") as! AudioContentCtr
//            vc.selectedContent = selectedNode
//            navigationController?.pushViewController(vc, animated: true)
//        case 7:
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "documentView") as! DocumentContentCtr
//            vc.selectedContent = selectedNode
//            navigationController?.pushViewController(vc, animated: true)
//        case 5:
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "audioView") as! AudioContentCtr
//            vc.selectedContent = selectedNode
//            navigationController?.pushViewController(vc, animated: true)
//        default:
//            break
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        switch UIDevice.current.userInterfaceIdiom {
//        case .pad:
//            return CGSize(width: relatedContentCollection.bounds.width * 0.4, height: relatedContentCollection.bounds.height * 1)
//        case .phone:
//            return CGSize(width: relatedContentCollection.bounds.width * 0.4, height: relatedContentCollection.bounds.height * 1)
//        default:
//            return CGSize(width: relatedContentCollection.bounds.width * 0.8, height: view.bounds.height * 0.3)
//        }
//
//    }
//}
