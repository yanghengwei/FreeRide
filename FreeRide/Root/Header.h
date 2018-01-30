//
//  Header.h
//  FreeRide
//
//  Created by  on 2017/11/9.
//  Copyright © 2017年 JNR All rights reserved.
//

#ifndef Header_h
#define Header_h

#import <AMapFoundationKit/AMapFoundationKit.h>
#import <MAMapKit/MAMapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

#define APIKEY  @"a1c2b82d3e3abc509ae942ed8e5cad70"//高德key

#define AESKEY  @"CXYYcxyy96508JNR"//AES key

#define FRHEAD @"192.168.0.113:8080"
#define USER @"user"
#define ADMIN @"admin"


#define XMAKENEW(x) [[UIScreen mainScreen] bounds].size.width / 375.0*x
#define YMAKENEW(y) [[UIScreen mainScreen] bounds].size.height / 667.0*y

#define VerifyValue(value) ({id tmp;if ([value isKindOfClass:[NSNull class]]){tmp = @"";}else if (value == nil){tmp = @"";}else{tmp = value;}tmp;})
/**********颜色和透明度设置***************/
#define RGBA(r,g,b,a) [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:a]
#define COLOR_ORANGE RGBA(255,144,14,1) //橘色主题
#define COLOR_TEXT_LIGHT RGBA(223,223,223,1) //字体浅黑
#define COLOR_TEXT_NORMAL RGBA(151,151,151,1) //字体淡黑
#define COLOR_TEXT_DARK RGBA(100,100,100,1) //字体黑色
#define COLOR_background RGBA(248,248,248,1) //背景颜色
#define COLOR_SYSTEMCOLOR RGBA(199,199,205,1) //系统颜色

#define FONT12 12

/****************网址*******************/
#define USERWEB [NSString stringWithFormat:@"http://%@/%@",FRHEAD,USER]
#define ADMINWEB [NSString stringWithFormat:@"http://%@/%@",FRHEAD,ADMIN]
/*****登录********/
#define WEB_LOGIN_TEST [NSString stringWithFormat:@"%@/loginOrRegisterCode.htm",USERWEB]//验证码登陆或者注册
#define WEB_LOGIN_PASSWORD [NSString stringWithFormat:@"%@/loginOrRegisterUserPassword.htm",USERWEB]//用户名密码登陆
#define WEB_GETTEST [NSString stringWithFormat:@"%@/sendCode.htm",USERWEB]//获取验证码
#define WEB_FORGETPASSWORD [NSString stringWithFormat:@"%@/forgetPassword.htm",USERWEB]//忘记密码

/*****其他********/
#define WEB_SETPASSWORD [NSString stringWithFormat:@"%@/updatePassword.htm",ADMINWEB]//支付密码修改
#define WEB_SETUPPERSONINFO [NSString stringWithFormat:@"%@/userBasicInfoUpdate.htm",ADMINWEB]//用户基本信息更新
#define WEB_DOWNPERSONINFO [NSString stringWithFormat:@"%@/obtainUserBasicInfo.htm",ADMINWEB]//获取用户基本信息
#define WEB_SETUPIMAGE [NSString stringWithFormat:@"%@/uploadImg.htm",ADMINWEB]//上传图片
#define WEB_GETROUDTYPE [NSString stringWithFormat:@"%@/obtainCarpoolRoute.htm",ADMINWEB]//获取合乘路线信息
#define WEB_GETCARTYPE [NSString stringWithFormat:@"%@/obtainVehicleBrand.htm",ADMINWEB]//获取汽车品牌
#define WEB_GETCARINFO [NSString stringWithFormat:@"%@/obtainVehicleModels.htm",ADMINWEB]//获取汽车车型
#define WEB_POSTCARINFO [NSString stringWithFormat:@"%@/authCarOwner.htm",ADMINWEB]//认证车主
#define WEB_GETCARSDATE [NSString stringWithFormat:@"%@/obtainAuthCarOwnerInfo.htm",ADMINWEB]//汽车列表
#define WEB_GETACCOUNTDETAIL [NSString stringWithFormat:@"%@/obtainAccountDetail.htm",ADMINWEB]//获取账号明细信息
#define WEB_GETACCOUNTMONEY [NSString stringWithFormat:@"%@/obtainAccountMoney.htm",ADMINWEB]//获取账户余额
#define WEB_POSTBANKCARD [NSString stringWithFormat:@"%@/bandCardInfoAdd.htm",ADMINWEB]//添加银行卡
#define WEB_GETBANKCARD [NSString stringWithFormat:@"%@/obtainBandCardInfo.htm",ADMINWEB]//获取银行卡列表
#define WEB_POSTMONEYTOBANK [NSString stringWithFormat:@"%@/withdrawalsRecordAdd.htm",ADMINWEB]//提现
#define WEB_POSTINVOICEMAC [NSString stringWithFormat:@"%@/machineInvoiceAdd.htm",ADMINWEB]//机打发票
#define WEB_POSTINVOICEQUO [NSString stringWithFormat:@"%@/quotaInvoiceAdd.htm",ADMINWEB]//新增定额
#define WEB_POSTINVOICEELE [NSString stringWithFormat:@"%@/electronicInvoiceAdd.htm",ADMINWEB]//新增电子发票信息
#define WEB_GETBANNER [NSString stringWithFormat:@"%@/obtainBannerInfo.htm",ADMINWEB]//获取轮播图
#define WEB_DELETEBANKCARD [NSString stringWithFormat:@"%@/unbundlingBandCard.htm",ADMINWEB]//删除银行卡
#define WEB_USEREXIT [NSString stringWithFormat:@"%@/userExit.htm",ADMINWEB]//用户退出
#define WEB_OPINION [NSString stringWithFormat:@"%@/opinionFeedBackAdd.htm",ADMINWEB]//提交意见反馈
#define WEB_GETAUTHALLDATA [NSString stringWithFormat:@"%@/obtainAuthInfo.htm",ADMINWEB]//提交意见反馈
#define WEB_GETAUTHPERSON [NSString stringWithFormat:@"%@/obtainAuthPerInfo.htm",ADMINWEB]//获取个人注册信息
#define WEB_GETAUTHCAR [NSString stringWithFormat:@"%@/obtainAuthVehicleInfo.htm",ADMINWEB]//获取车辆注册信息

#define IS_IPHONE_X (Screen_Height == 812.0f) ? YES : NO
#define Height_NavContentBar 44.0f
#define Height_StatusBar (IS_IPHONE_X==YES)?44.0f: 20.0f
#define Height_NavBar    (IS_IPHONE_X==YES)?88.0f: 64.0f
#define Height_TabBar    (IS_IPHONE_X==YES)?83.0f: 49.0f


#endif /* Header_h */

