import Foundation

protocol RequestServiceing {
    func request(searchTerm: String?, id: String?, completion: @escaping (Data?, Error?) -> Void)
    func configureRequest(searchTerm: String?, id: String?) -> URLRequest
    
    func prepareHeader() -> [String: String]?
    func prepareParamsForSearch(searchTerm: String?) -> [String: String]
    func prepareParamsForRandom() -> [String: String]
    
    func url(params: [String: String], path: String) -> URL
    func createDataTask(from request: URLRequest, completion: @escaping (Data? , Error?) -> Void) -> URLSessionDataTask
}

class RequestService: RequestServiceing {
    
    func request(searchTerm: String?, id: String?, completion: @escaping (Data?, Error?) -> Void)  {
        let request = configureRequest(searchTerm: searchTerm, id: id)
        let task = createDataTask(from: request, completion: completion)
        task.resume()
    }
    
    //MARK: -  Configuring data request by URL
    func configureRequest(searchTerm: String?, id: String?) -> URLRequest  {
        
        var parameters: [String: String] = [:]
        var url: URL
        
        //  If we did't receive ID  we configure request for search images by search term
        if (id == nil && searchTerm != nil) {
            parameters = self.prepareParamsForSearch(searchTerm: searchTerm)
            url = self.url(params: parameters, path: URLPath.searchPhoto.rawValue)
        }
        //  If we didn't receive search term we configure request for search image by id
        else  if (searchTerm == nil && id != nil) {
            url = self.url(params: parameters, path: "/photos/\(id!)")
        }
        //  If both function parameters is nil or by mistake not nil we configure request for search random images
        else {
            parameters = self.prepareParamsForRandom()
            url = self.url(params: parameters, path: URLPath.randomPhoto.rawValue)
        }
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = prepareHeader()
        request.httpMethod = "GET"
        
        return request
    }
    
    internal func prepareHeader() -> [String: String]? {
        var headers = [String: String]()
        headers["Authorization"] = "Client-ID fPG9yNpI-OmM9cNL8krh5vwqSsaKNGHpRWxwDN5FGX8"
        
        return headers
    }
    
    // Prepare params to get picture in search
    internal func prepareParamsForSearch(searchTerm: String?) -> [String: String] {
        var parameters = [String: String]()
        parameters["query"] = searchTerm
        parameters["page"] = String(NetworkManager.shared.page)
        parameters["per_page"] = String(30)
        return parameters
    }
    
    // Prepare params for random pictures
    internal func prepareParamsForRandom() -> [String: String] {
        var parameters = [String: String]()
        parameters["count"] = String(30)
        return parameters
    }
    
    internal func url(params: [String: String], path: String) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.unsplash.com"
        components.path = path
        
        if(!params.isEmpty) {
            components.queryItems = params.map { URLQueryItem(name: $0, value: $1)}
        }
        
        return (components.url ?? URL(string: URLPath.fullPath)!)
    }
    
    internal func createDataTask(from request: URLRequest, completion: @escaping (Data? , Error?) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
    }
    
}
