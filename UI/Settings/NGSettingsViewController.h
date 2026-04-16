#import <UIKit/UIKit.h>

@class NGServiceContainer;

NS_ASSUME_NONNULL_BEGIN

@interface NGSettingsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

- (instancetype)initWithServiceContainer:(NGServiceContainer *)serviceContainer;

@end

NS_ASSUME_NONNULL_END
