//
//  FileVisorCtr.swift
//  Recursos Academicos
//
//  Created by Daniel Cab Hernández on 28/02/19.
//  Copyright © 2019 Integra IT Soluciones. All rights reserved.
//

import UIKit
import WebKit
//import NVActivityIndicatorView

class FileVisorCtr: UIViewController {

    @IBOutlet weak var viewFileVisor: UIView!
    @IBOutlet weak var webViewVisor: WKWebView!
//    @IBOutlet weak var loadIndicator: NVActivityIndicatorView!
    
    var selectedContent : ModelContentFile!
    var selectedContentPath : URL!
    var isOffline : Bool!
    var downloadTask: URLSessionDownloadTask!
    var backgroundSession: URLSession!
    let fileManager = FileManager()
    var destinationTempURLForFile : URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
//        loadIndicator.color = Settings.getBrandingScheme()?.componentColor ?? UIColor.red
        webViewVisor.navigationDelegate = self
        loadFile()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        webViewVisor.reload()
    }
    
    func loadFile() {
        
        if isOffline {
            do {
                let data = try Data(contentsOf: selectedContentPath)

                webViewVisor.load(data, mimeType: "application/pdf", characterEncodingName: "", baseURL: selectedContentPath.deletingPathExtension())
            } catch {
                print("error")
            }
        } else {
            
//            loadIndicator.startAnimating()
            let documentDirectoryPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            let backgroundSessionConfiguration = URLSessionConfiguration.background(withIdentifier: "backgroundSession\(selectedContent.id)_\(selectedContent.fileTypeId)")
            backgroundSession = Foundation.URLSession(configuration: backgroundSessionConfiguration, delegate: self, delegateQueue: OperationQueue.main)
            
            let url = URL(string: selectedContent.urlContent ?? "")!
            destinationTempURLForFile = documentDirectoryPath!.appendingPathComponent("fileTemp.\(url.pathExtension)")
            if FileManager.default.fileExists(atPath: destinationTempURLForFile!.path){
                try! FileManager.default.removeItem(at: destinationTempURLForFile!)
            }
            downloadTask = backgroundSession.downloadTask(with: url)
            downloadTask.resume()
        }
    }

}

extension FileVisorCtr : WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if let url = navigationAction.request.url {
            switch navigationAction.navigationType {
            case .linkActivated:
                decisionHandler(.cancel)
                UIApplication.shared.open(url)
                print(url)
            default:
                decisionHandler(.allow)
            }
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        loadIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
//        loadIndicator.startAnimating()
    }
}

extension FileVisorCtr : URLSessionDownloadDelegate {
func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
    
    do {
        try self.fileManager.moveItem(at: location, to: self.destinationTempURLForFile!)
        
        DispatchQueue.main.async {
            
//            self.loadIndicator.stopAnimating()
            let data = try! Data(contentsOf: self.destinationTempURLForFile!)

            self.webViewVisor.load(data, mimeType: "application/pdf", characterEncodingName: "", baseURL: self.selectedContentPath.deletingPathExtension())
            
        }
    } catch {
//        self.loadIndicator.stopAnimating()
        
        let Alert = UIAlertController(title: nil, message: "No es posible descargar el contenido por el momento, intente de nuevo mas tarde", preferredStyle: .alert)
        let Action = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
        
        Alert.addAction(Action)
        self.present(Alert, animated: true, completion: nil)
    }
}
}
