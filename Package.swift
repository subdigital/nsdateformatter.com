import PackageDescription

let package = Package(
 name: "NSDateFormatter",
 dependencies: [
   .Package(url: "https://github.com/nestproject/Frank.git", majorVersion: 0, minor: 2),
   .Package(url: "https://github.com/kylef/Stencil", majorVersion: 0),
   .Package(url: "https://github.com/czechboy0/Jay.git", majorVersion: 0, minor: 3)
 ])
