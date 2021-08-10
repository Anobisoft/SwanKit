
Pod::Spec.new do |s|

    s.name              = 'SwanKit'
    s.version           = '0.0.7'
    s.summary           = 'SwanKit - collection of tools and extesions.'

    s.description       = <<-DESC
    SwanKit - collection of tools and extesions.
    ---
    DESC

    s.homepage          = 'https://github.com/Anobisoft/SwanKit'
    s.license           = { :type => 'MIT', :file => 'LICENSE' }
    s.author            = { 'Stanislav Pletnev' => 'anobisoft@gmail.com' }
    s.social_media_url  = 'https://github.com/Anobisoft'

    s.swift_version     = '5.1'

    s.ios.deployment_target     = '10.0'
    s.tvos.deployment_target    = '10.0'
    s.osx.deployment_target     = '10.15'

    s.source = { :git => 'https://github.com/Anobisoft/SwanKit.git', :tag => s.version.to_s }
    #    s.source_files  = 'SwanKit/**/*.swift'

    s.subspec 'Foundation' do |ss|
        ss.source_files = 'SwanKit/Foundation/**/*.swift'
    end

    s.subspec 'List' do |ss|
        ss.source_files = 'SwanKit/List/**/*.swift'
    end
    
    s.subspec 'Keychain' do |ss|
        ss.source_files = 'SwanKit/Keychain/**/*.swift'
    end

    s.subspec 'AccessProvider' do |ss|
        ss.ios.deployment_target    = '10.0'
        ss.tvos.deployment_target   = '10.0'
        ss.osx.deployment_target    = '10.15'
        ss.source_files = 'SwanKit/AccessProvider/**/*.swift'
    end

    s.subspec 'UIFoundation' do |ss|
        ss.ios.deployment_target    = '10.0'
        ss.tvos.deployment_target   = '10.0'
        ss.dependency 'SwanKit/Foundation'
        ss.source_files = 'SwanKit/UIFoundation/**/*.swift'
    end

    s.subspec 'ImagePicker' do |ss|
        ss.ios.deployment_target    = '10.0'
        ss.dependency 'SwanKit/AccessProvider'
        ss.dependency 'SwanKit/Foundation'
        ss.dependency 'SwanKit/UIFoundation'
        ss.source_files = 'SwanKit/ImagePicker/*.swift'
    end

    s.subspec 'SpeechRecognizer' do |ss|
        ss.ios.deployment_target    = '10.0'
        ss.osx.deployment_target    = '10.15'
        ss.dependency 'SwanKit/AccessProvider'
        ss.source_files = 'SwanKit/SpeechRecognizer/*.swift'
    end

    s.subspec 'Appearance' do |ss|
        ss.ios.deployment_target    = '10.0'
        ss.tvos.deployment_target   = '10.0'
        ss.dependency 'SwanKit/Foundation'
        ss.source_files = 'SwanKit/Appearance/**/*.swift'
    end

    s.frameworks = 'Foundation'

end
