//
//  User.h
//  S&OP
//
//  Created by Mayur Birari on 02/08/13.
//  Copyright (c) 2013 Linear Logics Corp.. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 \internal
 @class User.
 @abstract This class used to create instance for end User.
 */
@interface User : NSObject

/// Attribute instance value username.
@property(nonatomic, strong)NSString* userName;
/// Attribute instance value password.
@property(nonatomic, strong)NSString* password;

@end
