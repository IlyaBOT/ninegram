#import "NGAvatarView.h"

#import "NGAvatarProviding.h"
#import "NGDialog.h"

@interface NGAvatarView ()

@property (nonatomic, copy) NSString *representedDialogIdentifier;

@end

@implementation NGAvatarView

- (void)configureWithDialog:(NGDialog *)dialog avatarProvider:(id<NGAvatarProviding>)avatarProvider diameter:(CGFloat)diameter {
    self.representedDialogIdentifier = dialog.identifier;
    self.image = nil;
    self.layer.cornerRadius = floor(diameter * 0.5);
    self.layer.masksToBounds = YES;

    __weak typeof(self) weakSelf = self;
    [avatarProvider avatarForDialog:dialog diameter:diameter completion:^(UIImage *image) {
        if ([weakSelf.representedDialogIdentifier isEqualToString:dialog.identifier]) {
            weakSelf.image = image;
        }
    }];
}

@end
