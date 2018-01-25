//
//  SetPersonInfoController.m
//  FreeRide
//
//  Created by  on 2017/12/18.
//  Copyright © 2017年 JNR All rights reserved.
//

#import "SetPersonInfoController.h"
#import "Header.h"
#import "PersonalNaviView.h"
#import "RoutesController.h"
#import "TextFTableViewCell.h"
#import "UserDefaults.h"
#import "NetworkTool.h"
#import "SomeSupprt.h"
#import "CompressImage.h"
#import <UIImageView+WebCache.h>

@interface SetPersonInfoController () <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate> {
    UIImageView *imageView;
    NSString *imagePath;
    NSString *routeTypeId;
}
@property(nonatomic,strong) UIImagePickerController *imagePicker; //声明全局的UIImagePickerController
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation SetPersonInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_background;
    PersonalNaviView *navi;
    if (_isUped) {
        navi = [[PersonalNaviView alloc] initWithFrame:CGRectMake(0, 0, XMAKENEW(375), 68) andName:@"个人信息" andRightTitle:@""];
        self.tableView.userInteractionEnabled = NO;
    } else {
        navi = [[PersonalNaviView alloc] initWithFrame:CGRectMake(0, 0, XMAKENEW(375), 68) andName:@"个人信息" andRightTitle:@"提交"];
    }
    navi.block = ^(NSString *backInfo){
        NSLog(@"%@",backInfo);
        [self pushNextView:backInfo];
    };
    [self.view addSubview:navi];
    [self tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"TextFTableViewCell" bundle:nil] forCellReuseIdentifier:@"TextFTableViewCell"];
    [self dataSource];
    [self.tableView reloadData];
    [self getPersonDataFromWeb];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)pushNextView:(NSString *)info {
    if ([info isEqualToString:@"back"]) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self upDataToWeb];
        NSLog(@"点击提个人信息交按钮");
    }
}
- (void)upDataToWeb {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    NSArray *keyArr = @[@"realName",@"cardNo",@"carpoolRoute",@"licensePlate",@"vehicleBrand",@"vehicleColor",@"driverLicensePic",@"drivingLicensePic",@"vehiclePic"];
    for (int i = 0; i < keyArr.count; i++) {
        if (i < 3) {
            [dict setObject:[_dataSource[i] objectForKey:@"info"] forKey:keyArr[i]];
        } else if (i == 6){
            [dict setObject:imagePath forKey:keyArr[i]];
        } else {
            [dict setObject:@"" forKey:keyArr[i]];
        }
    }
//    int i = 0;
//    for (NSArray *arr in _dataSource) {
//        for (NSDictionary *dataDic in arr) {
//            if ([[dataDic objectForKey:@"info"] isEqualToString:@""]) {
//                [SomeSupprt createUIAlertWithMessage:@"请填写完整数据再提交" andDisappearTime:0.5];
//                return;
//            }
//            [dict setObject:[dataDic objectForKey:@"info"] forKey:keyArr[i]];
//            i++;
//        }
//    }
//    NSArray *colorArr = @[@"银灰色",@"白色",@"黑色",@"红色",@"棕色",@"蓝色",@"绿色",@"橙色",@"其他"];
//    for (int i = 0; i < colorArr.count; i++) {
//        if ([[dict objectForKey:@"vehicleColor"] isEqualToString:colorArr[i]]) {
//            [dict setObject:[NSString stringWithFormat:@"%d",i+1] forKey:@"vehicleColor"];
//        }
//    }
    [dict setObject:routeTypeId forKey:@"carpoolRoute"];
    [dict setObject:[UserDefaults getValueForKey:@"key"] forKey:@"key"];
    [dict setObject:[UserDefaults getValueForKey:@"phone"] forKey:@"phone"];
    [dict setObject:@"2" forKey:@"flag"];
    [self upDataToWeb:dict];
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
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 68, SCREEN_WIDTH, self.view.frame.size.height-68) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = COLOR_background;
        if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 12, 0, 12)];
            [self.tableView setSeparatorColor:COLOR_background];
        }
        _tableView.tableFooterView = [self createFootView];
        [self.view addSubview:_tableView];
    }
    _tableView.delegate = self;
    return _tableView;
}
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
        [_dataSource addObjectsFromArray:@[@{@"title":@"车主姓名",@"info":@"",@"placeHold":@"输入车主姓名"},
                                           @{@"title":@"身份证号",@"info":@"",@"placeHold":@"请输入本人身份证号"},
                                           @{@"title":@"合乘线路",@"info":@"",@"placeHold":@"请选择线路"}]];
    }
    return _dataSource;
}
- (void)getPersonDataFromWeb {
    [[NetworkTool sharedTool] requestWithURLString:WEB_GETAUTHPERSON
                                        parameters:@{@"key":[UserDefaults getValueForKey:@"key"],
                                                     @"phone":[UserDefaults getValueForKey:@"phone"]
                                                     }
                                            method:@"POST"
                                          callBack:^(id responseObject) {
                                              if ([[responseObject objectForKey:@"status"] isEqualToString:@"0"]) {
                                                  [self changeUIWithData:[responseObject objectForKey:@"data"]];
                                                  if ([[[responseObject objectForKey:@"data"] objectForKey:@"driver_license_pic"] length] > 0) {
                                                      [self downLoadImage:[[responseObject objectForKey:@"data"] objectForKey:@"driver_license_pic"]];
                                                  }
                                              }
                                              NSLog(@"%@",responseObject);
                                          }];
}
- (void)changeUIWithData:(NSDictionary *)dic {
    NSArray *keyArr = @[@"real_name",@"card_no",@"route_name"];
    for (int i = 0; i < _dataSource.count; i++) {
        NSMutableDictionary *webDic  = [NSMutableDictionary dictionaryWithDictionary:_dataSource[i]];
        [webDic setObject:[dic objectForKey:keyArr[i]] forKey:@"info"];
        [_dataSource replaceObjectAtIndex:i withObject:webDic];
    }
    routeTypeId = [dic objectForKey:@"carpool_route"];
    [_tableView reloadData];
}
- (void)downLoadImage:(NSString *)webAddress {
    imagePath = webAddress;
    NSString *imageString = [NSString stringWithFormat:@"http://%@/%@",FRHEAD,webAddress];
    NSURL *imageUrl = [NSURL URLWithString:imageString];
    [imageView sd_setImageWithURL:imageUrl completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    }];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) {
        RoutesController *vc = [[RoutesController alloc] init];
        vc.chooseInfoStr = [_dataSource[indexPath.row] objectForKey:@"info"];
        vc.block = ^(NSDictionary *backInfo) {
            NSMutableDictionary *dic  = [NSMutableDictionary dictionaryWithDictionary:_dataSource[2]];
            [dic setObject:[backInfo objectForKey:@"route_name"] forKey:@"info"];
            routeTypeId = [backInfo objectForKey:@"id"];
            [_dataSource replaceObjectAtIndex:2 withObject:dic];
            [_tableView reloadData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < 2) {
        TextFTableViewCell *cell;
        cell = [tableView dequeueReusableCellWithIdentifier:@"TextFTableViewCell"];
        if (!cell) {
            cell = [[TextFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TextFTableViewCell"];
        }
        cell.label.text = [_dataSource[indexPath.row] objectForKey:@"title"];
        cell.textField.placeholder = [_dataSource[indexPath.row] objectForKey:@"placeHold"];
        cell.textField.text = [_dataSource[indexPath.row] objectForKey:@"info"];
        cell.textField.tag = 1234+indexPath.row;
        cell.textField.delegate =self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        UITableViewCell *cell;
        cell = [tableView dequeueReusableCellWithIdentifier:@"Mycell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Mycell"];
        }
        cell.textLabel.textColor = COLOR_TEXT_DARK;
        cell.textLabel.text = [_dataSource[indexPath.row] objectForKey:@"title"];
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
        if ([[_dataSource[indexPath.row] objectForKey:@"info"] isEqualToString:@""]) {
            cell.detailTextLabel.text = [_dataSource[indexPath.row] objectForKey:@"placeHold"];
            cell.detailTextLabel.textColor = COLOR_SYSTEMCOLOR;
        } else {
            cell.detailTextLabel.text = [_dataSource[indexPath.row] objectForKey:@"info"];
            cell.detailTextLabel.textColor = COLOR_TEXT_DARK;
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}
- (UIView *)createFootView {
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, XMAKENEW(330))];
    footView.backgroundColor = COLOR_background;
    
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, XMAKENEW(10), SCREEN_WIDTH, XMAKENEW(320))];
    whiteView.backgroundColor = [UIColor whiteColor];
    [footView addSubview:whiteView];
    
    UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(XMAKENEW(8), 0, SCREEN_WIDTH, XMAKENEW(40))];
    leftLabel.text = @"驾驶证照片[黑本]";
    leftLabel.textColor = COLOR_TEXT_DARK;
    leftLabel.font = [UIFont systemFontOfSize:13];
    [whiteView addSubview:leftLabel];
    
    UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(-XMAKENEW(12), 0, SCREEN_WIDTH, XMAKENEW(40))];
    rightLabel.text = @"示例图";
    rightLabel.textAlignment = NSTextAlignmentRight;
    rightLabel.textColor = COLOR_TEXT_DARK;
    rightLabel.font = [UIFont systemFontOfSize:13];
    [whiteView addSubview:rightLabel];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(leftLabel.frame), CGRectGetMaxY(leftLabel.frame), SCREEN_WIDTH-2*CGRectGetMinX(leftLabel.frame), 1)];
    line.backgroundColor = COLOR_background;
    [whiteView addSubview:line];
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(XMAKENEW(30), CGRectGetMaxY(line.frame)+XMAKENEW(10), XMAKENEW(315), XMAKENEW(218))];
    imageView.image = [UIImage imageNamed:@"driver'slicense"];
    [whiteView addSubview:imageView];
    
    UIButton *agreeBtn = [[UIButton alloc] initWithFrame:CGRectMake(XMAKENEW(120), CGRectGetMaxY(imageView.frame)+XMAKENEW(10), XMAKENEW(135), XMAKENEW(35))];
    [agreeBtn setTitle:@"点击上传照片" forState:UIControlStateNormal];
    [agreeBtn addTarget:self action:@selector(agreementBtn) forControlEvents:UIControlEventTouchUpInside];
    [agreeBtn setTitleColor:COLOR_ORANGE forState:UIControlStateNormal];
    agreeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [whiteView addSubview:agreeBtn];
    
    return footView;
}
- (void)agreementBtn {
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"请选择上传方式"  message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"进入相册",@"打开相机" ,nil];
    alert.tag=99;
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
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
        [self setUpImageToWeb:selectedImage andType:@"2"];
        //返回
        [self dismissViewControllerAnimated:YES completion:nil];
    }else if (picker.sourceType == UIImagePickerControllerSourceTypeCamera){
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        [self setUpImageToWeb:image andType:@"2"];
        [self dismissViewControllerAnimated:YES completion:nil];
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil); //保存编辑后的照片
    }
}
- (void)setUpImageToWeb:(UIImage *)image andType:(NSString *)type {
    NSData *imageData = compressImage(image, 50);
    NSLog(@"%lukkb",imageData.length/1024);
    NSString *_encodedImageStr = [imageData base64Encoding];
    NSDictionary *mydic = @{@"type":type,@"phone":[UserDefaults getValueForKey:@"phone"],@"key":[UserDefaults getValueForKey:@"key"],@"object":_encodedImageStr};
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:seleBtn];
//    DriverInfoCell *cell = (DriverInfoCell *)[_tableView cellForRowAtIndexPath:indexPath];
    [[NetworkTool sharedTool] requestWithURLString:WEB_SETUPIMAGE
                                        parameters:mydic
                                            method:@"POST"
                                          callBack:^(id responseObject) {
                                              if ([[responseObject objectForKey:@"status"] isEqualToString:@"0"]) {
                                                  imagePath = [responseObject objectForKey:@"data"];
                                                  imageView.image = image;
                                                  //                                                  } else {
                                                  //                                                      [SomeSupprt createUIAlertWithMessage:[responseObject objectForKey:@"message"] andDisappearTime:0.5];
                                              }
                                              NSLog(@"%@",responseObject);
                                          }];
    
}
//- (void)changeDataSourceForImage:(NSDictionary *)responseDic {
//    NSInteger integer = [[responseDic objectForKey:@"type"] integerValue];
//    NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:_dataSource[integer]];
//    NSMutableDictionary *dic  = [NSMutableDictionary dictionaryWithDictionary:arr[0]];
//    [dic setObject:[responseDic objectForKey:@"url"] forKey:@"info"];
//    [arr replaceObjectAtIndex:0 withObject:dic];
//    [_dataSource replaceObjectAtIndex:integer withObject:arr];
//    NSLog(@"%@",_dataSource);
//}
//当用户取消选择的时候，调用该方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSMutableDictionary *dic  = [NSMutableDictionary dictionaryWithDictionary:_dataSource[textField.tag-1234]];
    [dic setObject:textField.text forKey:@"info"];
    [_dataSource replaceObjectAtIndex:textField.tag-1234 withObject:dic];
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
