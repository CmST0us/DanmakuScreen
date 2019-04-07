import Foundation

extension URLSession {
    func syncDataTask(request: URLRequest) -> (Data?, URLResponse?, Error?) {
        let sem = DispatchSemaphore.init(value: 0)
        var retData: Data? = nil
        var retRes: URLResponse? = nil
        var retError: Error? = nil
        let task = self.dataTask(with: request) { (data, res, err) in
            retData = data
            retRes = res
            retError = err
            sem.signal()
        }
        task.resume()
        let _ = sem.wait(timeout: DispatchTime.now() + .seconds(10))
        task.cancel()
        return (retData, retRes, retError)
    }
}
