print("Hello, world!")

// MARK: - Public Properties
    
let tool = ArgumentParser()
do {
    try tool.run()
} catch {
    print("Whoops! An error occurred: \(error)")
}
