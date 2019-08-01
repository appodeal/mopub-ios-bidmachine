# BidMachine adapter

This folder contains mediation adapters used to mediate BidMachine.

## Getting Started

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

| Parameter | Type |
| --- | --- |
| **Required** |
| seller_id | String |
| **Optional** |
| test_mode | String |
| logging_enabled | String|

Yours implementation of initialization should look like this:
```objc
 MPMoPubConfiguration *sdkConfig = [[MPMoPubConfiguration alloc] initWithAdUnitIdForAppInitialization: @"AD_UNIT_ID"];
 NSDictionary *configurationParams = @{
                                       @"seller_id" : @"1",
                                       @"test_mode" : @"true",
                                       @"logging_enabled" : @"true"
                                       };
    [sdkConfig setNetworkConfiguration:configurationParams forMediationAdapter:@"BidMachineAdapterConfiguration"];
    sdkConfig.loggingLevel = MPLogLevelDebug;
    [[MoPub sharedInstance] grantConsent];
    [[MoPub sharedInstance] initializeSdkWithConfiguration:sdkConfig completion:^{
        NSLog(@"SDK initialization complete");
    }];
```

### Transfer targeting data to BidMachine

If you want to transfer targeting information you can use custom event's property ***localExtras*** which represents dictionary.
Keys for ***localExtras*** are listed below (Banner and Interstitial):

```
@"user_id"   --> Vendor-specific ID for the user (NSString)
@"gender"   --> User gender refer to OpenRTB 2.5 spec (kBDMUserGenderMale, kBDMUserGenderFemale, kBDMUserGenderUnknown)
@"yob"      --> User year of birth (NSNumber)
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
```
***localExtras*** for rewarded video custom event should include one more key:
```
@"location" - User's location (CLLocation)
```
### Banners implementation

In the snippet below you can see transfering of local extra data:

```objc
self.adView = [[MPAdView alloc] initWithAdUnitId:@"AD_UNIT_ID"
                                                size:MOPUB_BANNER_SIZE];
    self.adView.delegate = self;
    self.adView.frame = CGRectMake((self.view.bounds.size.width - MOPUB_BANNER_SIZE.width) / 2,
                                   self.view.bounds.size.height - MOPUB_BANNER_SIZE.height,
                                   MOPUB_BANNER_SIZE.width, MOPUB_BANNER_SIZE.height);
    [self.view addSubview:self.adView];
    NSDictionary *localExtras = @{
                                  @"seller_id": @"YOUR_SELLER_ID",
                                  @"coppa": @"true",
                                  @"logging_enabled": @"true",
                                  @"test_mode": @"true",
                                  @"banner_width": @"320",
                                  @"user_id": @"user123",
                                  @"gender": @"F",
                                  @"yob": @2000,
                                  @"keywords": @"Keyword_1,Keyword_2,Keyword_3,Keyword_4",
                                  @"country": @"USA",
                                  @"city": @"Los Angeles",
                                  @"zip": @"90001–90084",
                                  @"sturl": @"https://store_url.com",
                                  @"paid": @"true",
                                  @"bcat": @"IAB-1,IAB-3,IAB-5",
                                  @"badv": @"https://domain_1.com,https://domain_2.org",
                                  @"bapps": @"com.test.application_1,com.test.application_2,com.test.application_3",
                                  @"price_floors": @[@{
                                                        @"id_1": @300.06
                                                        }, @{
                                                        @"id_2": @1000
                                                        },
                                                    @302.006,
                                                    @1002
                                                    ]
                                  };
    [self.adView setLocalExtras:localExtras];
    [self.adView loadAd];
```

But also you can receive extra data from server. It will be sent in (NSDictionary *)***info*** of requests methods and may look like this:

```objc
{
    "seller_id": "YOUR_SELLER_ID",
    "coppa": "true",
    "logging_enabled": "true",
    "test_mode": "true",
    "banner_width": "320",
    "user_id": "user123",
    "gender": "F",
    "yob": 2000,
    "keywords": "Keyword_1,Keyword_2,Keyword_3,Keyword_4",
    "country": "USA",
    "city": "Los Angeles",
    "zip": "90001–90084",
    "sturl": "https://store_url.com",
    "paid": "true",
    "bcat": "IAB-1,IAB-3,IAB-5",
    "badv": "https://domain_1.com,https://domain_2.org",
    "bapps": "com.test.application_1,com.test.application_2,com.test.application_3",
    "price_floors": [{
            "id_1": 300.06
        }, {
            "id_2": 1000
        },
        302.006,
        1002
    ]
}
```

### Interstitial implementation

With local extra data:

```objc
    self.interstitial = [MPInterstitialAdController interstitialAdControllerForAdUnitId:@"AD_UNIT_ID"];
    self.interstitial.delegate = self;
    NSDictionary *localExtras = @{
                                  @"seller_id": @"YOUR_SELLER_ID",
                                  @"coppa": @"true",
                                  @"logging_enabled": @"true",
                                  @"test_mode": @"true",
                                  @"ad_content_type": @"All",
                                  @"user_id": @"user123",
                                  @"gender": @"F",
                                  @"yob": @2000,
                                  @"keywords": @"Keyword_1,Keyword_2,Keyword_3,Keyword_4",
                                  @"country": @"USA",
                                  @"city": @"Los Angeles",
                                  @"zip": @"90001–90084",
                                  @"sturl": @"https://store_url.com",
                                  @"paid": @"true",
                                  @"bcat": @"IAB-1,IAB-3,IAB-5",
                                  @"badv": @"https://domain_1.com,https://domain_2.org",
                                  @"bapps": @"com.test.application_1,com.test.application_2,com.test.application_3",
                                  @"price_floors": @[@{
                                                        @"id_1": @300.06
                                                        }, @{
                                                        @"id_2": @1000
                                                        },
                                                    @302.006,
                                                    @1002
                                                    ]
                                  };
    [self.interstitial setLocalExtras:localExtras];
    [self.interstitial loadAd];
```

Servers extra data:

```objc
{
    "seller_id": "YOUR_SELLER_ID",
    "coppa": "true",
    "logging_enabled": "true",
    "test_mode": "true",
    "ad_content_type": "All",
    "user_id": "user123",
    "gender": "F",
    "yob": 2000,
    "keywords": "Keyword_1,Keyword_2,Keyword_3,Keyword_4",
    "country": "USA",
    "city": "Los Angeles",
    "zip": "90001–90084",
    "sturl": "https://store_url.com",
    "paid": "true",
    "bcat": "IAB-1,IAB-3,IAB-5",
    "badv": "https://domain_1.com,https://domain_2.org",
    "bapps": "com.test.application_1,com.test.application_2,com.test.application_3",
    "price_floors": [{
            "id_1": 300.06
        }, {
            "id_2": 1000
        },
        302.006,
        1002
    ]
}
```

### Rewarded implementation

With local extra data:

```objc
[MPRewardedVideo setDelegate:self forAdUnitId:@"AD_UNIT_ID"];
    NSDictionary *localExtras = @{
                                  @"seller_id": @"YOUR_SELLER_ID",
                                  @"coppa": @"true",
                                  @"logging_enabled": @"true",
                                  @"test_mode": @"true",
                                  @"user_id": @"user123",
                                  @"gender": @"F",
                                  @"yob": @2000,
                                  @"keywords": @"Keyword_1,Keyword_2,Keyword_3,Keyword_4",
                                  @"country": @"USA",
                                  @"city": @"Los Angeles",
                                  @"zip": @"90001–90084",
                                  @"sturl": @"https://store_url.com",
                                  @"paid": @"true",
                                  @"bcat": @"IAB-1,IAB-3,IAB-5",
                                  @"badv": @"https://domain_1.com,https://domain_2.org",
                                  @"bapps": @"com.test.application_1,com.test.application_2,com.test.application_3",
                                  @"price_floors": @[@{
                                                        @"id_1": @300.06
                                                        }, @{
                                                        @"id_2": @1000
                                                        },
                                                    @302.006,
                                                    @1002
                                                    ]
                                  };
    [MPRewardedVideo loadRewardedVideoAdWithAdUnitID:@"AD_UNIT_ID" keywords:nil userDataKeywords:nil location:nil customerId:nil mediationSettings:nil localExtras:localExtras];
    [MPRewardedVideo presentRewardedVideoAdForAdUnitID:@"AD_UNIT_ID" fromViewController:self withReward:nil];
```

Extra data from server:

```objc
{
    "seller_id": "YOUR_SELLER_ID",
    "coppa": "true",
    "logging_enabled": "true",
    "test_mode": "true",
    "user_id": "user123",
    "gender": "F",
    "yob": 2000,
    "keywords": "Keyword_1,Keyword_2,Keyword_3,Keyword_4",
    "country": "USA",
    "city": "Los Angeles",
    "zip": "90001–90084",
    "sturl": "https://store_url.com",
    "paid": "true",
    "bcat": "IAB-1,IAB-3,IAB-5",
    "badv": "https://domain_1.com,https://domain_2.org",
    "bapps": "com.test.application_1,com.test.application_2,com.test.application_3",
    "price_floors": [{
            "id_1": 300.06
        }, {
            "id_2": 1000
        },
        302.006,
        1002
    ]
}
```

### Header Bidding

To pass data for Header Bidding add to yours ***sdkConfig*** array of dictionaries with key "mediation_config":

```
@{ @"seller_id" : @"1",
   @"test_mode" : @"true",
   @"logging_enabled" : @"true",
   @"mediation_config": @[
    {
      @"ad_units": @[
        {
          @"placement_id": @"95298PL39048",
          @"format": @"interstitial_static"
        }
      ],
      @"app_id": @"5a35a75845eaab51250070a5",
      @"network": @"vungle",
      @"network_class": @"BDMVungleAdNetwork"
    },
    @{
      @"ad_units": @[
        {
          @"slot_id": @"287052",
          @"format": @"interstitial_static"
        },
        {
          @"slot_id": @"262713",
          @"format": @"banner"
        }
      ],
      @"network": @"my_target",
      @"network_class": @"BDMMyTargetAdNetwork"
    },
    @{
      @"ad_units": @[
        @{
          @"facebook_key": @"1419966511382477_2249153695130417",
          @"format": @"banner"
        },
        @{
          @"facebook_key": @"754722298026822_1251166031715777",
          @"format": @"interstitial_static"
        }
      ],
      @"app_id": @"754722298026822",
      @"placement_ids": @[
        @"754722298026822_1251166031715777",
        @"1419966511382477_2249153695130417"
      ],
      "network": "facebook",
      "network_class": "BDMFacebookAdNetwork"
    },
    @{
      @"ad_units": @[
        {
          @"placement_name": @"video_without_cap_pb",
          @"format": @"interstitial_video"
        }
      ],
      @"sdk_key": @"6gwG-HstT_aLMpZXUXlhNgEBja6Q5bq7i4GtdFMJoarOufnp36PaVlG2OBmw",
      @"network": @"tapjoy",
      @"network_class": @"BDMTapjoyAdNetwork"
    },
    @{
      @"ad_units": @[
        @{
          @"format": @"rewarded_video",
          @"zone_id": @"vzf07cd496be04483cad"
        },
        @{
          @"format": @"interstitial_video",
          @"zone_id": @"vz7fdef471647c416682"
        }
      ],
      @"app_id": @"app327320f8ced14e61b2",
      @"zones": @[
        "vzf07cd496be04483cad",
        "vz7fdef471647c416682"
      ],
      @"network": @"adcolony",
      @"network_class": @"BDMAdColonyAdNetwork"
    }
  ]
}
```

Config from MoPub dashboard should look like presented below:

```
{
  "seller_id": "1",
  "stid": "13241536",
  "coppa": "true",
  "logging_enabled": "true",
  "test_mode": "true",
  "banner_width": "320",
  "user_id": "user123",
  "gender": "F",
  "yob": 2000,
  "keywords": "Keyword_1,Keyword_2,Keyword_3,Keyword_4",
  "country": "Russia",
  "city": "Kirov",
  "zip": "610000",
  "sturl": "https://store_url.com",
  "paid": "true",
  "bcat": "IAB-1,IAB-3,IAB-5",
  "badv": "https://domain_1.com,https://domain_2.org",
  "bapps": "application_1,application_2,application_3",
  "price_floors": [
    {
      "id_1": 0.01
    },
    {
      "id_2": "1.2"
    },
    {
      "id_3": "20,04"
    },
    {
      "id_4": 300.06
    },
    {
      "id_5": 1000
    },
    "2",
    "2.2",
    "22,04",
    302.006,
    1002
  ],
  "mediation_config": [
    {
      "ad_units": [
        {
          "placement_id": "95298PL39048",
          "format": "interstitial_static"
        }
      ],
      "app_id": "5a35a75845eaab51250070a5",
      "network": "vungle",
      "network_class": "BDMVungleAdNetwork"
    },
    {
      "ad_units": [
        {
          "slot_id": "287052",
          "format": "interstitial_static"
        },
        {
          "slot_id": "262713",
          "format": "banner"
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
      "placement_ids": [
        "754722298026822_1251166031715777",
        "1419966511382477_2249153695130417"
      ],
      "network": "facebook",
      "network_class": "BDMFacebookAdNetwork"
    },
    {
      "ad_units": [
        {
          "placement_name": "video_without_cap_pb",
          "format": "interstitial_video"
        }
      ],
      "sdk_key": "6gwG-HstT_aLMpZXUXlhNgEBja6Q5bq7i4GtdFMJoarOufnp36PaVlG2OBmw",
      "network": "tapjoy",
      "network_class": "BDMTapjoyAdNetwork"
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
      "zones": [
        "vzf07cd496be04483cad",
        "vz7fdef471647c416682"
      ],
      "network": "adcolony",
      "network_class": "BDMAdColonyAdNetwork"
    }
  ]
}
```
