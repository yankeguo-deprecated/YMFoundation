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

  # Basic Modules

  # YMLogger
  s.subspec "YMLogger" do |sp|
    sp.source_files = "YMFoundation/YMLogger/**/*.{h,m}"
  end

  # YMUtils
  s.subspec "YMUtils" do |sp|
    sp.source_files = "YMFoundation/YMUtils/**/*.{h,m}"
  end

  # YMLoader
  s.subspec "YMLoader" do |sp|
    sp.source_files = "YMFoundation/YMLoader/**/*.{h,m}"

    sp.dependency     "YMFoundation/YMLogger"
    sp.dependency     "YMFoundation/YMUtils"
  end

  # Middle-level Modules

  # YMLocale
  s.subspec "YMLocale" do |sp|
    sp.source_files = "YMFoundation/YMLocale/**/*.{h,m}"

    sp.dependency     "YMFoundation/YMLogger"
    sp.dependency     "YMFoundation/YMUtils"
  end

  # YMError
  s.subspec "YMError" do |sp|
    sp.source_files = "YMFoundation/YMError/**/*.{h,m}"

    sp.dependency     "YMFoundation/YMLocale"
  end

  # YMAsync
  s.subspec "YMAsync" do |sp|
    sp.source_files = "YMFoundation/YMAsync/**/*.{h,m}"

    sp.dependency     "YMFoundation/YMLogger"
  end

  # YMJSON
  s.subspec "YMJSON" do |sp|
    sp.source_files = "YMFoundation/YMJSON/**/*.{h,m}"

    sp.dependency     "YMFoundation/YMLogger"
    sp.dependency     "YMFoundation/YMUtils"
  end

  # YMRouter
  s.subspec "YMRouter" do |sp|
    sp.source_files = "YMFoundation/YMRouter/**/*.{h,m}"

    sp.dependency     "YMFoundation/YMLogger"
    sp.dependency     "YMFoundation/YMUtils"
  end

  # YMRouter
  s.subspec "YMHTTP" do |sp|
    sp.source_files = "YMFoundation/YMHTTP/**/*.{h,m}"

    sp.dependency     "YMFoundation/YMLogger"
    sp.dependency     "YMFoundation/YMUtils"
  end
end
