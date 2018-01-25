//
//  DriverInfoController.m
//  FreeRide
//
//  Created by  on 2017/12/9.
//  Copyright © 2017年 JNR All rights reserved.
//

#import "DriverInfoController.h"
#import "Header.h"
#import "PersonalNaviView.h"
#import "DriverInfoCell.h"
#import "TextFTableViewCell.h"
#import "DemoView.h"
#import "ChooseCarColorView.h"
#import "RoutesController.h"
#import "NetworkTool.h"
#import "SomeSupprt.h"
#import "CompressImage.h"
#import "UserDefaults.h"
#import "CarTypeController.h"
#import "WebViewController.h"
#import <UIImageView+WebCache.h>


@interface DriverInfoController () <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate>
{
    UIButton *agreeBtn;
    NSInteger seleBtn;
    NSString *carTypeId;
    NSString *routeTypeId;
}
@property(nonatomic,strong) UIImagePickerController *imagePicker; //声明全局的UIImagePickerController
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation DriverInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_background;
    PersonalNaviView *navi = [[PersonalNaviView alloc] initWithFrame:CGRectMake(0, 0, XMAKENEW(375), 68) andName:@"认证车主" andRightTitle:@"认证常见问题"];
    [navi.rightBtn setTitleColor:COLOR_TEXT_NORMAL forState:UIControlStateNormal];
    navi.block = ^(NSString *backInfo){
        NSLog(@"%@",backInfo);
        [self pushNextView:backInfo];
    };
    [self.view addSubview:navi];
    [self tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"TextFTableViewCell" bundle:nil] forCellReuseIdentifier:@"TextFTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DriverInfoCell" bundle:nil] forCellReuseIdentifier:@"DriverInfoCell"];
    
    [self dataSource];
    [self.tableView reloadData];
    if (_isUped) {
        [self getCarDataFromWeb];
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}
- (void)getCarDataFromWeb {
    [[NetworkTool sharedTool] requestWithURLString:WEB_GETAUTHALLDATA
                                        parameters:@{@"key":[UserDefaults getValueForKey:@"key"],
                                                     @"phone":[UserDefaults getValueForKey:@"phone"]
                                                     }
                                            method:@"POST"
                                          callBack:^(id responseObject) {
                                              if ([[responseObject objectForKey:@"status"] isEqualToString:@"0"]) {
                                                  [self changeUIWithData:[responseObject objectForKey:@"data"]];
                                              }
                                              NSLog(@"%@",responseObject);
                                          }];
}
- (void)changeUIWithData:(NSDictionary *)dic {
    NSArray *keyArr = @[@[@"real_name",@"card_no",@"route_name"],@[@"license_plate",@"vehicle_brand",@"vehicle_color"],@"driver_license_pic",@"driving_license_pic",@"vehicle_pic"];
    for (int i = 0; i < 3; i++) {
        NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:_dataSource[0]];
        NSMutableDictionary *dict  = [NSMutableDictionary dictionaryWithDictionary:arr[i]];
        [dict setObject:[dic objectForKey:keyArr[0][i]] forKey:@"info"];
        [arr replaceObjectAtIndex:i withObject:dict];
        [_dataSource replaceObjectAtIndex:0 withObject:arr];
        
        NSMutableArray *arr1 = [[NSMutableArray alloc] initWithArray:_dataSource[1]];
        NSMutableDictionary *dict1  = [NSMutableDictionary dictionaryWithDictionary:arr[i]];
        [dict1 setObject:[dic objectForKey:keyArr[1][i]] forKey:@"info"];
        [arr1 replaceObjectAtIndex:i withObject:dict1];
        [_dataSource replaceObjectAtIndex:1 withObject:arr1];
        
        NSMutableArray *arr2 = [[NSMutableArray alloc] initWithArray:_dataSource[i+2]];
        NSMutableDictionary *dict2  = [NSMutableDictionary dictionaryWithDictionary:arr[0]];
        [dict2 setObject:[dic objectForKey:keyArr[i+2]] forKey:@"info"];
        [arr2 replaceObjectAtIndex:0 withObject:dict2];
        [_dataSource replaceObjectAtIndex:i+2 withObject:arr2];
    }
    [_tableView reloadData];
    carTypeId = [dic objectForKey:@"brand_id"];
    routeTypeId = [dic objectForKey:@"carpool_route"];
}
- (void)downLoadImage:(NSString *)webAddress andImageView:(UIButton *)button {
    UIImageView *imageView = [[UIImageView alloc] init];
    NSString *imageString = [NSString stringWithFormat:@"http://%@/%@",FRHEAD,webAddress];
    NSURL *imageUrl = [NSURL URLWithString:imageString];
    [imageView sd_setImageWithURL:imageUrl completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [button setBackgroundImage:imageView.image forState:UIControlStateNormal];
    }];
}
- (void)pushNextView:(NSString *)info {
    if ([info isEqualToString:@"back"]) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        WebViewController *webView = [[WebViewController alloc] init];
        webView.titleName = @"认证常见问题";
        webView.urlString = @"attest_problems.html";
        [self.navigationController pushViewController:webView animated:YES];
    }
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 68, SCREEN_WIDTH, self.view.frame.size.height-68) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = COLOR_background;
        if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 12, 0, 12)];
            [self.tableView setSeparatorColor:COLOR_background];
        }
        _tableView.tableFooterView = [self createFootView];
        self.tableView.estimatedRowHeight = 44.0f;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
        [_dataSource addObjectsFromArray:@[@[@{@"title":@"车主姓名",@"info":@"",@"placeHold":@"输入车主姓名"},
                                             @{@"title":@"身份证号",@"info":@"",@"placeHold":@"请输入本人身份证号"},
                                             @{@"title":@"合乘线路",@"info":@"",@"placeHold":@"请选择线路"}],
                                           @[@{@"title":@"车牌号码",@"info":@"",@"placeHold":@"请填写车牌号码"},
                                             @{@"title":@"车辆品牌",@"info":@"",@"placeHold":@"请选择车辆品牌"},
                                             @{@"title":@"车辆颜色",@"info":@"",@"placeHold":@"请选择车辆颜色"}],
                                           @[@{@"title":@"驾驶证照片[黑本]",@"info":@"",@"placeHold":@"请上传本人驾驶证照片"}],
                                           @[@{@"title":@"行驶证照片[蓝本]",@"info":@"",@"placeHold":@"请上传行驶证照片"}],
                                           @[@{@"title":@"车辆照片",@"info":@"",@"placeHold":@"请上传车辆照片"}]]];
    }
    return _dataSource;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == 2) {
        ChooseCarColorView *view = [[ChooseCarColorView alloc] initWithFrame:self.view.bounds];
        view.chooseInfoStr = [_dataSource[indexPath.section][indexPath.row] objectForKey:@"info"];
        view.block = ^(NSString *backInfo) {
            NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:_dataSource[1]];
            NSMutableDictionary *dic  = [NSMutableDictionary dictionaryWithDictionary:arr[2]];
            [dic setObject:backInfo forKey:@"info"];
            [arr replaceObjectAtIndex:2 withObject:dic];
            [_dataSource replaceObjectAtIndex:1 withObject:arr];
            [_tableView reloadData];
        };
        [self.view addSubview:view];
    } else if (indexPath.section == 0 && indexPath.row == 2) {
        RoutesController *vc = [[RoutesController alloc] init];
        vc.chooseInfoStr = [_dataSource[indexPath.section][indexPath.row] objectForKey:@"info"];
        vc.block = ^(NSDictionary *backInfo) {
            NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:_dataSource[0]];
            NSMutableDictionary *dic  = [NSMutableDictionary dictionaryWithDictionary:arr[2]];
            [dic setObject:[backInfo objectForKey:@"route_name"] forKey:@"info"];
            routeTypeId = [backInfo objectForKey:@"id"];
            [arr replaceObjectAtIndex:2 withObject:dic];
            [_dataSource replaceObjectAtIndex:0 withObject:arr];
            [_tableView reloadData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.section == 1 && indexPath.row == 1) {
        CarTypeController *vc = [[CarTypeController alloc] init];
        vc.block = ^(NSDictionary *backInfo) {
            NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:_dataSource[1]];
            NSMutableDictionary *dic  = [NSMutableDictionary dictionaryWithDictionary:arr[1]];
            [dic setObject:[backInfo objectForKey:@"name"] forKey:@"info"];
            carTypeId = [NSString stringWithFormat:@"%@", [backInfo objectForKey:@"brand_id"]];
            [arr replaceObjectAtIndex:1 withObject:dic];
            [_dataSource replaceObjectAtIndex:1 withObject:arr];
            [_tableView reloadData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section >1) {
        DriverInfoCell *cell;
        cell = [tableView dequeueReusableCellWithIdentifier:@"DriverInfoCell"];
        if (!cell) {
            cell = [[DriverInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DriverInfoCell"];
        }
        cell.titleLabel.text = [_dataSource[indexPath.section][indexPath.row] objectForKey:@"title"];
        cell.promptLabel.text = [_dataSource[indexPath.section][indexPath.row] objectForKey:@"placeHold"];
        [self downLoadImage:[_dataSource[indexPath.section][indexPath.row] objectForKey:@"info"] andImageView:cell.setIamgeBtn];
        cell.cellID = [NSString stringWithFormat:@"%ld",(long)indexPath.section];
        cell.block = ^(NSString *backInfo, NSString *cellID) {
            [self createUI:backInfo andType:cellID];
        };
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if ((indexPath.section == 0 && indexPath.row == 1)||indexPath.row == 0) {
        TextFTableViewCell *cell;
        cell = [tableView dequeueReusableCellWithIdentifier:@"TextFTableViewCell"];
        if (!cell) {
            cell = [[TextFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TextFTableViewCell"];
        }
        cell.label.text = [_dataSource[indexPath.section][indexPath.row] objectForKey:@"title"];
        cell.textField.placeholder = [_dataSource[indexPath.section][indexPath.row] objectForKey:@"placeHold"];
        cell.textField.text = [_dataSource[indexPath.section][indexPath.row] objectForKey:@"info"];
        cell.textField.tag = 1234+indexPath.section*10+indexPath.row;
        cell.textField.delegate =self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        UITableViewCell *cell;
        cell = [tableView dequeueReusableCellWithIdentifier:@"Mycell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Mycell"];
        }
        cell.textLabel.text = [_dataSource[indexPath.section][indexPath.row] objectForKey:@"title"];
        cell.textLabel.textColor = COLOR_TEXT_DARK;
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
        if ([[_dataSource[indexPath.section][indexPath.row] objectForKey:@"info"] isEqualToString:@""]) {
            cell.detailTextLabel.text = [_dataSource[indexPath.section][indexPath.row] objectForKey:@"placeHold"];
            cell.detailTextLabel.textColor = COLOR_SYSTEMCOLOR;
        } else {
            cell.detailTextLabel.text = [_dataSource[indexPath.section][indexPath.row] objectForKey:@"info"];
            cell.detailTextLabel.textColor = COLOR_TEXT_DARK;
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
- (UIView *)createFootView {
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, XMAKENEW(110))];
    footView.backgroundColor = COLOR_background;
    
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, XMAKENEW(20), SCREEN_WIDTH, XMAKENEW(90))];
    whiteView.backgroundColor = [UIColor whiteColor];
    [footView addSubview:whiteView];
    
    agreeBtn = [[UIButton alloc] initWithFrame:CGRectMake(XMAKENEW(125), 0, XMAKENEW(50), XMAKENEW(35))];
    [agreeBtn setTitle:@"同意" forState:UIControlStateNormal];
    [agreeBtn addTarget:self action:@selector(agreeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [agreeBtn setTitleColor:COLOR_TEXT_LIGHT forState:UIControlStateNormal];
    [agreeBtn setImage:[UIImage imageNamed:@"Unchecked"] forState:UIControlStateNormal];
    [agreeBtn setImage:[UIImage imageNamed:@"Selected"] forState:UIControlStateSelected];
    agreeBtn.selected = YES;
    agreeBtn.titleLabel.font = [UIFont systemFontOfSize:FONT12];
    [whiteView addSubview:agreeBtn];
    
    UIButton *agreementBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(agreeBtn.frame)-XMAKENEW(5), CGRectGetMinY(agreeBtn.frame), XMAKENEW(90), agreeBtn.frame.size.height)];
    [agreementBtn setTitle:@"《用户协议》" forState:UIControlStateNormal];
    [agreementBtn addTarget:self action:@selector(agreementBtn) forControlEvents:UIControlEventTouchUpInside];
    [agreementBtn setTitleColor:COLOR_ORANGE forState:UIControlStateNormal];
    agreementBtn.titleLabel.font = [UIFont systemFontOfSize:FONT12];
    [whiteView addSubview:agreementBtn];
    
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(XMAKENEW(12.5), CGRectGetMaxY(agreementBtn.frame), XMAKENEW(350), YMAKENEW(40))];
    [loginBtn setTitle:@"提交资料" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(tagerLoginBtn) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.backgroundColor = COLOR_ORANGE;
    loginBtn.layer.cornerRadius = 3.0;//2.0是圆角的弧度，根据需求自己更改
    loginBtn.layer.borderColor = (__bridge CGColorRef _Nullable)(COLOR_ORANGE);//设置边框颜色
    loginBtn.layer.borderWidth = 0.5f;//设置边框颜色
    [whiteView addSubview:loginBtn];
    
    return footView;
}
- (void)agreementBtn {
    WebViewController *webView = [[WebViewController alloc] init];
    webView.titleName = @"用户协议";
    webView.urlString = @"user_agreement.html";
    [self.navigationController pushViewController:webView animated:YES];
}
- (void)upDataToWeb:(NSDictionary *)dic {
    [[NetworkTool sharedTool] requestWithURLString:WEB_POSTCARINFO
                                        parameters:dic
                                            method:@"POST"
                                          callBack:^(id responseObject) {
                                              if ([[responseObject objectForKey:@"status"] isEqualToString:@"0"]) {
                                                  [SomeSupprt createUIAlertWithMessage:@"提交成功" andDisappearTime:0.5];
                                                  [self.navigationController popViewControllerAnimated:YES];
                                              } else {
                                                  [SomeSupprt createUIAlertWithMessage:[responseObject objectForKey:@"message"] andDisappearTime:0.5];
                                              }
                                              NSLog(@"%@",responseObject);
                                          }];
}
- (void)tagerLoginBtn {
    if (!agreeBtn.selected) {
        [SomeSupprt createUIAlertWithMessage:@"请阅读用户协议并同意" andDisappearTime:0.5];
        return;
    }
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    NSArray *keyArr = @[@"realName",@"cardNo",@"carpoolRoute",@"licensePlate",@"vehicleBrand",@"vehicleColor",@"driverLicensePic",@"drivingLicensePic",@"vehiclePic"];
    int i = 0;
    for (NSArray *arr in _dataSource) {
        for (NSDictionary *dataDic in arr) {
            if ([[dataDic objectForKey:@"info"] isEqualToString:@""]) {
                [SomeSupprt createUIAlertWithMessage:@"请填写完整数据再提交" andDisappearTime:0.5];
                return;
            }
            [dict setObject:[dataDic objectForKey:@"info"] forKey:keyArr[i]];
            i++;
        }
    }
    NSArray *colorArr = @[@"银灰色",@"白色",@"黑色",@"红色",@"棕色",@"蓝色",@"绿色",@"橙色",@"其他"];
    for (int i = 0; i < colorArr.count; i++) {
        if ([[dict objectForKey:@"vehicleColor"] isEqualToString:colorArr[i]]) {
            [dict setObject:[NSString stringWithFormat:@"%d",i+1] forKey:@"vehicleColor"];
        }
    }
    [dict setObject:carTypeId forKey:@"vehicleBrand"];
    [dict setObject:routeTypeId forKey:@"carpoolRoute"];
    [dict setObject:[UserDefaults getValueForKey:@"key"] forKey:@"key"];
    [dict setObject:[UserDefaults getValueForKey:@"phone"] forKey:@"phone"];
    [dict setObject:@"3" forKey:@"flag"];
    [self upDataToWeb:dict];
}
- (void)agreeBtn:(UIButton *)button {
    button.selected = !button.selected;
}
- (void)createUI:(NSString *)string andType:(NSString *)type {
    seleBtn = [type integerValue];
    if ([string isEqualToString:@"image"]) {
        [self buttonAction];
    } else {
        [self demoAction:type];
    }
    
}
- (void)demoAction:(NSString *)type {
    DemoView *demoView = [[DemoView alloc] initWithFrame:self.view.bounds andType:type];
    [self.view addSubview:demoView];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataSource[section] count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataSource.count;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)buttonAction
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"请选择上传方式"  message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"进入相册",@"打开相机" ,nil];
    alert.tag=99;
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        //            self.string=@"Shareholders";
        UIImagePickerController * picker = [[UIImagePickerController alloc]init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:nil];
    }
    if (buttonIndex==2) {
        //判断目前的运行机器能不能支持相机
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController * picker = [[UIImagePickerController alloc]init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.allowsEditing = YES; //拍摄之后的照片允许编辑
            //推出相机
            [self presentViewController:picker animated:YES completion:^{}];
        }else{
            //            NSLog(@"相机不可用");
        }
    }
}
//相机和相册的回调方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        UIImage *selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage]; //找到选择的图片
        
        [self setUpImageToWeb:selectedImage andType:[NSString stringWithFormat:@"%ld", (long)seleBtn]];
        //返回
        [self dismissViewControllerAnimated:YES completion:nil];
    }else if (picker.sourceType == UIImagePickerControllerSourceTypeCamera){
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        [self setUpImageToWeb:image andType:[NSString stringWithFormat:@"%ld", (long)seleBtn]];
        [self dismissViewControllerAnimated:YES completion:nil];
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil); //保存编辑后的照片
    }
}
- (void)setUpImageToWeb:(UIImage *)image andType:(NSString *)type {
    NSData *imageData = compressImage(image, 50);
    NSLog(@"%lukkb",imageData.length/1024);
    NSString *_encodedImageStr = [imageData base64Encoding];
    NSDictionary *mydic = @{@"type":type,@"phone":[UserDefaults getValueForKey:@"phone"],@"key":[UserDefaults getValueForKey:@"key"],@"object":_encodedImageStr};
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:seleBtn];
    DriverInfoCell *cell = (DriverInfoCell *)[_tableView cellForRowAtIndexPath:indexPath];
    [[NetworkTool sharedTool] requestWithURLString:WEB_SETUPIMAGE
                                        parameters:mydic
                                            method:@"POST"
                                          callBack:^(id responseObject) {
                                              if ([[responseObject objectForKey:@"status"] isEqualToString:@"0"]) {
                                                  [self changeDataSourceForImage:[responseObject objectForKey:@"data"]];
                                                  [cell.setIamgeBtn setBackgroundImage:image forState:UIControlStateNormal];
                                                  //                                                  } else {
                                                  //                                                      [SomeSupprt createUIAlertWithMessage:[responseObject objectForKey:@"message"] andDisappearTime:0.5];
                                              }
                                              NSLog(@"%@",responseObject);
                                          }];
    
}
- (void)changeDataSourceForImage:(NSDictionary *)responseDic {
    NSInteger integer = [[responseDic objectForKey:@"type"] integerValue];
    NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:_dataSource[integer]];
    NSMutableDictionary *dic  = [NSMutableDictionary dictionaryWithDictionary:arr[0]];
    [dic setObject:[responseDic objectForKey:@"url"] forKey:@"info"];
    [arr replaceObjectAtIndex:0 withObject:dic];
    [_dataSource replaceObjectAtIndex:integer withObject:arr];
    NSLog(@"%@",_dataSource);
}
#pragma mark-网络方法
- (void)cheakDriverInfo {
    
}
- (void)netWorking:(NSDictionary *)dict {
    [[NetworkTool sharedTool] requestWithURLString:WEB_LOGIN_PASSWORD
                                        parameters:dict
                                            method:@"POST"
                                          callBack:^(id responseObject) {
                                              if ([[responseObject objectForKey:@"status"] isEqualToString:@"0"]) {
                                                  //                                                  [self loginAndAction:[responseObject objectForKey:@"data"]];
                                                  //                                                  [self downPersonInfo];
                                              } else {
                                                  [SomeSupprt createUIAlertWithMessage:[responseObject objectForKey:@"message"] andDisappearTime:0.8];
                                              }
                                              NSLog(@"%@",responseObject);
                                          }];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:_dataSource[(textField.tag-1234)/10]];
    NSMutableDictionary *dic  = [NSMutableDictionary dictionaryWithDictionary:arr[(textField.tag-1234)%10]];
    [dic setObject:textField.text forKey:@"info"];
    [arr replaceObjectAtIndex:(textField.tag-1234)%10 withObject:dic];
    [_dataSource replaceObjectAtIndex:(textField.tag-1234)/10 withObject:arr];
    [_tableView reloadData];
}
//当用户取消选择的时候，调用该方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

@end

