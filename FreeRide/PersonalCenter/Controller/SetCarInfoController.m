//
//  SetCarInfoController.m
//  FreeRide
//
//  Created by  on 2017/12/18.
//  Copyright © 2017年 JNR All rights reserved.
//

#import "SetCarInfoController.h"
#import "Header.h"
#import "PersonalNaviView.h"
#import "TextFTableViewCell.h"
#import "ChooseCarColorView.h"
#import "CarTypeController.h"
#import "UserDefaults.h"
#import "NetworkTool.h"
#import "SomeSupprt.h"
#import "CompressImage.h"
#import <UIImageView+WebCache.h>


@interface SetCarInfoController () <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate> {
    NSInteger seleBtn;
    NSString *carTypeId;
    NSString *imagePath1;
    NSString *imagePath2;
}
@property(nonatomic,strong) UIImagePickerController *imagePicker; //声明全局的UIImagePickerController
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation SetCarInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_background;
    PersonalNaviView *navi;
    if (_isUped) {
        navi = [[PersonalNaviView alloc] initWithFrame:CGRectMake(0, 0, XMAKENEW(375), 68) andName:@"车辆信息" andRightTitle:@""];
//        self.tableView.userInteractionEnabled = NO;
    } else {
        navi = [[PersonalNaviView alloc] initWithFrame:CGRectMake(0, 0, XMAKENEW(375), 68) andName:@"车辆信息" andRightTitle:@"提交"];
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
        NSLog(@"点击提车辆信息交按钮");
        [self upDataToWeb];
    }
}
- (void)upDataToWeb {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    NSArray *keyArr = @[@"licensePlate",@"vehicleBrand",@"vehicleColor",@"realName",@"cardNo",@"carpoolRoute",@"driverLicensePic",@"drivingLicensePic",@"vehiclePic"];
    for (int i = 0; i < keyArr.count; i++) {
        if (i < 3) {
            if ([[_dataSource[i] objectForKey:@"info"] isEqualToString:@""]) {
                [SomeSupprt createUIAlertWithMessage:@"请填写完整信息" andDisappearTime:0.5];
                return;
            }
            [dict setObject:[_dataSource[i] objectForKey:@"info"] forKey:keyArr[i]];
        } else {
            [dict setObject:@"" forKey:keyArr[i]];
        }
    }
    NSArray *colorArr = @[@"银灰色",@"白色",@"黑色",@"红色",@"棕色",@"蓝色",@"绿色",@"橙色",@"其他"];
    for (int i = 0; i < colorArr.count; i++) {
        if ([[dict objectForKey:@"vehicleColor"] isEqualToString:colorArr[i]]) {
            [dict setObject:[NSString stringWithFormat:@"%d",i+1] forKey:@"vehicleColor"];
        }
    }
    [dict setObject:carTypeId forKey:@"vehicleBrand"];
    if (!imagePath1 || !imagePath2) {
        [SomeSupprt createUIAlertWithMessage:@"请填写完整信息" andDisappearTime:0.5];
        return;
    }
    [dict setObject:imagePath1 forKey:@"drivingLicensePic"];
    [dict setObject:imagePath2 forKey:@"vehiclePic"];
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
    [dict setObject:[UserDefaults getValueForKey:@"key"] forKey:@"key"];
    [dict setObject:[UserDefaults getValueForKey:@"phone"] forKey:@"phone"];
    [dict setObject:@"1" forKey:@"flag"];
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
    return _tableView;
}
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
        [_dataSource addObjectsFromArray:@[@{@"title":@"车牌号码",@"info":@"",@"placeHold":@"请填写车牌号码"},
                                           @{@"title":@"车辆品牌",@"info":@"",@"placeHold":@"请选择车辆品牌"},
                                           @{@"title":@"车辆颜色",@"info":@"",@"placeHold":@"请选择车辆颜色"}]];
    }
    return _dataSource;
}
- (void)getPersonDataFromWeb {
    [[NetworkTool sharedTool] requestWithURLString:WEB_GETAUTHCAR
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
    NSArray *keyArr = @[@"license_plate",@"vehicle_brand",@"vehicle_color"];
    for (int i = 0; i < _dataSource.count; i++) {
        NSMutableDictionary *webDic  = [NSMutableDictionary dictionaryWithDictionary:_dataSource[i]];
        [webDic setObject:[dic objectForKey:keyArr[i]] forKey:@"info"];
        [_dataSource replaceObjectAtIndex:i withObject:webDic];
    }
    UIImageView *imageView1 = [self.view viewWithTag:1104];
    UIImageView *imageView2 = [self.view viewWithTag:1105];
    carTypeId = [dic objectForKey:@"brand_id"];
    imagePath1 = [dic objectForKey:@"driving_license_pic"];
    imagePath2 = [dic objectForKey:@"vehicle_pic"];
    [self downLoadImage:imagePath1 andImageView:imageView1];
    [self downLoadImage:imagePath2 andImageView:imageView2];
    [_tableView reloadData];
}
- (void)downLoadImage:(NSString *)webAddress andImageView:(UIImageView *)imageView{
    NSString *imageString = [NSString stringWithFormat:@"http://%@/%@",FRHEAD,webAddress];
    NSURL *imageUrl = [NSURL URLWithString:imageString];
    [imageView sd_setImageWithURL:imageUrl completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    }];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) {
        ChooseCarColorView *view = [[ChooseCarColorView alloc] initWithFrame:self.view.bounds];
        view.chooseInfoStr = [_dataSource[indexPath.row] objectForKey:@"info"];
        view.block = ^(NSString *backInfo) {
            NSMutableDictionary *dic  = [NSMutableDictionary dictionaryWithDictionary:_dataSource[2]];
            [dic setObject:backInfo forKey:@"info"];
            [_dataSource replaceObjectAtIndex:2 withObject:dic];
            [_tableView reloadData];
        };
        [self.view addSubview:view];
    } else if (indexPath.row == 1){
        CarTypeController *vc = [[CarTypeController alloc] init];
        vc.block = ^(NSDictionary *backInfo) {
            NSMutableDictionary *dic  = [NSMutableDictionary dictionaryWithDictionary:_dataSource[1]];
            [dic setObject:[backInfo objectForKey:@"name"] forKey:@"info"];
            carTypeId = [NSString stringWithFormat:@"%@", [backInfo objectForKey:@"brand_id"]];
            [_dataSource replaceObjectAtIndex:1 withObject:dic];
            [_tableView reloadData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        TextFTableViewCell *cell;
        cell = [tableView dequeueReusableCellWithIdentifier:@"TextFTableViewCell"];
        if (!cell) {
            cell = [[TextFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TextFTableViewCell"];
        }
        cell.label.text = [_dataSource[indexPath.row] objectForKey:@"title"];
        cell.textField.placeholder = [_dataSource[indexPath.row] objectForKey:@"placeHold"];
        cell.textField.text = [_dataSource[indexPath.row] objectForKey:@"info"];
        cell.textField.tag = 1234+indexPath.row;
        cell.textField.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (_isUped) {
            cell.userInteractionEnabled = NO;
        }
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
        } else {
            cell.detailTextLabel.text = [_dataSource[indexPath.row] objectForKey:@"info"];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (_isUped) {
            cell.userInteractionEnabled = NO;
        }
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
    UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, XMAKENEW(660))];
    NSArray *arr = @[@{@"title":@"行驶证照片[蓝本]",@"image":@"drivinglicense"},@{@"title":@"车辆照片",@"image":@"img_vehicle"}];
    for (int i = 0; i < 2; i++) {
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, i*XMAKENEW(330), SCREEN_WIDTH, XMAKENEW(330))];
        footView.backgroundColor = COLOR_background;
        [mainView addSubview:footView];
        
        UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, XMAKENEW(10), SCREEN_WIDTH, XMAKENEW(320))];
        whiteView.backgroundColor = [UIColor whiteColor];
        [footView addSubview:whiteView];
        
        UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(XMAKENEW(8), 0, SCREEN_WIDTH, XMAKENEW(40))];
        leftLabel.text = [arr[i] objectForKey:@"title"];
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
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(XMAKENEW(30), CGRectGetMaxY(line.frame)+XMAKENEW(10), XMAKENEW(315), XMAKENEW(218))];
        imageView.image = [UIImage imageNamed:[arr[i] objectForKey:@"image"]];
        imageView.tag = 1104+i;
        [whiteView addSubview:imageView];
        
        UIButton *agreeBtn = [[UIButton alloc] initWithFrame:CGRectMake(XMAKENEW(120), CGRectGetMaxY(imageView.frame)+XMAKENEW(10), XMAKENEW(135), XMAKENEW(35))];
        [agreeBtn setTitle:@"点击上传照片" forState:UIControlStateNormal];
        agreeBtn.tag = 1004+i;
        [agreeBtn addTarget:self action:@selector(agreementBtn:) forControlEvents:UIControlEventTouchUpInside];
        [agreeBtn setTitleColor:COLOR_ORANGE forState:UIControlStateNormal];
        agreeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [whiteView addSubview:agreeBtn];
    }
    if (_isUped) {
        mainView.userInteractionEnabled = NO;
    }
    return mainView;
}
- (void)agreementBtn:(UIButton *)button {
    seleBtn = button.tag +100;
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
    UIImageView *imageView = [self.view viewWithTag:seleBtn];
    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        UIImage *selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage]; //找到选择的图片
        [self setUpImageToWeb:selectedImage andImageView:imageView];
//        imageView.image = selectedImage;
        //返回
        [self dismissViewControllerAnimated:YES completion:nil];
    }else if (picker.sourceType == UIImagePickerControllerSourceTypeCamera){
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        [self setUpImageToWeb:image andImageView:imageView];
//        imageView.image = image;
        [self dismissViewControllerAnimated:YES completion:nil];
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil); //保存编辑后的照片
    }
}
- (void)setUpImageToWeb:(UIImage *)image andImageView:(UIImageView *)imageView{
    NSData *imageData = compressImage(image, 50);
    NSLog(@"%lukkb",imageData.length/1024);
    NSString *_encodedImageStr = [imageData base64Encoding];
    NSDictionary *mydic = @{@"type":@"1",@"phone":[UserDefaults getValueForKey:@"phone"],@"key":[UserDefaults getValueForKey:@"key"],@"object":_encodedImageStr};
    //    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:seleBtn];
    //    DriverInfoCell *cell = (DriverInfoCell *)[_tableView cellForRowAtIndexPath:indexPath];
    [[NetworkTool sharedTool] requestWithURLString:WEB_SETUPIMAGE
                                        parameters:mydic
                                            method:@"POST"
                                          callBack:^(id responseObject) {
                                              if ([[responseObject objectForKey:@"status"] isEqualToString:@"0"]) {
                                                  if (imageView.tag == 1104) {
                                                      imagePath1 = [responseObject objectForKey:@"data"];
                                                  } else {
                                                      imagePath2 = [responseObject objectForKey:@"data"];
                                                  }
                                                  imageView.image = image;
                                                  //                                                  } else {
                                                  //                                                      [SomeSupprt createUIAlertWithMessage:[responseObject objectForKey:@"message"] andDisappearTime:0.5];
                                              }
                                              NSLog(@"%@",responseObject);
                                          }];
    
}
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

@end
