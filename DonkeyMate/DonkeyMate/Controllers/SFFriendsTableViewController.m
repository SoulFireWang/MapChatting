//
//  SFFriendsTableViewController.m
//  DonkeyMate
//
//  Created by tarena on 15/11/1.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "SFFriendsTableViewController.h"
#import "SFFriendEntity.h"
#import "SFFriendsTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface SFFriendsTableViewController ()

/**
 *  朋友
 */
@property (nonatomic, strong) NSArray *friends;

@end

@implementation SFFriendsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.tabBarItem.image = [UIImage imageNamed:@"tabbar_contacts"];
    self.navigationController.tabBarItem.selectedImage = [UIImage imageNamed:@"tabbar_contactsHL"];
    
    self.friends = [SFFriendEntity demoData];
    
    UINib *nib = [UINib nibWithNibName:CUSTOM_TABLE_CELL_STYLE_FRIENDS bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:CUSTOM_TABLE_CELL_STYLE_FRIENDS];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.friends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SFFriendsTableViewCell *cell = (SFFriendsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CUSTOM_TABLE_CELL_STYLE_FRIENDS forIndexPath:indexPath];
    SFFriendEntity *friendEntity = (SFFriendEntity *)self.friends[indexPath.row];
    [cell.pictureImageView sd_setImageWithURL:[NSURL URLWithString:@"http://m3.img.srcdd.com/farm5/d/2015/0806/17/EC81A35F774BD22D7BBB49C93CBB6C3F_B500_900_500_625.jpeg"]];
    cell.nameLabel.text = friendEntity.name;
    cell.signLabel.text = friendEntity.sign;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 78;
}

@end
