//
//  CardViewCell.h
//  WeScreen
//
//  Created by Littlebox on 11/17/14.
//  Copyright (c) 2014 Littlebox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardViewCellShop : UITableViewCell

@property (nonatomic, retain) IBOutlet UIImageView *avaterImageView;
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel *detailLabel;
@property (nonatomic, retain) IBOutlet UIButton *shopButton;

@property (nonatomic, retain) IBOutlet UILabel *priceLabel;

- (void)setShopButtonPressedBlock:(void (^)(id sender))shopButtonPressedBlock;

@end
