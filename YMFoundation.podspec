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

  # YMRAC, Wrapper for ReactiveCocoa 2.5
  s.subspec "YMRAC" do |sp|
    sp.default_subspecs = "UI"
    sp.subspec "no-arc" do |spp|
      spp.source_files = "YMFoundation/YMRAC/RACObjCRuntime.{h,m}"
      spp.requires_arc = false
    end
    sp.subspec "Core" do |spp|
      spp.source_files = ["YMFoundation/YMRAC/*.{d,h,m}", "YMFoundation/YMRAC/extobjc/*.{h,m}"]
      spp.private_header_files = "YMFoundation/YMRAC/*Private.h"
      spp.exclude_files = "YMFoundation/YMRAC/*{RACObjCRuntime,UI,MK}*"
      spp.dependency "YMFoundation/YMRAC/no-arc"
    end
    sp.subspec "UI" do |spp|
      spp.source_files = "YMFoundation/YMRAC/*{UI,MK}*"
      spp.dependency "YMFoundation/YMRAC/Core"
    end
  end

  # Basic Modules

  # YMDefines
  s.subspec "YMDefines" do |sp|
    sp.source_files = "YMFoundation/YMDefines/**/*.{h,m}"
  end

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
    sp.dependency     "YMFoundation/YMUtils"
  end

  # YMJSON
  s.subspec "YMJSON" do |sp|
    sp.source_files = "YMFoundation/YMJSON/**/*.{h,m}"

    sp.dependency     "YMFoundation/YMDefines"
    sp.dependency     "YMFoundation/YMLogger"
    sp.dependency     "YMFoundation/YMUtils"
  end

  # YMRouter
  s.subspec "YMRouter" do |sp|
    sp.source_files = "YMFoundation/YMRouter/**/*.{h,m}"

    sp.dependency     "YMFoundation/YMLogger"
    sp.dependency     "YMFoundation/YMUtils"
  end

  # YMHTTP
  s.subspec "YMHTTP" do |sp|
    sp.source_files = "YMFoundation/YMHTTP/**/*.{h,m}"

    sp.dependency     "YMFoundation/YMLogger"
    sp.dependency     "YMFoundation/YMUtils"
    sp.dependency     "YMFoundation/YMError"
    sp.dependency     "YMFoundation/YMDefines"
  end

  # YMRealm
  s.subspec "YMRealm" do |sp|
    sp.requires_arc         = true
    sp.library              = "c++"

    sp.source_files         = [
      'YMFoundation/YMRealm/**/*.{h,hpp,m,mm,cpp}'
    ]

    sp.public_header_files  = [
      'YMFoundation/YMRealm/YMRealm.h',
      'YMFoundation/YMRealm/RLMArray.h',
      'YMFoundation/YMRealm/RLMCollection.h',
      'YMFoundation/YMRealm/RLMConstants.h',
      'YMFoundation/YMRealm/RLMDefines.h',
      'YMFoundation/YMRealm/RLMListBase.h',
      'YMFoundation/YMRealm/RLMMigration.h',
      'YMFoundation/YMRealm/RLMObject.h',
      'YMFoundation/YMRealm/RLMObjectBase.h',
      'YMFoundation/YMRealm/RLMObjectSchema.h',
      'YMFoundation/YMRealm/RLMOptionalBase.h',
      'YMFoundation/YMRealm/RLMPlatform.h',
      'YMFoundation/YMRealm/RLMProperty.h',
      'YMFoundation/YMRealm/RLMRealm.h',
      'YMFoundation/YMRealm/RLMRealmConfiguration.h',
      'YMFoundation/YMRealm/RLMResults.h',
      'YMFoundation/YMRealm/RLMSchema.h',
      'YMFoundation/YMRealm/Realm.h',

      # Realm.Dynamic module
      'YMFoundation/YMRealm/RLMRealm_Dynamic.h',
      'YMFoundation/YMRealm/RLMObjectBase_Dynamic.h'
    ]

    sp.private_header_files = [
      'YMFoundation/YMRealm/*_Private.h',
      'YMFoundation/YMRealm/RLMAccessor.h',
      'YMFoundation/YMRealm/RLMListBase.h',
      'YMFoundation/YMRealm/RLMObjectStore.h',
      'YMFoundation/YMRealm/RLMOptionalBase.h'
    ]

    sp.pod_target_xcconfig  = {
      'CLANG_CXX_LANGUAGE_STANDARD'     => 'compiler-default',
      'OTHER_CPLUSPLUSFLAGS'            => '-std=c++1y $(inherited)',
      'APPLICATION_EXTENSION_API_ONLY'  => 'YES'
    }

    sp.compiler_flags       = "-DREALM_HAVE_CONFIG -DREALM_COCOA_VERSION='@\"0.98.2\"' -D__ASSERTMACROS__"

    sp.header_mappings_dir  = 'YMFoundation/YMRealm'

    sp.vendored_library     = "YMFoundation/YMRealm/librealm.a"

    sp.dependency     "YMFoundation/YMJSON"
  end

  # YMWebImage(SDWebImage)
  s.subspec "YMWebImage" do |sp|
    sp.framework = 'ImageIO'
    sp.source_files = "YMFoundation/YMWebImage/**/*.{h,m}"
  end
end
