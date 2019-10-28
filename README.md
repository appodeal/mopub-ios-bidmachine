# BidMachine adapter

This folder contains mediation adapters used to mediate BidMachine.

## Getting Started

### Installation

Add following lines into your project Podfile

```ruby
target 'Target' do
  project 'Project.xcodeproj'
  pod 'MoPub-BidMachine-Adapters', '~> 1.3'
end
```

> *Note* If you want to use BidMachine Header Bidding, please, also add following lines

```ruby
target 'Target' do
  project 'Project.xcodeproj'
  pod 'MoPub-BidMachine-Adapters', '~> 1.3'
  pod "BidMachine/Adapters"
end
```

### Initialization parameters

To initialize BidMachine set your's seller id in MPMoPubConfiguration:

```objc
MPMoPubConfiguration *sdkConfig = [[MPMoPubConfiguration alloc] initWithAdUnitIdForAppInitialization: @"AD_UNIT_ID"];
[sdkConfig setNetworkConfiguration:@{@"seller_id" : @"YOUR_SELLER_ID"} forMediationAdapter:@"BidMachineAdapterConfiguration"];
```

### Test mode

To setup test mode in BidMachine add to ***sdkConfig*** @"test_mode" : @"true". You ***sdkConfig*** will be similar to what is shown below:

```objc
[sdkConfig setNetworkConfiguration:@{@"seller_id" : @"YOUR_SELLER_ID", @"test_mode" : @"true"} forMediationAdapter:@"BidMachineAdapterConfiguration"];
```

### Logging

To setup logging in BidMachine add @"logging_enabled" : @"true" flag to ***sdkConfig***:

```objc
[sdkConfig setNetworkConfiguration:@{@"seller_id" : @"YOUR_SELLER_ID", @"logging_enabled" : @"true"} forMediationAdapter:@"BidMachineAdapterConfiguration"];
```

### Initialization

All parameters that are used during initialization are presented in table below:

| Parameter | Type | Required |
| --- | --- | --- |
| seller_id | String | Required |
| test_mode | String | Optional |
| logging_enabled | String | Optional |

Yours implementation of initialization should look like this:

```objc
- (void)initializeMoPub {
    MPMoPubConfiguration *sdkConfig = [[MPMoPubConfiguration alloc] initWithAdUnitIdForAppInitialization: @"AD_UNIT_ID"];
    NSDictionary *configurationParams = @{
                                          @"seller_id":         @"1",
                                          @"test_mode":         @"true",
                                          @"logging_enabled":   @"true"
                                          };
    [sdkConfig setNetworkConfiguration:configurationParams
                   forMediationAdapter:@"BidMachineAdapterConfiguration"];
    
    sdkConfig.loggingLevel = MPBLogLevelDebug;
    
    [[MoPub sharedInstance] initializeSdkWithConfiguration:sdkConfig
                                                completion:^{
                                                    NSLog(@"SDK initialization complete");
                                                }];
}
```

### Transfer targeting data to BidMachine

If you want to transfer targeting information you can use custom event's property ***localExtras*** which represents dictionary.
Keys for ***localExtras*** are listed below:

```
@"user_id"  --> Vendor-specific ID for the user (NSString)
@"gender"   --> User gender refer to OpenRTB 2.5 spec (kBDMUserGenderMale, kBDMUserGenderFemale, kBDMUserGenderUnknown)
@"yob"      --> User year of birth (NSNumber)
@"consent_string" --> The consent string for sending the GDPR consent (NSString)
@"keywords" --> Comma separated list of keywords about the app (NSString)
@"bcat"     --> Blocked advertiser categories using the IAB content categories. Refer to List 5.1 (NSArray <NSString *>)
@"badv"     --> Block list of advertisers by their domains (e.g., “ford.com”) (NSArray <NSString *>)
@"bapps"    --> Block list of applications by their platform-specific exchange- independent application identifiers (NSArray <NSString *>)
@"country"  --> User country (NSString)
@"city"     --> User city (NSString)
@"zip"      --> User zip code (NSString)
@"sturl"    --> Store URL (NSURL)
@"stid"     --> Numeric store id identifier (NSString)
@"paid"     --> Paid version of app (NSNumber: 0-free, 1-paid)
@"endpoint" --> String URL that should be used as base URL for sdk
```
***localExtras*** for rewarded video custom event should include one more key:
```
@"location" - User's location (CLLocation)
```
Also all targeting data can be passed throug MoPub backend and can be configured as JSON in MoPub UI

### Banners implementation

In the snippet below you can see transfering of local extra data:

```objc
- (void)loadBannerAd {
    self.adView = [[MPAdView alloc] initWithAdUnitId:@"AD_UNIT_ID"];
    self.adView.delegate = self;
    self.adView.frame = CGRectMake((self.view.bounds.size.width - 320) / 2,
                                   self.view.bounds.size.height - 50,
                                   320,
                                   50);
    [self.view addSubview:self.adView];
    NSDictionary *localExtras = @{
                                  @"seller_id":         @"YOUR_SELLER_ID",
                                  @"coppa":             @"true",
                                  @"consent_string":    @"BOEFEAyOEFEAyAHABDENAI4AAAB9vABAASA",
                                  @"logging_enabled":   @"true",
                                  @"test_mode":         @"true",
                                  @"banner_width":      @"320",
                                  @"user_id":           @"user123",
                                  @"gender":            @"F",
                                  @"yob":               @2000,
                                  @"keywords":          @"Keyword_1,Keyword_2,Keyword_3,Keyword_4",
                                  @"country":           @"USA",
                                  @"city":              @"Los Angeles",
                                  @"zip":               @"90001–90084",
                                  @"sturl":             @"https://store_url.com",
                                  @"paid":              @"true",
                                  @"bcat":              @"IAB-1,IAB-3,IAB-5",
                                  @"badv":              @"https://domain_1.com,https://domain_2.org",
                                  @"bapps":             @"com.test.application_1,com.test.application_2,com.test.application_3",
                                  @"price_floors":      @[
                                          @{ @"id_1": @300.06 },
                                          @{ @"id_2": @1000 },
                                          @302.006,
                                          @1002
                                          ]
                                  };
    [self.adView setLocalExtras:localExtras];
    [self.adView loadAd];
}
```

But also you can receive extra data from server. It will be sent in (NSDictionary *)***info*** of requests methods and may look like this:

```json
{
  "badv": "https://domain_1.com,https://domain_2.org",
  "banner_width": "320",
  "bapps": "com.test.application_1,com.test.application_2,com.test.application_3",
  "bcat": "IAB-1,IAB-3,IAB-5",
  "city": "Los Angeles",
  "consent_string": "BOEFEAyOEFEAyAHABDENAI4AAAB9vABAASA",
  "coppa": "true",
  "country": "USA",
  "gender": "F",
  "keywords": "Keyword_1,Keyword_2,Keyword_3,Keyword_4",
  "logging_enabled": "true",
  "paid": "true",
  "price_floors": [
    {
      "id_1": 300.06
    },
    {
      "id_2": 1000
    },
    302.006,
    1002
  ],
  "seller_id": "YOUR_SELLER_ID",
  "sturl": "https://store_url.com",
  "test_mode": "true",
  "user_id": "user123",
  "yob": 2000,
  "zip": "90001–90084"
}
```

### Interstitial implementation

With local extra data:

```objc
- (void)loadInterstitialAds {
    self.interstitial = [MPInterstitialAdController interstitialAdControllerForAdUnitId:@"AD_UNIT_ID"];
    self.interstitial.delegate = self;
    NSDictionary *localExtras = @{
                                  @"seller_id":         @"YOUR_SELLER_ID",
                                  @"coppa":             @"true",
                                  @"consent_string":    @"BOEFEAyOEFEAyAHABDENAI4AAAB9vABAASA",
                                  @"logging_enabled":   @"true",
                                  @"test_mode":         @"true",
                                  @"ad_content_type":   @"All",
                                  @"user_id":           @"user123",
                                  @"gender":            @"F",
                                  @"yob":               @2000,
                                  @"keywords":          @"Keyword_1,Keyword_2,Keyword_3,Keyword_4",
                                  @"country":           @"USA",
                                  @"city":              @"Los Angeles",
                                  @"zip":               @"90001–90084",
                                  @"sturl":             @"https://store_url.com",
                                  @"paid":              @"true",
                                  @"bcat":              @"IAB-1,IAB-3,IAB-5",
                                  @"badv":              @"https://domain_1.com,https://domain_2.org",
                                  @"bapps":             @"com.test.application_1,com.test.application_2,com.test.application_3",
                                  @"price_floors":      @[
                                          @{ @"id_1": @300.06 },
                                          @{ @"id_2": @1000 },
                                          @302.006,
                                          @1002
                                          ]
                                  };
    [self.interstitial setLocalExtras:localExtras];
    [self.interstitial loadAd];
}
```

Servers extra data:

```json
{
  "ad_content_type": "All",
  "badv": "https://domain_1.com,https://domain_2.org",
  "bapps": "com.test.application_1,com.test.application_2,com.test.application_3",
  "bcat": "IAB-1,IAB-3,IAB-5",
  "city": "Los Angeles",
  "consent_string": "BOEFEAyOEFEAyAHABDENAI4AAAB9vABAASA",
  "coppa": "true",
  "country": "USA",
  "gender": "F",
  "keywords": "Keyword_1,Keyword_2,Keyword_3,Keyword_4",
  "logging_enabled": "true",
  "paid": "true",
  "price_floors": [
    {
      "id_1": 300.06
    },
    {
      "id_2": 1000
    },
    302.006,
    1002
  ],
  "seller_id": "YOUR_SELLER_ID",
  "sturl": "https://store_url.com",
  "test_mode": "true",
  "user_id": "user123",
  "yob": 2000,
  "zip": "90001–90084"
}
```

### Rewarded implementation

With local extra data:

```objc
- (void)loadRewardedVideo {
    [MPRewardedVideo setDelegate:self forAdUnitId:@"AD_UNIT_ID"];
    NSDictionary *localExtras = @{
                                  @"seller_id":         @"YOUR_SELLER_ID",
                                  @"coppa":             @"true",
                                  @"consent_string":    @"BOEFEAyOEFEAyAHABDENAI4AAAB9vABAASA",
                                  @"logging_enabled":   @"true",
                                  @"test_mode":         @"true",
                                  @"user_id":           @"user123",
                                  @"gender":            @"F",
                                  @"yob":               @2000,
                                  @"keywords":          @"Keyword_1,Keyword_2,Keyword_3,Keyword_4",
                                  @"country":           @"USA",
                                  @"city":              @"Los Angeles",
                                  @"zip":               @"90001–90084",
                                  @"sturl":             @"https://store_url.com",
                                  @"paid":              @"true",
                                  @"bcat":              @"IAB-1,IAB-3,IAB-5",
                                  @"badv":              @"https://domain_1.com,https://domain_2.org",
                                  @"bapps":             @"com.test.application_1,com.test.application_2,com.test.application_3",
                                  @"price_floors":      @[
                                          @{ @"id_1": @300.06 },
                                          @{ @"id_2": @1000 },
                                          @302.006,
                                          @1002
                                          ]
                                  };
    [MPRewardedVideo loadRewardedVideoAdWithAdUnitID:@"AD_UNIT_ID"
                                            keywords:nil
                                    userDataKeywords:nil
                                            location:nil
                                          customerId:nil
                                   mediationSettings:nil
                                         localExtras:localExtras];
    [MPRewardedVideo presentRewardedVideoAdForAdUnitID:@"AD_UNIT_ID"
                                    fromViewController:self
                                            withReward:nil];
}

```

Extra data from server:

```json
{
  "badv": "https://domain_1.com,https://domain_2.org",
  "bapps": "com.test.application_1,com.test.application_2,com.test.application_3",
  "bcat": "IAB-1,IAB-3,IAB-5",
  "city": "Los Angeles",
  "consent_string": "BOEFEAyOEFEAyAHABDENAI4AAAB9vABAASA",
  "coppa": "true",
  "country": "USA",
  "gender": "F",
  "keywords": "Keyword_1,Keyword_2,Keyword_3,Keyword_4",
  "logging_enabled": "true",
  "paid": "true",
  "price_floors": [
    {
      "id_1": 300.06
    },
    {
      "id_2": 1000
    },
    302.006,
    1002
  ],
  "seller_id": "YOUR_SELLER_ID",
  "sturl": "https://store_url.com",
  "test_mode": "true",
  "user_id": "user123",
  "yob": 2000,
  "zip": "90001–90084"
}
```

### Header Bidding

To pass data for Header Bidding add to yours ***sdkConfig*** array of dictionaries with key "mediation_config":

```objc
- (NSArray *)headerBiddingConfig {
    NSDictionary *someNetworkConfig = @{
                                        @"network" :                @"some network name",
                                        @"network_class":           @"SomeNetworkClass",
                                        @"some network init param": @"value",
                                        @"ad_units":                @[@{
                                                                          @"format":                        @"interstitial_static",
                                                                          @"some network ad unit param":    @"value"
                                                                          }]
                                        };
    return @[someNetworkConfig];
}

- (NSDictionary *)localExtras {
    NSMutableDictionary *localExtras = [NSMutableDictionary new];
    localExtras[@"mediation_config"] = [self headerBiddingConfig];
    return localExtras;
}
```

Config from MoPub dashboard should look like presented below:

```json
{
  "logging_enabled": "true",
  "mediation_config": [
    {
      "ad_units": [
        {
          "format": "interstitial_static",
          "placement_id": "95298PL39048"
        }
      ],
      "app_id": "5a35a75845eaab51250070a5",
      "network": "vungle",
      "network_class": "BDMVungleAdNetwork"
    },
    {
      "ad_units": [
        {
          "format": "interstitial_static",
          "slot_id": "287052"
        },
        {
          "format": "banner",
          "slot_id": "262713"
        }
      ],
      "network": "my_target",
      "network_class": "BDMMyTargetAdNetwork"
    },
    {
      "ad_units": [
        {
          "facebook_key": "1419966511382477_2249153695130417",
          "format": "banner"
        },
        {
          "facebook_key": "754722298026822_1251166031715777",
          "format": "interstitial_static"
        }
      ],
      "app_id": "754722298026822",
      "network": "facebook",
      "network_class": "BDMFacebookAdNetwork",
      "placement_ids": [
        "754722298026822_1251166031715777",
        "1419966511382477_2249153695130417"
      ]
    },
    {
      "ad_units": [
        {
          "format": "interstitial_video",
          "placement_name": "video_without_cap_pb"
        }
      ],
      "network": "tapjoy",
      "network_class": "BDMTapjoyAdNetwork",
      "sdk_key": "6gwG-HstT_aLMpZXUXlhNgEBja6Q5bq7i4GtdFMJoarOufnp36PaVlG2OBmw"
    },
    {
      "ad_units": [
        {
          "format": "rewarded_video",
          "zone_id": "vzf07cd496be04483cad"
        },
        {
          "format": "interstitial_video",
          "zone_id": "vz7fdef471647c416682"
        }
      ],
      "app_id": "app327320f8ced14e61b2",
      "network": "adcolony",
      "network_class": "BDMAdColonyAdNetwork",
      "zones": [
        "vzf07cd496be04483cad",
        "vz7fdef471647c416682"
      ]
    }
  ],
  "paid": "true",
  "seller_id": "1",
  "stid": "13241536",
  "sturl": "https://store_url.com",
  "test_mode": "true",
  "user_id": "user123",
  "yob": 2000,
  "zip": "610000"
}
```

All network required fileds and values types are described in BidMachine doc. If ad network has initialisation parameters, it should be added in root of mediation config object. Ad network ad unit specific paramters should be added in root of ad unit object.

| Parameter | Description | Required |
| --- | --- | --- |
| network | Registered network name | Required | 
| network_class | Linked network class, should conform BDMNetwork represented as string | Required |
| ad_units | Array of ad units that contains info about format and network specific params | Required |
| - | Any params that needed for initialisation | Optional |

### Available ad units formats for Header Bidding

You can pass constants that are listed below:

* banner
* banner_320x50
* banner_728x90
* banner_300x250
* interstitial_video
* interstitial_static
* interstitial
* rewarded_video
* rewarded_static
* rewarded

##  Changelog

### Version 1.3.0.0

* Update BidMachine to 1.3.0
* Update MoPub to 5.8.0
* Add Header Bidding Supports
* Add base URL change option through MoPub UI 

### Version 1.1.1.1

* Passing of ***consent_string*** parameter into BidMachine SDK via MoPub's ***localExtras*** or MoPub dashboard.
