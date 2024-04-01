//
//  ResourceManagerCtr.swift
//  Recursos Academicos
//
//  Created by Daniel Cab Hernández on 21/03/19.
//  Copyright © 2019 Integra IT Soluciones. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ResourceManagerCtr: UIViewController {

    @IBOutlet weak var collectionAcademicLevel: UICollectionView!
    @IBOutlet weak var segmentSearch: UISegmentedControl!
    @IBOutlet weak var tbFiles: UITableView!
    @IBOutlet var viewEmpty: UIView!
    @IBOutlet var loaderView: UIView!
    @IBOutlet weak var loaderIndicator: NVActivityIndicatorView!
    
    var nodeList : [ModelContentNode] = []
    var fileList : [ModelContentFile] = []
    var selectedNodeId : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
        
    }
    
    func setupView() {
        //Registrar las celdas a utilizar en los grid
        collectionAcademicLevel.register(ResourceLevelCell.nib, forCellWithReuseIdentifier: ResourceLevelCell.identifier)
        tbFiles.register(ResourceFileCell.nib, forCellReuseIdentifier: ResourceFileCell.identifier)
        
        //Aplicar branding
        view.backgroundColor = Settings.getBrandingScheme()!.backgroundColor
        loaderIndicator.color = Settings.getBrandingScheme()!.componentColor
        segmentSearch.tintColor = Settings.getBrandingScheme()?.componentColor
        
        loadContent()
        
    }
    
    func loadResources(nodeId: Int){
        //Vaciar elementos del listado
        fileList.removeAll()
        tbFiles.reloadData()
        
        //Iniciar cargadores de contenido
        loaderIndicator.startAnimating()
        tbFiles.backgroundView = loaderView
        
        //Cargar elementos del servicio
        ContentSrv.SharedInstance.getProfessorResources(nodeId: nodeId, searchId: (segmentSearch.selectedSegmentIndex + 1)) { (result, list)  in
            
            if result {
                DispatchQueue.main.async {
                    self.fileList = list.sorted(by: {$1.name < $0.name})
                    
                    if self.fileList.count == 0 {
                        self.tbFiles.backgroundView = self.viewEmpty
                    }
                    
                    if self.loaderIndicator.isAnimating {
                        self.loaderIndicator.stopAnimating()
                    }
                    
                    self.tbFiles.reloadData()
                }
            } else {
                DispatchQueue.main.async {
                    if self.fileList.count == 0 {
                        self.tbFiles.backgroundView = self.viewEmpty
                    }
                    
                    if self.loaderIndicator.isAnimating {
                        self.loaderIndicator.stopAnimating()
                    }
                }
            }
        }
    }
    
    func loadContent() {
        //Cargar contenido
        ContentSrv.SharedInstance.getParentNodes(ParentId: nil) { (result) in
            if result {
                DispatchQueue.main.async {
                    ContentSrv.SharedInstance.getStoredNodes(parentId: nil, success: { (result, nodeList) in
                        self.nodeList = nodeList!.filter({$0.parentId == 124 && $0.id == 145})
                        self.collectionAcademicLevel.reloadData()
                        self.collectionAcademicLevel.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .centeredVertically)
                        self.loadResources(nodeId: (self.nodeList.first?.id)!)
                    })
                }
            } else {
                DispatchQueue.main.async {
                    ContentSrv.SharedInstance.getStoredNodes(parentId: nil, success: { (result, nodeList) in
                        self.nodeList = nodeList!.filter({$0.parentId == 124 && $0.id == 145})
                        self.collectionAcademicLevel.reloadData()
                        self.collectionAcademicLevel.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .centeredVertically)
                        self.loadResources(nodeId: (self.nodeList.first?.id)!)
                    })
                }
            }
        }
    }
    
    @IBAction func searchChanged(_ sender: UISegmentedControl) {
        loadResources(nodeId: selectedNodeId ?? nodeList.first?.id ?? 0)
    }
}

extension ResourceManagerCtr: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return nodeList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ResourceLevelCell.identifier, for: indexPath) as! ResourceLevelCell
        
        let nodeItem = nodeList[indexPath.row]
        
        cell.lblName.text = nodeItem.name
        
        if let imageUrlString = nodeItem.urlImage {
            let url = URL(string: imageUrlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
            cell.imgNode.sd_setImage(with: url, placeholderImage: nil, completed: nil)
        } else {
            switch nodeItem.name.lowercased().trimmingCharacters(in: .whitespaces) {
            case "preescolar":
                cell.imgNode.image = #imageLiteral(resourceName: "icon-preescolar.png")
            case "primaria":
                cell.imgNode.image = #imageLiteral(resourceName: "icon-primaria.png")
            case "secundaria":
                cell.imgNode.image = #imageLiteral(resourceName: "icon-secundaria.png")
            default:
                break
            }
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedNodeId = nodeList[indexPath.row].id
        loadResources(nodeId: selectedNodeId ?? 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            return CGSize(width: collectionAcademicLevel.bounds.width * 0.33, height: collectionAcademicLevel.bounds.height * 0.9)
        case .phone:
            return CGSize(width: collectionAcademicLevel.bounds.width * 0.33, height: collectionAcademicLevel.bounds.height * 0.9)
        default:
            return CGSize(width: collectionAcademicLevel.bounds.width * 0.8, height: view.bounds.height * 0.3)
        }
    }
}

extension ResourceManagerCtr : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ResourceFileCell.identifier) as! ResourceFileCell
        
        cell.lblName?.text = fileList[indexPath.row].name
        
        cell.lblName.textColor = Settings.getBrandingScheme()?.componentColor
        cell.viewCard.backgroundColor = Settings.getBrandingScheme()?.backgroundColor
        cell.imgIcon.tintColor = Settings.getBrandingScheme()?.componentColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let urlString = fileList[indexPath.row].urlContent ?? "hi"
        let url = URL(string: urlString)!
        
        UIApplication.shared.open(url)
    }
}
