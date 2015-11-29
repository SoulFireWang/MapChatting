//
//  FancyTabBar.h
//  FancyTabBar
//
//  Created by Jonathan on 15/05/2014.
//

#import <UIKit/UIKit.h>
#import "FancyTabBarDelegate.h"

@interface FancyTabBar : UIView{
    
}

@property(nonatomic,weak) id<FancyTabBarDelegate> delegate;

- (void) setUpChoices:(UIViewController*) parentViewController choices:(NSArray*) choices withMainButtonImage:(UIImage*)mainButtonImage;

-(void)showInview:(UIView *)view;

-(void)hide;

@end
