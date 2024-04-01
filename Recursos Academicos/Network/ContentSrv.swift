//
//  ContentSrv.swift
//  Recursos Academicos
//
//  Created by Gil casimiro on 07/03/24.
//

import Foundation
import SwiftyJSON
import CoreData
import UIKit

class ContentSrv {
    static let SharedInstance = ContentSrv()
    
    func getParentNodes(ParentId : Int?, Result : @escaping(Bool) -> Void) {
        let accessToken : String = UserDefaults.standard.string(forKey: Settings.userTokenKey) ?? ""
        let url = Settings.userProfileUrl
        
        var request = URLRequest(url: url)
        var nodeList : [ModelContentNode] = []
        
        request.httpMethod = "GET"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard error == nil else {
                Result(false)
                return
            }
            
            guard let data = data else {
                Result(false)
                return
            }
            
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                
                switch statusCode {
                case 200...299:
                    //Convertir resultado esperado a formato JSON
                    let jsonData = JSON(data)
                    
                    let nodeItems = jsonData["data"]["publishingNodes"].array
                    
                    if let nodeItems = nodeItems{
                        DispatchQueue.main.async {
                            ContentSrv.SharedInstance.deleteStoredNodes()
                            for nodeItem in nodeItems {
                                let newNode = ModelContentNode(withJsonObject: nodeItem)
                                nodeList.append(newNode)
                            }
                            
                            let saved = ContentSrv.SharedInstance.storeNodes(Nodes: nodeList)
                            
                            Result(saved)
                        }
                    } else {
                        Result(false)
                    }
                    
                default:
                    Result(false)
                }
            }
        }
        
        task.resume()
    }
    
    func getResourcesPermissions(Result : @escaping(Bool, [String]) -> Void) {
        let accessToken : String = UserDefaults.standard.string(forKey: Settings.userTokenKey) ?? ""
        let url = Settings.userProfileUrl
        
        var request = URLRequest(url: url)
        var permissionsList : [String] = []
        
        request.httpMethod = "GET"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard error == nil else {
                Result(false, permissionsList)
                return
            }
            
            guard let data = data else {
                Result(false, permissionsList)
                return
            }
            
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                
                switch statusCode {
                case 200...299:
                    //Convertir resultado esperado a formato JSON
                    let jsonData = JSON(data)
                    
                    let nodeItems = jsonData["data"]["permissions"].array
                    
                    if let nodeItems = nodeItems{
                        DispatchQueue.main.async {
                            for nodeItem in nodeItems {
                                let newNode = nodeItem["title"].string ?? "NOT A NAME"
                                
                                permissionsList.append(newNode)
                            }
                            
                            //                            let stored = self.storePermissions(Permissions: permissionsList)
                            let stored = self.storePermissions(permissions: permissionsList)
                            Result(stored, permissionsList)
                        }
                    } else {
                        Result(false, permissionsList)
                    }
                    
                default:
                    Result(false, permissionsList)
                }
            }
        }
        
        task.resume()
    }
    
    /// Metodo que almacena un arreglo de permisos
    ///
    /// - Parameter Permissions: Arreglo permisos a almacenar
    /// - Returns: Retorna un booleano indicando si se almaceno correctamente
    //    func storePermissions(Permissions: [String]) -> Bool {
    //
    //        var result : Bool = true
    //        for permission in Permissions {
    //
    //            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //            let entity = NSEntityDescription.entity(forEntityName: "Permissions", in: context)
    //            let newNodeEntry = NSManagedObject(entity: entity!, insertInto: context)
    //
    //            newNodeEntry.setValue(permission, forKey: "name")
    //
    //            do {
    //                try context.save()
    //            } catch {
    //                result = false
    //            }
    //        }
    //
    //        return result
    //    }
    
    
    
    func storePermissions(permissions: [String]) -> Bool {
        let context = DataController.shared.container.viewContext
        var result = true
        
        for permission in permissions {
            let entity = NSEntityDescription.entity(forEntityName: "Permissions", in: context)!
            let newNodeEntry = NSManagedObject(entity: entity, insertInto: context)
            newNodeEntry.setValue(permission, forKey: "name")
            
            do {
                try context.save()
            } catch {
                result = false
            }
        }
        
        return result
    }
    
    
    /// - Parameter success: Tupla que retorna el resultado de la consulta y el listado de nodos recuperados de la BD local
    func getStoredPermissions(success: @escaping(Bool, [String]) -> Void) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Permissions")
        
        var permissionList : [String] = []
        
        do {
            let result = try context.fetch(request)
            
            for data in result as! [NSManagedObject] {
                
                let permission = data.value(forKey: "name") as! String
                permissionList.append(permission)
            }
            return success(true, permissionList)
            
        } catch {
            return success(false, permissionList)
        }
    }
    
    /// Metódo que vacia los nodos almacenados en la BD del dispositivo
    func deleteStoredPermissions() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Permissions")
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        
        do {
            try context.execute(request)
            try context.save()
        } catch {
            print ("Error al eliminar los nodos de la BD", error)
        }
        
    }
    
    func getUserBrandingTier(Result : @escaping() -> Void) {
        let accessToken : String = UserDefaults.standard.string(forKey: Settings.userTokenKey) ?? ""
        let url = Settings.userProfileUrl
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard error == nil else {
                Result()
                return
            }
            
            guard let data = data else {
                Result()
                return
            }
            
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                
                switch statusCode {
                case 200...299:
                    //Convertir resultado esperado a formato JSON
                    let jsonData = JSON(data)
                    
                    let nodeItems = jsonData["data"]["publishingNodes"].array
                    
                    if let nodeItems = nodeItems{
                        //Arreglo para los tier del branding
                        var tierList : [String] = []
                        
                        //Recorrer el perfil de usuario para conocer los tier
                        for item in nodeItems {
                            if item["parentId"].int == 124 {
                                let brandingTier = item["description"].string?.lowercased().trimmingCharacters(in: .whitespaces)
                                tierList.append(brandingTier!)
                            }
                            
                        }
                        
                        //Obtener el tier mas alto de acuerdo a prioridades bajo reglas de negocio
                        if tierList.contains("secundaria") {
                            UserDefaults.standard.set("secundaria", forKey: Settings.userBrandingTier)
                        } else if tierList.contains("primaria") {
                            UserDefaults.standard.set("primaria", forKey: Settings.userBrandingTier)
                        } else if tierList.contains("preescolar") {
                            UserDefaults.standard.set("preescolar", forKey: Settings.userBrandingTier)
                        } else {
                            UserDefaults.standard.removeObject(forKey: Settings.userBrandingTier)
                        }
                    } else {
                        UserDefaults.standard.removeObject(forKey: Settings.userBrandingTier)
                    }
                    
                    Result()
                default:
                    Result()
                }
            }
        }
        
        task.resume()
    }
    
    func getFilterNodes(ParentId : Int?, Result : @escaping(Bool, [ModelContentNode]) -> Void) {
        let accessToken : String = UserDefaults.standard.string(forKey: Settings.userTokenKey) ?? ""
        let url = Settings.contentNodesURL(parentId: ParentId ?? 124)
        
        var request = URLRequest(url: url)
        var nodeList : [ModelContentNode] = []
        
        request.httpMethod = "GET"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard error == nil else {
                Result(false, nodeList)
                return
            }
            
            guard let data = data else {
                Result(false, nodeList)
                return
            }
            
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                
                switch statusCode {
                case 200...299:
                    //Convertir resultado esperado a formato JSON
                    let jsonData = JSON(data)
                    let nodeItems = jsonData["data"].array
                    
                    if let nodeItems = nodeItems{
                        DispatchQueue.main.async {
                            for nodeItem in nodeItems {
                                let newNode = ModelContentNode(withJsonObject: nodeItem)
                                nodeList.append(newNode)
                            }
                            
                            Result(true, nodeList)
                        }
                    } else {
                        Result(false, nodeList)
                    }
                default:
                    Result(false, nodeList)
                }
            }
        }
        
        task.resume()
    }
    
    func getContentNodes(parentId: Int, Result : @escaping(Bool, [ModelContentFile]) -> Void) {
        let accessToken : String = UserDefaults.standard.string(forKey: Settings.userTokenKey) ?? ""
        let url = Settings.nodeContentURL(parentId: parentId)
        
        var request = URLRequest(url: url)
        var nodeList : [ModelContentFile] = []
        
        request.httpMethod = "GET"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard error == nil else {
                Result(false, nodeList)
                return
            }
            
            guard let data = data else {
                Result(false, nodeList)
                return
            }
            
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                
                switch statusCode {
                case 200...299:
                    //Convertir resultado esperado a formato JSON
                    let jsonData = JSON(data)
                    let nodeItems = jsonData["data"]["files"].array
                    
                    if let nodeItems = nodeItems{
                        DispatchQueue.main.async {
                            ContentSrv.SharedInstance.deleteStoredFileNodes(parentId: parentId)
                            for nodeItem in nodeItems {
                                let newNode = ModelContentFile(withJsonObject: nodeItem)
                                nodeList.append(newNode)
                            }
                            
                            let saved = ContentSrv.SharedInstance.storeFileNodes(ParentId: parentId, Nodes: nodeList)
                            
                            Result(saved, nodeList)
                        }
                    } else {
                        Result(false, nodeList)
                    }
                default:
                    Result(false, nodeList)
                }
            }
        }
        
        task.resume()
    }
    
    /// Metodo que almacena un arreglo de nodos pertenecientes al usuario activo
    ///
    /// - Parameter Nodes: Arreglo de nodos a almacenar
    /// - Returns: Retorna un booleano indicando si se almaceno correctamente
    func storeNodes(Nodes: [ModelContentNode]) -> Bool {
        
        var result : Bool = true
        for Node in Nodes {
            
            let context = DataController.shared.container.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "Nodes", in: context)
            let newNodeEntry = NSManagedObject(entity: entity!, insertInto: context)
            
            newNodeEntry.setValue(Node.id , forKey: "id")
            newNodeEntry.setValue(Node.name ,forKey: "name")
            newNodeEntry.setValue(Node.description ,forKey: "nodeDescription")
            newNodeEntry.setValue(Node.urlImage ,forKey: "urlImage")
            newNodeEntry.setValue(Node.parentId ,forKey: "parentId")
            newNodeEntry.setValue(Node.active ,forKey: "active")
            newNodeEntry.setValue(Node.bookId ,forKey: "bookId")
            newNodeEntry.setValue(Node.book ,forKey: "book")
            newNodeEntry.setValue(Node.nodeTypeId ,forKey: "nodeTypeId")
            newNodeEntry.setValue(Node.nodeType ,forKey: "nodeType")
            newNodeEntry.setValue(Node.nodeAccessTypeId ,forKey: "nodeAccessTypeId")
            //newNodeEntry.setValue(Node.numericalMapping ,forKey: "numericalMapping")
            newNodeEntry.setValue(Node.depth ,forKey: "depth")
            newNodeEntry.setValue(Node.pathIndex ,forKey: "pathIndex")
            newNodeEntry.setValue(Node.isPublic ,forKey: "isPublic")
            //newNodeEntry.setValue(Node.totalContent ,forKey: "totalContent")
            newNodeEntry.setValue(Node.system ,forKey: "system")
            
            do {
                try context.save()
            } catch {
                result = false
            }
        }
        
        return result
    }
    
    /// Metódo que vacia los nodos almacenados en la BD del dispositivo
    func deleteStoredNodes() {
        let context = DataController.shared.container.viewContext
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Nodes")
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        
        do {
            try context.execute(request)
            try context.save()
        } catch {
            print ("Error al eliminar los nodos de la BD", error)
        }
        
    }
    
    /// Metódo que retorna los nodos almacenados localmente en el dispositivo
    ///
    /// - Parameter success: Tupla que retorna el resultado de la consulta y el listado de nodos recuperados de la BD local
    func getStoredNodes(parentId : Int?, success: @escaping(Bool, [ModelContentNode]?) -> Void) {
        let context = DataController.shared.container.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Nodes")
        
        if let parentId = parentId {
            request.predicate = NSPredicate(format: "parentId = %@", parentId.description)
        }
        
        var nodeList : [ModelContentNode] = []
        
        do {
            let result = try context.fetch(request)
            
            for data in result as! [NSManagedObject] {
                
                let newNodeModel = ModelContentNode(withDbObject: data)
                nodeList.append(newNodeModel)
            }
            return success(true, nodeList)
            
        } catch {
            return success(false, nodeList)
        }
    }
    
    /// Metodo que almacena un arreglo de nodos de archivo pertenecientes al usuario activo
    ///
    /// - Parameter Nodes: Arreglo de nodos a almacenar
    /// - Returns: Retorna un booleano indicando si se almaceno correctamente
    func storeFileNodes(ParentId: Int,Nodes: [ModelContentFile]) -> Bool {
        
        var result : Bool = true
        for Node in Nodes {
            
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "ContentFiles", in: context)
            let newNodeEntry = NSManagedObject(entity: entity!, insertInto: context)
            
            newNodeEntry.setValue(ParentId, forKey: "ParentId")
            newNodeEntry.setValue(Node.id , forKey: "id")
            newNodeEntry.setValue(Node.name ,forKey: "name")
            newNodeEntry.setValue(Node.formativeField ,forKey: "formativeField")
            newNodeEntry.setValue(Node.isRecommended ,forKey: "isRecommended")
            newNodeEntry.setValue(Node.contentTypeDesc ,forKey: "contentTypeDesc")
            newNodeEntry.setValue(Node.fileTypeId ,forKey: "fileTypeId")
            newNodeEntry.setValue(Node.description ,forKey: "fileDescription")
            newNodeEntry.setValue(Node.purpose ,forKey: "purpose")
            newNodeEntry.setValue(Node.contentTypeId ,forKey: "contentTypeId")
            newNodeEntry.setValue(Node.purposeId ,forKey: "purposeId")
            newNodeEntry.setValue(Node.trainingField ,forKey: "trainingField")
            newNodeEntry.setValue(Node.area ,forKey: "area")
            newNodeEntry.setValue(Node.isPublic ,forKey: "isPublic")
            newNodeEntry.setValue(Node.visits ,forKey: "visits")
            newNodeEntry.setValue(Node.registerDate ,forKey: "registerDate")
            newNodeEntry.setValue(Node.thumbnails ,forKey: "thumbnails")
            newNodeEntry.setValue(Node.fileTypeDesc ,forKey: "fileTypeDesc")
            newNodeEntry.setValue(Node.active ,forKey: "active")
            newNodeEntry.setValue(Node.urlContent ,forKey: "urlContent")
            
            do {
                try context.save()
            } catch {
                result = false
            }
        }
        
        return result
    }
    
    /// Metódo que vacia los nodos almacenados en la BD del dispositivo
    func deleteStoredFileNodes(parentId : Int) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "ContentFiles")
        fetch.predicate = NSPredicate(format: "parentId = %@", parentId.description)
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        
        do {
            try context.execute(request)
            try context.save()
        } catch {
            print ("Error al eliminar los nodos de la BD", error)
        }
        
    }
    
    /// Metódo que retorna los nodos almacenados localmente en el dispositivo
    ///
    /// - Parameter success: Tupla que retorna el resultado de la consulta y el listado de nodos recuperados de la BD local
    // TODO: checar aqui
    func getStoredFileNodes(parentId : Int, success: @escaping(Bool, [ModelContentFile]?) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("Unable to access AppDelegate")
            return
        }

        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ContentFiles")
        request.predicate = NSPredicate(format: "parentId = %@", parentId.description)
        
        var nodeList : [ModelContentFile] = []
        
        do {
            let result = try context.fetch(request)
            
            for data in result as! [NSManagedObject] {
                
                let newNodeModel = ModelContentFile(withDbObject: data)
                nodeList.append(newNodeModel)
            }
            return success(true, nodeList)
            
        } catch {
            return success(false, nodeList)
        }
    }
    
    func getRelatedContent(nodeId: Int, Result : @escaping(Bool, [ModelContentFile]) -> Void) {
        let accessToken : String = UserDefaults.standard.string(forKey: Settings.userTokenKey) ?? ""
        let url = Settings.nodeRelatedContentURL(nodeId: nodeId)
        
        var request = URLRequest(url: url)
        var nodeList : [ModelContentFile] = []
        
        request.httpMethod = "GET"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard error == nil else {
                Result(false, nodeList)
                return
            }
            
            guard let data = data else {
                Result(false, nodeList)
                return
            }
            
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                
                switch statusCode {
                case 200...299:
                    //Convertir resultado esperado a formato JSON
                    let jsonData = JSON(data)
                    let nodeItems = jsonData["data"].array
                    
                    if let nodeItems = nodeItems{
                        for nodeItem in nodeItems {
                            let newNode = ModelContentFile(withJsonObject: nodeItem)
                            nodeList.append(newNode)
                        }
                        Result(true, nodeList)
                    } else {
                        Result(false, nodeList)
                    }
                default:
                    Result(false, nodeList)
                }
            }
        }
        
        task.resume()
    }
    
    /// Servicio para el registro de visitas a contenido
    ///
    /// - Parameter contentId: Id del contenido
    func registerVisit(contentId: Int) {
        let accessToken : String = UserDefaults.standard.string(forKey: Settings.userTokenKey) ?? ""
        let url = Settings.contentVisitUrl(contentId: contentId)
        
        var request = URLRequest(url: url)
        let parameters : Dictionary<String, Any> = ["id": contentId]
        
        let jsonParameters = try! JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        
        request.httpMethod = "POST"
        request.httpBody = jsonParameters
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                
                switch statusCode {
                case 200...299:
                    print("Visit logged")
                default:
                    print("Error")
                }
            }
        }
        
        task.resume()
    }
    
    func getProfessorResources(nodeId: Int, searchId: Int, Result : @escaping(Bool, [ModelContentFile]) -> Void) {
        let accessToken : String = UserDefaults.standard.string(forKey: Settings.userTokenKey) ?? ""
        var fileList : [ModelContentFile] = []
        
        let url = Settings.professorResourcesURL(nodeId: nodeId, page: 0, size: 0, searchId: searchId)
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard error == nil else {
                Result(false,fileList)
                return
            }
            
            guard let data = data else {
                Result(false, fileList)
                return
            }
            
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                
                switch statusCode {
                case 200...299:
                    //Convertir resultado esperado a formato JSON
                    let jsonData = JSON(data)
                    let nodeItems = jsonData["data"].array
                    
                    for nodeItem in nodeItems! {
                        let newNode = ModelContentFile(withJsonObject: nodeItem)
                        fileList.append(newNode)
                    }
                    
                    Result(true, fileList)
                default:
                    Result(false, fileList)
                }
            }
        }
        
        task.resume()
    }
    
    func getTextBookNodes(fileTypeId: Int, Result : @escaping(Bool, [ModelContentFile]) -> Void) {
        let accessToken : String = UserDefaults.standard.string(forKey: Settings.userTokenKey) ?? ""
        let url = Settings.textBooksContentURL(fileTypeId: fileTypeId)
        
        var request = URLRequest(url: url)
        var nodeList : [ModelContentFile] = []
        
        request.httpMethod = "GET"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard error == nil else {
                Result(false, nodeList)
                return
            }
            
            guard let data = data else {
                Result(false, nodeList)
                return
            }
            
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                
                switch statusCode {
                case 200...299:
                    //Convertir resultado esperado a formato JSON
                    let jsonData = JSON(data)
                    let nodeItems = jsonData["data"]["files"].array
                    
                    if let nodeItems = nodeItems{
                        DispatchQueue.main.async {
                            ContentSrv.SharedInstance.deleteStoredFileNodes(parentId: 145)
                            for nodeItem in nodeItems {
                                let newNode = ModelContentFile(withJsonObject: nodeItem)
                                nodeList.append(newNode)
                            }
                            
                            let saved = ContentSrv.SharedInstance.storeFileNodes(ParentId: 145, Nodes: nodeList)
                            
                            Result(saved, nodeList)
                        }
                    } else {
                        Result(false, nodeList)
                    }
                default:
                    Result(false, nodeList)
                }
            }
        }
        
        task.resume()
    }
}

