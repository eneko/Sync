# Sync
Run asynchronous blocks synchronously

# Installation
With cocoapods:
```
pod 'Sync'
```

Without cocoapods:

1. Grab the `Sync.swift` file form the `Sources` folder and add it to your project.

Or:

1. Clone the repo
2. Build the framework with `archive`
3. Add the `Sync.framework` bundle to your project

# Usage
Similar to `semaphores` or `dispatch_group`, `Sync` mus be notified when the asynchronous block is complete. The asynchronous code can be running on a background thread:

```swift
let sync = Sync()
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
    // Your async code in background thread
    sync.complete()
}
sync.wait()
```

...or in the main thread:

```swift
let sync = Sync()
dispatch_async(dispatch_get_main_queue()) {
    // Your async code in main thread
    sync.complete()
}
sync.wait()
```

`Sync` waits indefinitely for the block to complete unless a timeout is specified:

```swift
let sync = Sync()
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
    // Your async code in background thread
    sync.complete()
}
sync.wait(seconds: 5) // wait at most 5 seconds and continue
```

## Synchronous Methods
Sync works even in cases where the completion block is called on the main thread, avoiding a deadlock. This makes it very simple to write synchronous methods that can be run on a command line application or inside an NSOperation or background thread.

```swift
func locationForString(name: String) -> CLLocation? {
    var location: CLLocation?
    let sync = Sync()
    CLGeocoder().geocodeAddressString(name) { (placemarks, error) in
        location = placemarks?.first?.location
        sync.complete()
    }
    sync.wait(seconds: 5)
    return location
}

let location = locationForString("San Francisco")
print(location.coordinate)
```
