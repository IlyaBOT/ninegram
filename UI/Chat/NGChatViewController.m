#import "NGChatViewController.h"

#import "NGChatInputBar.h"
#import "NGDateFormatting.h"
#import "NGDialog.h"
#import "NGMessage.h"
#import "NGMessageCell.h"
#import "NGMessageLayoutCache.h"
#import "NGMessagingBackend.h"
#import "NGTheme.h"

static NSString * const NGMessageCellIdentifier = @"NGMessageCell";

@interface NGChatViewController () <UITableViewDataSource, UITableViewDelegate, NGChatInputBarDelegate>

@property (nonatomic, strong) NGDialog *dialog;
@property (nonatomic, strong) id<NGMessagingBackend> backend;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NGChatInputBar *inputBar;
@property (nonatomic, strong) NGMessageLayoutCache *layoutCache;
@property (nonatomic, copy) NSArray *messages;
@property (nonatomic, copy) NSArray *sectionDates;
@property (nonatomic, copy) NSArray *sectionedMessages;
@property (nonatomic, assign) CGFloat keyboardHeight;
@property (nonatomic, assign) BOOL hasScrolledToBottom;

@end

@implementation NGChatViewController

- (instancetype)initWithDialog:(NGDialog *)dialog backend:(id<NGMessagingBackend>)backend {
    self = [super init];
    if (self) {
        _dialog = dialog;
        _backend = backend;
        _layoutCache = [[NGMessageLayoutCache alloc] init];
        _messages = @[];
        _sectionDates = @[];
        _sectionedMessages = @[];
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.hidesBottomBarWhenPushed = YES;
        self.title = dialog.title;
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [NGTheme backgroundColor];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.estimatedRowHeight = 0.0;
    [self.tableView registerClass:[NGMessageCell class] forCellReuseIdentifier:NGMessageCellIdentifier];
    [self.view addSubview:self.tableView];

    self.inputBar = [[NGChatInputBar alloc] initWithFrame:CGRectZero];
    self.inputBar.delegate = self;
    [self.view addSubview:self.inputBar];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleKeyboardNotification:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];

    [self reloadMessages];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if (!self.hasScrolledToBottom) {
        [self scrollToBottomAnimated:NO];
        self.hasScrolledToBottom = YES;
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    CGRect bounds = self.view.bounds;
    CGFloat inputHeight = 52.0;
    CGFloat inputOriginY = CGRectGetHeight(bounds) - self.keyboardHeight - inputHeight;

    self.inputBar.frame = CGRectMake(0.0, inputOriginY, CGRectGetWidth(bounds), inputHeight);
    self.tableView.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(bounds), inputOriginY);
    self.tableView.contentInset = UIEdgeInsetsMake(8.0, 0.0, 8.0, 0.0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
}

- (void)reloadMessages {
    __weak typeof(self) weakSelf = self;
    [self.backend fetchMessagesForDialogIdentifier:self.dialog.identifier completion:^(NSArray<NGMessage *> *messages) {
        weakSelf.messages = messages;
        [weakSelf rebuildSectionsFromMessages:messages];
        [weakSelf.layoutCache removeAllHeights];
        [weakSelf.tableView reloadData];
        [weakSelf scrollToBottomAnimated:NO];
        weakSelf.hasScrolledToBottom = YES;
    }];
}

- (void)rebuildSectionsFromMessages:(NSArray<NGMessage *> *)messages {
    NSMutableArray *sectionDates = [NSMutableArray array];
    NSMutableArray *sectionedMessages = [NSMutableArray array];

    NSDate *currentDate = nil;
    NSMutableArray *currentSectionMessages = nil;

    for (NGMessage *message in messages) {
        NSDate *bucketDate = [NGDateFormatting startOfDayForDate:message.date];
        if (currentDate == nil || ![bucketDate isEqualToDate:currentDate]) {
            currentDate = bucketDate;
            currentSectionMessages = [NSMutableArray array];
            [sectionDates addObject:bucketDate];
            [sectionedMessages addObject:currentSectionMessages];
        }

        [currentSectionMessages addObject:message];
    }

    self.sectionDates = [sectionDates copy];
    self.sectionedMessages = [sectionedMessages copy];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionedMessages.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.sectionedMessages[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NGMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:NGMessageCellIdentifier forIndexPath:indexPath];
    NGMessage *message = self.sectionedMessages[indexPath.section][indexPath.row];
    [cell configureWithMessage:message];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NGMessage *message = self.sectionedMessages[indexPath.section][indexPath.row];
    CGFloat width = CGRectGetWidth(tableView.bounds);
    if (width <= 0.0) {
        width = CGRectGetWidth(self.view.bounds);
    }

    CGFloat cachedHeight = [self.layoutCache heightForMessageIdentifier:message.identifier width:width];
    if (cachedHeight > 0.0) {
        return cachedHeight;
    }

    CGFloat height = [NGMessageCell heightForMessage:message constrainedWidth:width];
    [self.layoutCache setHeight:height forMessageIdentifier:message.identifier width:width];
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 4.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectZero];
    containerView.backgroundColor = [UIColor clearColor];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 4.0, 110.0, 22.0)];
    label.center = CGPointMake(CGRectGetWidth(tableView.bounds) * 0.5, 15.0);
    label.backgroundColor = [NGTheme headerPillColor];
    label.layer.cornerRadius = 11.0;
    label.layer.masksToBounds = YES;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [NGTheme secondaryTextColor];
    label.font = [NGTheme sectionHeaderFont];
    label.text = [NGDateFormatting chatSectionTitleForDate:self.sectionDates[section]];
    [containerView addSubview:label];

    return containerView;
}

- (void)chatInputBar:(NGChatInputBar *)inputBar didSendText:(NSString *)text {
    __weak typeof(self) weakSelf = self;
    [self.backend sendText:text toDialogIdentifier:self.dialog.identifier completion:^(NGMessage *message) {
        if (message == nil) {
            return;
        }

        NSMutableArray *updatedMessages = [weakSelf.messages mutableCopy];
        [updatedMessages addObject:message];
        weakSelf.messages = [updatedMessages copy];
        [weakSelf rebuildSectionsFromMessages:weakSelf.messages];
        [weakSelf.layoutCache removeAllHeights];
        [weakSelf.tableView reloadData];
        [weakSelf scrollToBottomAnimated:YES];
    }];
}

- (void)handleKeyboardNotification:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect localFrame = [self.view convertRect:endFrame fromView:nil];
    CGFloat overlap = MAX(0.0, CGRectGetMaxY(self.view.bounds) - CGRectGetMinY(localFrame));

    NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = (UIViewAnimationCurve)[userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    UIViewAnimationOptions options = (UIViewAnimationOptions)(curve << 16);

    self.keyboardHeight = overlap;

    [UIView animateWithDuration:duration delay:0.0 options:options animations:^{
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
        [self scrollToBottomAnimated:NO];
    } completion:nil];
}

- (void)scrollToBottomAnimated:(BOOL)animated {
    NSInteger lastSection = self.sectionedMessages.count - 1;
    if (lastSection < 0) {
        return;
    }

    NSArray *rows = self.sectionedMessages[lastSection];
    NSInteger lastRow = rows.count - 1;
    if (lastRow < 0) {
        return;
    }

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastRow inSection:lastSection];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:animated];
}

@end
