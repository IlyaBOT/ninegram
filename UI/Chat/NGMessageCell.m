#import "NGMessageCell.h"

#import "NGMessage.h"
#import "NGTheme.h"

static CGFloat const NGBubbleHorizontalPadding = 14.0;
static CGFloat const NGBubbleVerticalPadding = 9.0;
static CGFloat const NGBubbleSideInset = 10.0;
static CGFloat const NGBubbleTopBottomSpacing = 6.0;

@interface NGMessageCell ()

@property (nonatomic, strong) UIView *bubbleView;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) NGMessage *message;

@end

@implementation NGMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        _bubbleView = [[UIView alloc] initWithFrame:CGRectZero];
        _bubbleView.layer.cornerRadius = 18.0;
        _bubbleView.layer.masksToBounds = YES;
        [self.contentView addSubview:_bubbleView];

        _messageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _messageLabel.backgroundColor = [UIColor clearColor];
        _messageLabel.numberOfLines = 0;
        _messageLabel.font = [NGTheme messageFont];
        _messageLabel.textColor = [NGTheme primaryTextColor];
        [_bubbleView addSubview:_messageLabel];
    }
    return self;
}

+ (CGFloat)heightForMessage:(NGMessage *)message constrainedWidth:(CGFloat)width {
    CGFloat textWidth = [self maximumTextWidthForContainerWidth:width];
    CGRect textBounds = [message.text boundingRectWithSize:CGSizeMake(textWidth, CGFLOAT_MAX)
                                                   options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                attributes:@{NSFontAttributeName: [NGTheme messageFont]}
                                                   context:nil];

    return ceil(textBounds.size.height) + (NGBubbleVerticalPadding * 2.0) + (NGBubbleTopBottomSpacing * 2.0);
}

- (void)configureWithMessage:(NGMessage *)message {
    self.message = message;
    self.messageLabel.text = message.text;
    self.bubbleView.backgroundColor = message.isOutgoing ? [NGTheme outgoingBubbleColor] : [NGTheme incomingBubbleColor];
    self.bubbleView.layer.borderWidth = message.isOutgoing ? 0.0 : 0.5;
    self.bubbleView.layer.borderColor = [NGTheme bubbleBorderColor].CGColor;
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat containerWidth = CGRectGetWidth(self.contentView.bounds);
    CGFloat maxTextWidth = [[self class] maximumTextWidthForContainerWidth:containerWidth];
    CGRect textBounds = [self.message.text boundingRectWithSize:CGSizeMake(maxTextWidth, CGFLOAT_MAX)
                                                       options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                    attributes:@{NSFontAttributeName: self.messageLabel.font}
                                                       context:nil];
    CGFloat textWidth = ceil(textBounds.size.width);
    CGFloat textHeight = ceil(textBounds.size.height);
    CGFloat bubbleWidth = textWidth + (NGBubbleHorizontalPadding * 2.0);
    CGFloat bubbleHeight = textHeight + (NGBubbleVerticalPadding * 2.0);
    CGFloat bubbleY = NGBubbleTopBottomSpacing;
    CGFloat bubbleX = self.message.isOutgoing ? containerWidth - NGBubbleSideInset - bubbleWidth : NGBubbleSideInset;

    self.bubbleView.frame = CGRectIntegral(CGRectMake(bubbleX, bubbleY, bubbleWidth, bubbleHeight));
    self.messageLabel.frame = CGRectIntegral(CGRectMake(NGBubbleHorizontalPadding,
                                                        NGBubbleVerticalPadding,
                                                        textWidth,
                                                        textHeight));
}

+ (CGFloat)maximumTextWidthForContainerWidth:(CGFloat)width {
    CGFloat maxBubbleWidth = MIN(360.0, floor(width * 0.72));
    return maxBubbleWidth - (NGBubbleHorizontalPadding * 2.0);
}

@end
