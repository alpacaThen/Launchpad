import Foundation

class LaunchPadKeys {
   private static let productKeys = ["BASIC", "PRO", "PREMIUM"]

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
