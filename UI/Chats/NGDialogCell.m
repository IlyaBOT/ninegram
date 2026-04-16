#import "NGDialogCell.h"

#import "NGAvatarProviding.h"
#import "NGAvatarView.h"
#import "NGBadgeView.h"
#import "NGDateFormatting.h"
#import "NGDialog.h"
#import "NGTheme.h"

@interface NGDialogCell ()

@property (nonatomic, strong) NGAvatarView *avatarView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *previewLabel;
@property (nonatomic, strong) UILabel *timestampLabel;
@property (nonatomic, strong) NGBadgeView *badgeView;

@end

@implementation NGDialogCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [NGTheme surfaceColor];
        self.contentView.backgroundColor = [NGTheme surfaceColor];
        self.selectionStyle = UITableViewCellSelectionStyleBlue;

        _avatarView = [[NGAvatarView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_avatarView];

        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [NGTheme dialogTitleFont];
        _titleLabel.textColor = [NGTheme primaryTextColor];
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:_titleLabel];

        _previewLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _previewLabel.font = [NGTheme dialogPreviewFont];
        _previewLabel.textColor = [NGTheme secondaryTextColor];
        _previewLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:_previewLabel];

        _timestampLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timestampLabel.font = [NGTheme dialogTimestampFont];
        _timestampLabel.textColor = [NGTheme secondaryTextColor];
        _timestampLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_timestampLabel];

        _badgeView = [[NGBadgeView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_badgeView];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.avatarView.image = nil;
    self.titleLabel.text = nil;
    self.previewLabel.text = nil;
    self.timestampLabel.text = nil;
    self.badgeView.count = 0;
}

- (void)configureWithDialog:(NGDialog *)dialog avatarProvider:(id<NGAvatarProviding>)avatarProvider {
    self.titleLabel.text = dialog.title;
    self.previewLabel.text = dialog.lastMessageText;
    self.timestampLabel.text = [NGDateFormatting dialogListTimestampStringForDate:dialog.lastMessageDate];
    self.badgeView.count = dialog.unreadCount;
    [self.avatarView configureWithDialog:dialog avatarProvider:avatarProvider diameter:52.0];
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat leftPadding = 14.0;
    CGFloat avatarSize = 52.0;
    CGFloat contentWidth = CGRectGetWidth(self.contentView.bounds);
    CGFloat textOriginX = leftPadding + avatarSize + 12.0;
    CGFloat timestampWidth = 74.0;
    CGFloat rightPadding = 14.0;

    self.avatarView.frame = CGRectMake(leftPadding, 10.0, avatarSize, avatarSize);
    self.timestampLabel.frame = CGRectMake(contentWidth - rightPadding - timestampWidth, 12.0, timestampWidth, 15.0);

    CGSize badgeSize = [self.badgeView sizeThatFits:CGSizeZero];
    CGFloat badgeWidth = badgeSize.width;
    CGFloat badgeHeight = badgeSize.height;
    if (badgeWidth > 0.0 && badgeHeight > 0.0) {
        self.badgeView.frame = CGRectMake(contentWidth - rightPadding - badgeWidth, 39.0, badgeWidth, badgeHeight);
    } else {
        self.badgeView.frame = CGRectZero;
    }

    CGFloat titleWidth = CGRectGetMinX(self.timestampLabel.frame) - 8.0 - textOriginX;
    CGFloat previewRightEdge = badgeWidth > 0.0 ? CGRectGetMinX(self.badgeView.frame) - 10.0 : contentWidth - rightPadding;
    CGFloat previewWidth = previewRightEdge - textOriginX;

    self.titleLabel.frame = CGRectMake(textOriginX, 12.0, MAX(20.0, titleWidth), 19.0);
    self.previewLabel.frame = CGRectMake(textOriginX, 37.0, MAX(20.0, previewWidth), 18.0);
}

@end
