Pod::Spec.new do |s|

  s.name         = "RDACK"
  s.version      = "1.1.1"
  s.summary      = "RDACK is an Objc Wrapper for aicaike."
  s.homepage     = "https://github.com/iFindTA"
  s.description  = "RDACK is an objc sdk wrapper for ios developer who was working with rd's application-aicaike"
  s.license      = "MIT(LICENSE)"
  s.author             = { "nanhujiaju" => "nanhujiaju@gmail.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/iFindTA/NHACKSDKPro.git", :tag => s.version.to_s }
  s.source_files  = "NHACKSDKPro/ACKSDK/*.{h,a}"
  s.public_header_files = "NHACKSDKPro/ACKSDK/*.h"

  s.framework  = "AdSupport","SystemConfiguration"
  s.requires_arc = true
  end
