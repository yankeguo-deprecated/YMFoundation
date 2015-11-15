Pod::Spec.new do |s|
  s.name             = "YMFoundation"
  s.version          = "0.1.0"
  s.summary          = "The basic layer of YMXian"
  s.description      = <<-DESC
  DESC

  s.homepage         = "https://github.com/YMXian/YMFoundation"
  s.license          = 'MIT'
  s.author           = { "Yanke Guo" => "guoyk@1mxian.com" }
  s.source           = { :git => "https://github.com/YMXian/YMFoundation.git", :tag => "v#{s.version.to_s}" }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = "YMFoundation/**.{h,m}"

  # YMLogger
  s.subspec "YMLogger" do |sp|
    sp.source_files = "YMFoundation/YMLogger/**/*.{h,m}"
  end

  # All others
  [
    "YMAsync",
    "YMJSON",
    "YMLoader",
    "YMLocale",
    "YMRequest",
    "YMRouter"
  ].each do |sp_name|
    s.subspec sp_name do |sp|
      sp.source_files = "YMFoundation/#{sp_name}/**/*.{h,m}"

      sp.dependency     "YMFoundation/YMLogger"
    end
  end
end
