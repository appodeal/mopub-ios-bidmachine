platform :ios, '9.0'
workspace 'BMIntegrationSample.xcworkspace'

install! 'cocoapods', :deterministic_uuids => false, :warn_for_multiple_pod_sources => false

source 'https://github.com/appodeal/CocoaPods.git'
source 'https://github.com/CocoaPods/Specs.git'

def bidmachine_header_bidding
  pod "BidMachine", "1.3.3"
  pod "BidMachine/Adapters"
end

def mopub 
  pod 'mopub-ios-sdk', '~> 5.9.0'
end

target 'BidMachine' do
    project 'BMIntegrationSample.xcodeproj'
    bidmachine_header_bidding
    mopub
end

target 'BMIntegrationSample' do
    project 'BMIntegrationSample.xcodeproj'
    bidmachine_header_bidding
    mopub
end
