import Foundation

extension LaunchpadSettings {
   var appsPerPage: Int {
      return columns * rows
   }

   var isActivated: Bool {
      return LaunchpadKeys.isActivated(key: productKey)
   }

   var isPro: Bool {
      return LaunchpadKeys.isPro(key: productKey)
   }

   var isPremium: Bool {
      return LaunchpadKeys.isPremium(key: productKey)
   }
}
