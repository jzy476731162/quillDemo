//
//  ViewController.m
//  iOSQuillEditor
//
//  Created by shubham on 21/05/17.
//  Copyright © 2017 Sort. All rights reserved.
//

#import "ViewController.h"
#import "QuillNoteEditorViewController.h"
#import "QuillToolbar.h"
#import "NSString+FontAwesome.h"

#import <Masonry/Masonry.h>

@interface ViewController ()
@property (nonatomic, retain) QuillNoteEditorViewController *noteEditorController;
@property (nonatomic, retain) QuillToolbar *quillToolbar;
@property (nonatomic, retain) UIView *containerView;
@end

@implementation ViewController

- (void)keyboardWillShow:(NSNotification *)notification {
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
//    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0, 0.0, (keyboardSize.height), 0.0);
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [_quillToolbar mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_bottom).with.offset(-keyboardSize.height);
        }];
    } completion:nil];
    
//    self.quillToolbar.contentInset = contentInsets;
}

- (void)keyboardWillHide:(NSNotification *)notification {
//    self.quillToolbar.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);

    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
           [_quillToolbar mas_updateConstraints:^(MASConstraintMaker *make) {
               make.bottom.equalTo(self.view.mas_bottom);
           }];
       } completion:nil];
}

//- (void)keyboardChangeFrame:(NSNotification *)notification {
//    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
//    //    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//            [_quillToolbar mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.bottom.equalTo(self.view.mas_bottom).with.offset(-keyboardSize.height);
//            }];
//    //    } completion:nil];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.view.backgroundColor = [UIColor whiteColor];
    
    self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height - 60)];
    [self.view addSubview:self.containerView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
    /* Adding Quill Note Editor */
    _noteEditorController = [[QuillNoteEditorViewController alloc] initWithNibName:nil bundle:nil];
    [self addChildViewController:_noteEditorController];
    [self.containerView addSubview:_noteEditorController.view];
    _noteEditorController.view.frame = self.containerView.bounds;
    [_noteEditorController didMoveToParentViewController:self];
    
    //Set Delegate To Self:
    _noteEditorController.delegate = self;
    
    /*Attaching Quill Toolbar */
    _quillToolbar = [[QuillToolbar alloc] init];
    [self.view addSubview:_quillToolbar];
    //Set EditorViewController to QuillToolbar;
    
    [_quillToolbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.height.equalTo(@(60));
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    [self.view layoutIfNeeded];
    [_quillToolbar initialize];
    _quillToolbar.editorViewController = _noteEditorController;
}

-(void)onSelectedTextInRange:(NSRange)range havingAttributes:(NSArray *)attributes{
    [_quillToolbar onSelectedTextInRange:range havingAttributes:attributes];
}

-(void)onWebViewLoaded{
    NSLog(@"onWebViewLoaded");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
