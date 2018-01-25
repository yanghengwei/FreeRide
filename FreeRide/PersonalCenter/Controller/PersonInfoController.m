//
//  PersonInfoController.m
//  FreeRide
//
//  Created by  on 2017/12/12.
//  Copyright © 2017年 JNR All rights reserved.
//

#import "PersonInfoController.h"
#import "Header.h"
#import "PersonalNaviView.h"
#import "TextFTableViewCell.h"
#import "UserDefaults.h"
#import "NetworkTool.h"
#import "CompressImage.h"
#import "SomeSupprt.h"

@interface PersonInfoController () <UITableViewDelegate, UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    NSMutableDictionary *dataDic;
    NSArray *titleArr;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation PersonInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    titleArr = @[@"头        像",@"昵        称",@"性        别",@"",@"家        乡",@"常出没地",@"个性签名"];
    PersonalNaviView *navi = [[PersonalNaviView alloc] initWithFrame:CGRectMake(0, 0, XMAKENEW(375), 68) andName:@"个人资料" andRightTitle:@"提交"];
    [navi.rightBtn setTitleColor:COLOR_TEXT_NORMAL forState:UIControlStateNormal];
    navi.block = ^(NSString *backInfo){
        NSLog(@"%@",backInfo);
        [self pushNextView:backInfo];
    };
    [self.view addSubview:navi];
    [self tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"TextFTableViewCell" bundle:nil] forCellReuseIdentifier:@"TextFTableViewCell"];
    [self tableData];
    [self reloadData];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)reloadData {
    NSArray *keyArr = @[@"headImage",@"nick_name",@"sex",@"2",@"home_town",@"haunt",@"persion_sign"];
    for (int i = 0; i < 7; i++) {
        if ([UserDefaults getValueForKey:keyArr[i]]) {
            [_dataSource replaceObjectAtIndex:i withObject:[UserDefaults getValueForKey:keyArr[i]]];
            if (i == 2) {
                if ([[UserDefaults getValueForKey:@"sex"] isEqualToString:@"1"]) {
                    [_dataSource replaceObjectAtIndex:i withObject:@"男"];
                } else if ([[UserDefaults getValueForKey:@"sex"] isEqualToString:@"2"]) {
                    [_dataSource replaceObjectAtIndex:i withObject:@"女"];
                }
            }
        }
    }
    [self.tableView reloadData];
}
- (void)pushNextView:(NSString *)info {
    if ([info isEqualToString:@"back"]) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self CheckPersonInfoToWeb];
    }
}
- (void)CheckPersonInfoToWeb {
    dataDic = [[NSMutableDictionary alloc] init];
    NSArray *keyArr = @[@"phone",@"nickName",@"sex",@"",@"homeTown",@"haunt",@"persionSign"];
    for (int i = 1; i < 7; i++) {
        if (i == 1 || i > 3) {
            NSIndexPath *path=[NSIndexPath indexPathForRow:i inSection:0];
            TextFTableViewCell *cell = [_tableView cellForRowAtIndexPath:path];
            [dataDic setObject:cell.textField.text forKey:keyArr[i]];
        } else if (i == 2) {
            NSIndexPath *path=[NSIndexPath indexPathForRow:i inSection:0];
            UITableViewCell *cell = [_tableView cellForRowAtIndexPath:path];
            if ([cell.detailTextLabel.text isEqualToString:@"男"]) {
                [dataDic setObject:@"1" forKey:keyArr[i]];
            } else if ([cell.detailTextLabel.text isEqualToString:@"女"]) {
                [dataDic setObject:@"2" forKey:keyArr[i]];
            }
        }
    }
    [dataDic setObject:[UserDefaults getValueForKey:@"phone"] forKey:@"phone"];
    [dataDic setObject:[UserDefaults getValueForKey:@"key"] forKey:@"key"];
    [self setPersonInfoToWeb];
}
- (void)setPersonInfoToWeb {
    [[NetworkTool sharedTool] requestWithURLString:WEB_SETUPPERSONINFO
                                        parameters:dataDic
                                            method:@"POST"
                                          callBack:^(id responseObject) {
                                              if ([[responseObject objectForKey:@"status"] isEqualToString:@"0"]) {
                                                  [self setHeadImageToWeb];
                                                  [self saveInfoToUserDefault];
                                              } else {
                                                  [SomeSupprt createUIAlertWithMessage:[responseObject objectForKey:@"message"] andDisappearTime:0.8];
                                              }
                                              NSLog(@"%@",responseObject);
                                          }];
}
- (void)saveInfoToUserDefault {
    NSArray *UpkeyArr = @[@"nickName",@"sex",@"homeTown",@"haunt",@"persionSign"];
    NSArray *keyArr = @[@"nick_name",@"sex",@"home_town",@"haunt",@"persion_sign"];
    for (int i = 0; i < keyArr.count; i++) {
        [UserDefaults saveValue:[dataDic objectForKey:UpkeyArr[i]] forKey:keyArr[i]];
    }
}
- (void)setHeadImageToWeb {
    UIImageView *imageView = [self.view viewWithTag:999];
    NSData *imageData = compressImage(imageView.image, 10);
    NSLog(@"%lukkb",imageData.length/1024);
    NSString *_encodedImageStr = [imageData base64Encoding];
    NSDictionary *mydic = @{@"type":@"1",@"phone":[UserDefaults getValueForKey:@"phone"],@"key":[UserDefaults getValueForKey:@"key"],@"object":_encodedImageStr};
    [[NetworkTool sharedTool] requestWithURLString:WEB_SETUPIMAGE
                                        parameters:mydic
                                            method:@"POST"
                                          callBack:^(id responseObject) {
                                              if ([[responseObject objectForKey:@"status"] isEqualToString:@"0"]) {
                                                  [SomeSupprt createUIAlertWithMessage:@"提交个人信息成功" andDisappearTime:0.8];
                                                  [UserDefaults saveValue:imageData forKey:@"headImage"];
                                                  //                head_portrait
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
        _tableView.tableFooterView = [[UIView alloc] init];
        if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 12, 0, 12)];
            [self.tableView setSeparatorColor:COLOR_background];
        }
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
- (NSMutableArray *)tableData {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] initWithArray:@[@"image",@"",@"请选择",@"",@"",@"",@""]];;
    }
    return _dataSource;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 80;
    } else if (indexPath.row == 3) {
        return 10;
    } else {
        return 44;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"image"];
        UIImageView *photoImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-75, 10, 60, 60)];
        if ([_dataSource[indexPath.row] isKindOfClass:[NSString class]]) {
            photoImage.image = [UIImage imageNamed:@"img_vehicle"];
        } else {
            photoImage.image = [UIImage imageWithData:[UserDefaults getValueForKey:@"headImage"]];
        }
        photoImage.layer.cornerRadius = 30;
        photoImage.layer.masksToBounds = YES;
        photoImage.tag = 999;
        photoImage.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goActionShow:)];
        [photoImage addGestureRecognizer:tap];
        [cell addSubview:photoImage];
        cell.textLabel.text = titleArr[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.textLabel.textColor = COLOR_TEXT_DARK;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (indexPath.row == 3) {
        UITableViewCell *cell;
        cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = COLOR_background;
        return cell;
    } else if (indexPath.row == 2) {
        UITableViewCell *cell;
        cell = [tableView dequeueReusableCellWithIdentifier:@"sexCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"sexCell"];
        }
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.text = titleArr[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.textLabel.textColor = COLOR_TEXT_DARK;
        if ([_dataSource[indexPath.row] length] > 2) {
            cell.detailTextLabel.textColor = COLOR_SYSTEMCOLOR;
        } else {
            cell.detailTextLabel.textColor = COLOR_TEXT_DARK;
        }
        cell.detailTextLabel.text = _dataSource[indexPath.row];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        TextFTableViewCell *cell;
        cell = [tableView dequeueReusableCellWithIdentifier:@"TextFTableViewCell"];
        if (!cell) {
            cell = [[TextFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TextFTableViewCell"];
        }
        cell.label.text = titleArr[indexPath.row];
        cell.textField.placeholder = @"请输入";
        cell.textField.text = _dataSource[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"请选择性别"  message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"男",@"女" ,nil];
        [alert show];
    }
}
- (void)goActionShow:(UITapGestureRecognizer*)tap {
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"请选择上传方式"  message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"进入相册",@"打开相机" ,nil];
    alert.tag=199;
    [alert show];
}
-( void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 199) {
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
    } else {
        NSIndexPath *path=[NSIndexPath indexPathForRow:2 inSection:0];
        UITableViewCell *cell = [_tableView cellForRowAtIndexPath:path];
        cell.detailTextLabel.textColor = COLOR_TEXT_DARK;
        if (buttonIndex==1) {
            cell.detailTextLabel.text = @"男";
        } else if (buttonIndex==2) {
            cell.detailTextLabel.text = @"女";
        }
    }
}
//相机和相册的回调方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImageView *imageView = [self.view viewWithTag:999];
    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        UIImage *selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage]; //找到选择的图片
        imageView.image = selectedImage;
        //返回
        [self dismissViewControllerAnimated:YES completion:nil];
    }else if (picker.sourceType == UIImagePickerControllerSourceTypeCamera){
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        imageView.image = image;
        [self dismissViewControllerAnimated:YES completion:nil];
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil); //保存编辑后的照片
    }
}
//当用户取消选择的时候，调用该方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{}];
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
