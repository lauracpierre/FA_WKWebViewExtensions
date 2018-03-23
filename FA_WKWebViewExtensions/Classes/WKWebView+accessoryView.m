//
//  WKWebView+accessoryView.m
//  FA_WKWebViewExtensions
//
//  Created by Sylvain Abadie on 3/23/18.
//

#import <WebKit/WebKit.h>
#import "WKWebView+accessoryView.h"

@implementation WKWebView (WKWebViewAccessoryView)

- (void)removeInputAccessoryView {
  UIView *targetView;

  for (UIView *view in self.scrollView.subviews) {
    if([[view.class description] hasPrefix:@"WKContent"]) {
      targetView = view;
    }
  }
  
  if (!targetView) {
    return;
  }
  
  NSString *noInputAccessoryViewClassName = [NSString stringWithFormat:@"%@_NoInputAccessoryView", targetView.class.superclass];
  Class newClass = NSClassFromString(noInputAccessoryViewClassName);
  
  if(newClass == nil) {
    newClass = objc_allocateClassPair(targetView.class, [noInputAccessoryViewClassName cStringUsingEncoding:NSASCIIStringEncoding], 0);
    if(!newClass) {
      return;
    }
    
    Method method = class_getInstanceMethod([_NoInputAccessoryView class], @selector(inputAccessoryView));
    
    class_addMethod(newClass, @selector(inputAccessoryView), method_getImplementation(method), method_getTypeEncoding(method));
    
    objc_registerClassPair(newClass);
  }
  
  object_setClass(targetView, newClass);
}

@end
