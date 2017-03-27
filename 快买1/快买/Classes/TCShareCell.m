//
//  TCShareCell.m
//  快买
//
//  Created by 唐天成 on 16/1/20.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "TCShareCell.h"
#import "TCShareMessage.h"

@interface TCShareCell()
@property (weak, nonatomic) IBOutlet UILabel *textsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *pictureView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation TCShareCell

-(void)setShareMessage:(TCShareMessage *)shareMessage{
//    NSLog(@"%@",shareMessage.textt);
    _shareMessage=shareMessage;
    self.textsLabel.text=shareMessage.textt;
    self.pictureView.image=shareMessage.image;
    self.timeLabel.text=[NSString stringWithFormat:@"分享于:%@", shareMessage.date ];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
