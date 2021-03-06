//
//  AccountInfoRemoteDatamanager.swift
//  FlirtARViper
//
//  Created on 07.08.17.
//

import Foundation
import Alamofire
import SwiftyJSON
import CoreLocation

class AccountInfoRemoteDatamanager: AccountInfoRemoteDatamanagerInputProtocol {
    weak var remoteRequestHandler:AccountInfoRemoteDatamanagerOutputProtocol?
    func requestFBDisconnect() {
        let request = APIRouter.disconnectFB
        
        NetworkManager
            .shared
            .sendAPIRequest(request: request) { (js, error) in
                if error != nil {
                    self.remoteRequestHandler?.requestError(method: APIMethod.fbDisconnect, error: error!)
                } else {
                    self.remoteRequestHandler?.fbDisconnected()
                }
        }
        
    }
    
    func requestInstagramConnection(withToken token: String) {
        let request = APIRouter.saveInstagramToken(token: token)

        NetworkManager
            .shared
            .sendAPIRequestWithStringResponse(request: request, completionHandler: { (error) in

                if error != nil {
                    self.remoteRequestHandler?.requestError(method: APIMethod.postInstagram, error: error!)
                } else {
                    self.remoteRequestHandler?.instagramConnected()
                }

            })
    }
    
    func requestInstagramDisconnection() {
        let request = APIRouter.disconnectInstagram()
        
        NetworkManager
        .shared
            .sendAPIRequestWithStringResponse(request: request) { (error) in
                if error != nil {
                    self.remoteRequestHandler?.requestError(method: APIMethod.instagramDisconnect, error: error!)
                } else {
                    self.remoteRequestHandler?.instagramDisconnected()
                }
        }
        
    }
    
    func requestUpdateUserLocation(withLongitude: Double, latitude: Double) {
        
        let request = APIRouter.updateUserLocation(longitude: withLongitude, latitude: latitude)
        
        NetworkManager
            .shared
            .sendAPIRequest(request: request) { (js, error) in
                if error != nil {
                    self.remoteRequestHandler?.requestError(method: APIMethod.updateLocation, error: error!)
                } else {
                    if js!["id"] != JSON.null {
                        let latitude = js!["latitude"].doubleValue
                        let longitude = js!["longitude"].doubleValue
                        let location = CLLocation(latitude: latitude, longitude: longitude)
                        self.remoteRequestHandler?.locationUpdated(location: location)
                    } else {
                        self.remoteRequestHandler?.requestError(method: APIMethod.updateLocation, error: UpdateLocationError.invalidLocation)
                    }
                }
        }
        
        
    }
    
    func requestLogout() {
        let request = APIRouter.signOut
        
        NetworkManager
            .shared
            .sendAPIRequest(request: request) { (js, error) in
                if error != nil {
                    self.remoteRequestHandler?.requestError(method: APIMethod.signOut, error: error!)
                } else {
                    self.remoteRequestHandler?.logouted()
                }
        }
    }    
}
