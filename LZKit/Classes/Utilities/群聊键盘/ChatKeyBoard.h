//
//  ChatKeyBoard.h
//  LWGreenBaby
//
//  Created by 律金刚 on 16/4/11.
//  Copyright © 2016年 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ChatKeyBoardMacroDefine.h"

#import "ChatToolBar.h"
#import "FacePanel.h"
#import "MorePanel.h"

#import "MoreItem.h"
#import "ChatToolBarItem.h"
#import "FaceThemeModel.h"


typedef NS_ENUM(NSInteger, KeyBoardStyle)
{
    KeyBoardStyleChat = 0,
    KeyBoardStyleComment
};

@class ChatKeyBoard;
@protocol ChatKeyBoardDelegate <NSObject>
@optional
/**
 *  语音状态
 */
- (void)chatKeyBoardDidStartRecording:(ChatKeyBoard *)chatKeyBoard;
- (void)chatKeyBoardDidCancelRecording:(ChatKeyBoard *)chatKeyBoard;
- (void)chatKeyBoardDidFinishRecoding:(ChatKeyBoard *)chatKeyBoard;
- (void)chatKeyBoardWillCancelRecoding:(ChatKeyBoard *)chatKeyBoard;
- (void)chatKeyBoardContineRecording:(ChatKeyBoard *)chatKeyBoard;

/**
 *  输入状态
 */
- (void)chatKeyBoardTextViewDidBeginEditing:(UITextView *)textView;
- (void)chatKeyBoardSendText:(NSString *)text;
- (void)chatKeyBoardTextViewDidChange:(UITextView *)textView;

/**
 * 表情
 */
- (void)chatKeyBoardAddFaceSubject:(ChatKeyBoard *)chatKeyBoard;
- (void)chatKeyBoardSetFaceSubject:(ChatKeyBoard *)chatKeyBoard;

/**
 *  更多功能
 */
- (void)chatKeyBoard:(ChatKeyBoard *)chatKeyBoard didSelectMorePanelItemIndex:(NSInteger)index;

@end

/**
 *  数据源
 */
@protocol ChatKeyBoardDataSource <NSObject>

@required
- (NSArray<MoreItem *> *)chatKeyBoardMorePanelItems;
- (NSArray<ChatToolBarItem *> *)chatKeyBoardToolbarItems;
- (NSArray<FaceThemeModel *> *)chatKeyBoardFacePanelSubjectItems;
@end

@interface ChatKeyBoard : UIView

/**
 *  默认是导航栏透明，或者没有导航栏
 */
+ (instancetype)keyBoard;

/**
 *  当导航栏不透明时（强制要导航栏不透明）
 *
 *  @param translucent 是否透明
 *
 *  @return keyboard对象
 */
+ (instancetype)keyBoardWithNavgationBarTranslucent:(BOOL)translucent;


/**
 *  直接传入父视图的bounds过来
 *
 *  @param bounds 父视图的bounds，一般为控制器的view
 *
 *  @return keyboard对象
 */
+ (instancetype)keyBoardWithParentViewBounds:(CGRect)bounds;

/**
 *
 *  设置关联的表
 */
@property (nonatomic, weak) UITableView *associateTableView;


@property (nonatomic, weak) id<ChatKeyBoardDataSource> dataSource;
@property (nonatomic, weak) id<ChatKeyBoardDelegate> delegate;

@property (nonatomic, readonly, strong) ChatToolBar *chatToolBar;
@property (nonatomic, readonly, strong) FacePanel *facePanel;
@property (nonatomic, readonly, strong) MorePanel *morePanel;

/**
 *  设置键盘的风格
 *
 *  默认是 KeyBoardStyleChat
 */
@property (nonatomic, assign) KeyBoardStyle keyBoardStyle;

/**
 *  placeHolder内容
 */
@property (nonatomic, copy) NSString * placeHolder;
/**
 *  placeHolder颜色
 */
@property (nonatomic, strong) UIColor *placeHolderColor;

/**
 *  是否开启语音, 默认开启
 */
@property (nonatomic, assign) BOOL allowVoice;
/**
 *  是否开启表情，默认开启
 */
@property (nonatomic, assign) BOOL allowFace;
/**
 *  是否开启更多功能，默认开启
 */
@property (nonatomic, assign) BOOL allowMore;
/**
 *  是否开启切换工具条的功能，默认关闭
 */
@property (nonatomic, assign) BOOL allowSwitchBar;

/**
 *  键盘弹出<支持外部操纵键盘  (这两个方法是在正常聊天界面，非评论)>
 */
- (void)keyboardUp;

/**
 *  键盘收起<支持外部操纵键盘  (这两个方法是在正常聊天界面，非评论)>
 */
- (void)keyboardDown;


/************************************************************************************************
 *  如果设置键盘风格为 KeyBoardStyleComment 则可以使用下面两个方法
 *  开启评论键盘<则可以使用下面两个方法，开启评论和关闭评论键盘>
 */
- (void)keyboardUpforComment;

/**
 *  隐藏评论键盘<则可以使用下面两个方法，开启评论和关闭评论键盘>
 */
- (void)keyboardDownForComment;

@end










