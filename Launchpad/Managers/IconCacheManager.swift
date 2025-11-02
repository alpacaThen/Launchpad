import AppKit
import Foundation

@MainActor
final class IconCacheManager {
   static let shared = IconCacheManager()

   private var cache: [String: NSImage] = [:]
   private let maxCacheSize = 5000 // Maximum number of cached icons
   private var cacheKeys: [String] = [] // FIFO queue for cache eviction

   func icon(forPath path: String) -> NSImage {
      if let cachedIcon = cache[path] {
         return cachedIcon
      }

      let icon = NSWorkspace.shared.icon(forFile: path).flattenedForConsistency(targetPixelSize: LaunchpadConstants.iconDisplaySize)
      addToCache(icon: icon, forPath: path)
      return icon
   }

   private func addToCache(icon: NSImage, forPath path: String) {
      // If cache is full, remove oldest entry
      if cache.count >= maxCacheSize, let oldestKey = cacheKeys.first {
         cache.removeValue(forKey: oldestKey)
         cacheKeys.removeFirst()
      }

      cache[path] = icon
      cacheKeys.append(path)
   }

   func clearCache() {
      cache.removeAll()
      cacheKeys.removeAll()
   }
}
