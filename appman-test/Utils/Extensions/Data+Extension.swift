extension Data {
    init(ofResource name: String, withExtension ext: String?) {
        do {
            let bundle = Bundle(identifier: "co.yanika.appman-test")
            guard let url =  Bundle.main.url(forResource: name, withExtension: ext)
                    ?? bundle?.url(forResource: name, withExtension: ext) else {
                fatalError("Please check your file")
            }
            try self.init(contentsOf: url)
        } catch let err {
            fatalError("Please check your file with error `\(err)`")
        }
    }
}
