#import "NGChatsViewController.h"

#import "NGAvatarProviding.h"
#import "NGDialog.h"
#import "NGDialogCell.h"
#import "NGMessagingBackend.h"
#import "NGTheme.h"

static NSString * const NGDialogCellIdentifier = @"NGDialogCell";

@interface NGChatsViewController ()

@property (nonatomic, strong) id<NGMessagingBackend> backend;
@property (nonatomic, strong) id<NGAvatarProviding> avatarProvider;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *dialogs;

@end

@implementation NGChatsViewController

- (instancetype)initWithBackend:(id<NGMessagingBackend>)backend avatarProvider:(id<NGAvatarProviding>)avatarProvider {
    self = [super init];
    if (self) {
        _backend = backend;
        _avatarProvider = avatarProvider;
        _dialogs = @[];
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.title = @"Chats";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [NGTheme backgroundColor];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = [NGTheme surfaceColor];
    self.tableView.separatorColor = [NGTheme separatorColor];
    self.tableView.separatorInset = UIEdgeInsetsMake(0.0, 78.0, 0.0, 0.0);
    self.tableView.rowHeight = 72.0;
    self.tableView.estimatedRowHeight = 0.0;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[NGDialogCell class] forCellReuseIdentifier:NGDialogCellIdentifier];
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadDialogs];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

- (void)reloadDialogs {
    __weak typeof(self) weakSelf = self;
    [self.backend fetchDialogsWithCompletion:^(NSArray<NGDialog *> *dialogs) {
        weakSelf.dialogs = dialogs;
        [weakSelf.tableView reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dialogs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NGDialogCell *cell = [tableView dequeueReusableCellWithIdentifier:NGDialogCellIdentifier forIndexPath:indexPath];
    NGDialog *dialog = self.dialogs[indexPath.row];
    [cell configureWithDialog:dialog avatarProvider:self.avatarProvider];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NGDialog *dialog = self.dialogs[indexPath.row];
    [self.delegate chatsViewController:self didSelectDialog:dialog];
}

@end
