//
//  QuillToolbar.m
//  iOSQuillEditor
//
//  Created by shubham on 21/05/17.
//  Copyright © 2017 Sort. All rights reserved.
//

#import "QuillToolbar.h"
#import "QuillNoteEditorViewController.h"
#import "NSString+FontAwesome.h"
#import <Masonry/Masonry.h>

@interface QuillToolbarButton()
-(void)setMobileIcon:(NSString *)icon;
@end




@interface QuillToolbar()

@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation QuillToolbar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        [self initialize];
    }
    return self;
}


-(void)initialize{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [self addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.bottom.equalTo(self);
    }];
    self.scrollView = scrollView;
    
    [self layoutIfNeeded];
    
    _toolbarButtons = [self toolbarButtonsListInFrame:self.frame];
    self.backgroundColor = [UIColor colorWithRed:0.86 green:0.87 blue:0.87 alpha:1.0];
}


-(NSArray *)toolbarButtonsListInFrame:(CGRect)frame{
    
    NSArray *toolbarItems = @[
                                /* Text Formats */
                                @{
                                    @"key":@"textFormatting",
                                    @"icon":@"fa-bold",
                                    @"format":kQuillNoteTextFormatBold,
                                  },
                                @{
                                    @"key":@"textFormatting",
                                    @"icon":@"fa-italic",
                                    @"format":kQuillNoteTextFormatItalic,
                                    },
                                @{
                                    @"key":@"textFormatting",
                                    @"icon":@"fa-underline",
                                    @"format":kQuillNoteTextFormatUnderline,
                                    },
                                @{
                                    @"key":@"textFormatting",
                                    @"icon":@"fa-strikethrough",
                                    @"format":kQuillNoteTextFormatStrike,
                                    },
                               
                                /* Line Formats */
                                @{
                                    @"key":@"lineFormatting",
                                    @"icon":@"fa-list-ul",
                                    @"format":kQuillNoteLineFormatBullet,
                                    },
                                @{
                                    @"key":@"lineFormatting",
                                    @"icon":@"fa-list-ol",
                                    @"format":kQuillNoteLineFormatList,
                                    },
                                @{
                                    @"key":@"insertImage",
                                    @"icon":@"fa-file-image-o",
                                    @"format":kQuillNoteInsertImage,
                                },
                                @{
                                    @"key":@"insertVideo",
                                    @"icon":@"fa-file-movie-o",
                                    @"format":kQuillNoteInsertVideo,
                                },
                                @{
                                @"key":@"textAlignment",
                                @"icon":@"fa-align-left",
                                @"format":kQuillNoteLineAlignmentLeft,
                                },
                                @{
                                @"key":@"textAlignment",
                                @"icon":@"fa-align-center",
                                @"format":kQuillNoteLineAlignmentCenter,
                                },
                                @{
                                    @"key":@"textAlignment",
                                    @"icon":@"fa-align-right",
                                    @"format":kQuillNoteLineAlignmentRight,
                                  },
                                ];
      
      
    //Default ToolbarButtonFrame
    CGRect toolbarButtonFrame = frame;
    toolbarButtonFrame.origin.x = 0;
    toolbarButtonFrame.origin.y = 10;
    toolbarButtonFrame.size.height -= toolbarButtonFrame.origin.y;
    toolbarButtonFrame.size.width = 40;
    
    
    /*Creating Toolbar Buttons*/
    CGFloat leadingValue = 0;
    NSInteger index = 0;
    NSMutableArray *toolbarButtons = [NSMutableArray array];
    for(NSDictionary *toolbarItem in toolbarItems){
        QuillToolbarButton *toolbarButton = [[QuillToolbarButton alloc] initWithFrame:toolbarButtonFrame andFormat:toolbarItem[@"format"]];
        [toolbarButton setMobileIcon:toolbarItem[@"icon"]];
        [toolbarButton setValue:@1 forKey:toolbarItem[@"key"]];
        [toolbarButton addTarget:self action:@selector(onToolbarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:toolbarButton];
        
        [toolbarButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.scrollView.mas_leading).with.offset(leadingValue);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
            make.width.equalTo(@(60));
        }];
        
        [toolbarButtons addObject:toolbarButton];
//        toolbarButtonFrame.origin.x += toolbarButtonFrame.size.width;
        leadingValue += 60;
        index ++;
    }
    self.scrollView.contentSize = CGSizeMake(60 * toolbarItems.count, self.bounds.size.height);
    
    return toolbarButtons;
}



-(void)onToolbarButtonClicked:(QuillToolbarButton *)button{
    if(_editorViewController){
        if (!button.insertImage || !button.insertVideo) {
            button.active = !button.active;
        }
        
        if(button.textAlignment){
            [self.editorViewController setTextAlignment:button.format];
        }else if(button.textFormatting){
            [self.editorViewController setTextFormat:button.format andApply:button.active];
        }else if(button.lineAlignment){
            [self.editorViewController setLineAlignment:button.format];
        }else if(button.lineFormatting){
            if(button.active){
                //Set Other Buttons InActive
                for(QuillToolbarButton *btn in self.toolbarButtons){
                    if(btn.lineFormatting && btn != button){
                        btn.active = NO;
                    }
                }
            }
            
            [self.editorViewController setLineFormat:button.format andApply:button.active];
        }else if (button.insertImage) {
            [self.editorViewController uploadImage:@"http://ww1.sinaimg.cn/thumbnail/0075xAkGly1gaw2mcc0dmj30sg0sgtgz.jpg"];
        }else if (button.insertVideo) {
            [self.editorViewController uploadVideo:@"http://vfx.mtime.cn/Video/2019/03/19/mp4/190319222227698228.mp4"];
        }
        
    }
}


-(void)onSelectedTextInRange:(NSRange)range havingAttributes:(NSArray *)attributes{
    for(QuillToolbarButton *button in self.toolbarButtons){
        if([attributes containsObject:button.format]){
            button.active = YES;
        }else{
            button.active = NO;
        }
    }
    
}



@end
