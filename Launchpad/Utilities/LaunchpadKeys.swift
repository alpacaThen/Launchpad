import Foundation

class LaunchpadKeys {
   private static let productKeys = ["BASIC-72", "PRO-48", "PREMIUM-56"]

   public static func isActivated(key: String) -> Bool {
      return key == productKeys[0] || key == productKeys[1] || key == productKeys[2]
   }

   public static func isPro(key: String) -> Bool {
      return key == productKeys[1] || key == productKeys[2]
   }

   public static func isPremium(key: String) -> Bool {
      return key == productKeys[2]
   }
}
