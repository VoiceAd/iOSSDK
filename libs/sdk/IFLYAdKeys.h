//
//  IFLYAdKeys.h
//  IFLYAdLib
//
//  Created by JzProl.m.Qiezi on 2016/9/26.
//  Copyright © 2016年 iflytek. All rights reserved.
//

#ifndef IFLYAdLib_IFLYAdKeys_h
#define IFLYAdLib_IFLYAdKeys_h

typedef NSString * IFLYAdKey NS_STRING_ENUM;
/**
 * 广告位ID 用于广告请求
 */
extern IFLYAdKey const IFLYAdKeyAdUnitId;
/**
 * 横幅广告轮询时间间隔 只用于横幅广告轮询场景，单位s
 */
extern IFLYAdKey const IFLYAdKeyBannerInterval;
/**
 * 广告请求ID，用于外部设置特定的广告请求，不设置时会默认生成
 */
extern IFLYAdKey const IFLYAdKeyRequestId;
/**
 * 底价，单位:元/千次，即 CPM 竞价流量该字段必填
 */
extern IFLYAdKey const IFLYAdKeyBIDFloor;
/**
 * 订单信息，传入IFLYAdDeal数组
 */
extern IFLYAdKey const IFLYAdKeyPMP;
/**
 * 广告竞价参数,实际成交价，值NSNumber
 */
extern IFLYAdKey const IFLYAdKeyAuctionPrice;
/**
 * 应用版本参数，用于外部设置使用此SDK的应用版本号
 */
extern IFLYAdKey const IFLYAdKeyAPPVersion;
/**
 * 应用版本参数，用于外部设置使用此SDK的应用名称
 */
extern IFLYAdKey const IFLYAdKeyAPP;
/**
 * 支持的货币类型,默认支持'CNY'，取值NSString，','分割支持多个
 * CNY – 元
 * USD – 美元
 */
extern IFLYAdKey const IFLYAdKeyCurrency;
/**
 * 广告请求超时时间
 */
extern IFLYAdKey const IFLYAdKeyRequestTimeout;
/**
 * 广告请求是否需要录音权限， BOOL型NSNumber
 */
extern IFLYAdKey const IFLYAdKeyNeedAudio;
/**
 * 广告请求是否需要地理位置权限， BOOL型NSNumber
 */
extern IFLYAdKey const IFLYAdKeyNeedLocation;
/**
 * 广告请求UA(注意：传入的UA为浏览器UA)，NSString
 */
extern IFLYAdKey const IFLYAdKeyUA;

/**
 * 广告请求IDFA，NSString,格式“00000000-0000-0000-0000-000000000000”
 */
extern IFLYAdKey const IFLYAdKeyIDFA;

/**
 * 广告请求中广协CAID，NSString,格式“00000000000000000000000000000000”
 */
extern IFLYAdKey const IFLYAdKeyCAID;

/**
 * 广告请求是否关闭HttpDNS解析,默认开启(@(NO))，BOOL型NSNumber
 */
extern IFLYAdKey const IFLYAdKeyHttpDNS;

/**
 * 广告落地页跳转动画样式,默认右侧转入(@0)，NSUInteger型NSNumber
 * 支持参数：
 *  @0 ：右侧转入
 *  @1 : 底部转入
 */
extern IFLYAdKey const IFLYAdKeyLandingPageTransitionType;

/**
 * 广告deeplink跳转是否直接跳转而不判断能否打开,默认开启(@(YES))，BOOL型NSNumber
 * 注意：此参数目前仅对原生广告和视频广告生效
 */
extern IFLYAdKey const IFLYAdKeyJumpDirectly;

#endif /* IFLYAdLib_IFLYAdKeys_h */
