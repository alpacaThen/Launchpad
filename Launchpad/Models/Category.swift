import Foundation

struct Category: Identifiable, Equatable, Codable {
   let id: UUID
   var name: String
   var appPaths: Set<String>  // Store app paths instead of AppInfo to avoid duplication
   
   init(id: UUID = UUID(), name: String, appPaths: Set<String> = []) {
      self.id = id
      self.name = name
      self.appPaths = appPaths
   }
   
   // Conformance to Codable
   enum CodingKeys: String, CodingKey {
      case id, name, appPaths
   }
   
   init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      id = try container.decode(UUID.self, forKey: .id)
      name = try container.decode(String.self, forKey: .name)
      let paths = try container.decode([String].self, forKey: .appPaths)
      appPaths = Set(paths)
   }
   
   func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(id, forKey: .id)
      try container.encode(name, forKey: .name)
      try container.encode(Array(appPaths), forKey: .appPaths)
   }
}
