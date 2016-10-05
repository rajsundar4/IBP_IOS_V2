//
//  ProgressHUD.m
//

#import "ProgressHUD.h"
#import <QuartzCore/QuartzCore.h>


@interface ProgressHUD ()

@property (nonatomic, strong) NSTimer *fadeOutTimer;
@property (nonatomic, strong) UILabel *stringLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIActivityIndicatorView *spinnerView;

- (void)showInView:(UIView *)view status:(NSString *)string networkIndicator:(BOOL)show posY:(CGFloat)posY;
- (void)setStatus:(NSString *)string;
- (void)dismiss;
- (void)dismissWithStatus:(NSString *)string error:(BOOL)error;

- (void)memoryWarning:(NSNotification*) notification;

@end


@implementation ProgressHUD

@synthesize fadeOutTimer, stringLabel, imageView, spinnerView, backgroundView;

static ProgressHUD *sharedView = nil;

+ (ProgressHUD*)sharedView {

	if(sharedView == nil){
		sharedView = [[ProgressHUD alloc] initWithFrame:CGRectZero];
		sharedView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        sharedView.backgroundColor = [UIColor clearColor];
	}
	
	return sharedView;
}

+ (void)setStatus:(NSString *)string {
	[[ProgressHUD sharedView] setStatus:string];
}

#pragma mark -
#pragma mark Show Methods


+ (void)show {
	[ProgressHUD showInView:nil status:nil];
}


+ (void)showInView:(UIView*)view {
	[ProgressHUD showInView:view status:nil];
}


+ (void)showInView:(UIView*)view status:(NSString*)string {
	[ProgressHUD showInView:view status:string networkIndicator:YES];
//	[ProgressHUD showInView:view status:nil networkIndicator:YES];
}


+ (void)showInView:(UIView*)view status:(NSString*)string networkIndicator:(BOOL)show {
	[ProgressHUD showInView:view status:string networkIndicator:show posY:-1];
}


+ (void)showInView:(UIView*)view status:(NSString*)string networkIndicator:(BOOL)show posY:(CGFloat)posY {
	
	if(!view)
		view = [UIApplication sharedApplication].keyWindow;
	
	if(posY == -1)
		posY = floor(CGRectGetHeight(view.bounds)/2)-100;

//	[[ProgressHUD sharedView] showInView:view status:string networkIndicator:show posY:posY];
	[[ProgressHUD sharedView] showInView:view status:nil networkIndicator:show posY:posY];
}


#pragma mark -
#pragma mark Dismiss Methods

+ (void)dismiss {
	[[ProgressHUD sharedView] dismiss];
}

+ (void)dismissWithSuccess:(NSString*)successString {
	[[ProgressHUD sharedView] dismissWithStatus:successString error:NO];
}

+ (void)dismissWithError:(NSString*)errorString {
	[[ProgressHUD sharedView] dismissWithStatus:errorString error:YES];    
}

+ (void)dismissWithStatus:(BOOL)success andMessage:(NSString*)msgString {
    [[ProgressHUD sharedView] dismiss];
//	if (success) {
//		if (!msgString) {
//			msgString = @"Done";
//		}
//		[ProgressHUD dismissWithSuccess:msgString];
//	}else {
//		
//		if (!msgString) {
//			msgString = @"Request Failed";
//		}
//		[ProgressHUD dismissWithError:msgString];
//	}
}


#pragma mark -
#pragma mark Instance Methods

- (id)initWithFrame:(CGRect)frame {
	
    if ((self = [super initWithFrame:frame])) {
        
		self.userInteractionEnabled = YES;
        self.backgroundView.layer.cornerRadius = 10;
        self.backgroundView.layer.opacity = 0;
        self.backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
/*        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(memoryWarning:) 
                                                     name:UIApplicationDidReceiveMemoryWarningNotification
                                                   object:nil];
 */
    }
	
    return self;
}

- (void)setStatus:(NSString *)string {
	
	CGSize stringSize = [string sizeWithFont:self.stringLabel.font 
                           constrainedToSize:CGSizeMake(300, 300) 
                               lineBreakMode:NSLineBreakByWordWrapping];

    CGFloat stringWidth = stringSize.width + 28;

	if(stringWidth < 100)
		stringWidth = 100;

	self.backgroundView.bounds = CGRectMake(0, 0, ceil(stringWidth/2)*2, stringSize.height + 80.0);
	
	self.imageView.center = CGPointMake(CGRectGetWidth(self.backgroundView.bounds)/2, 36);
	
	self.stringLabel.hidden = NO;
	self.stringLabel.text = string;
	self.stringLabel.frame = CGRectMake(0, 66, CGRectGetWidth(self.backgroundView.bounds), stringSize.height);
	
	if(string)
		self.spinnerView.center = CGPointMake(ceil(CGRectGetWidth(self.backgroundView.bounds)/2)+0.5, 40.5);
	else
		self.spinnerView.center = CGPointMake(ceil(CGRectGetWidth(self.backgroundView.bounds)/2)+0.5, ceil(self.backgroundView.bounds.size.height/2)+0.5);
}

- (void)showInView:(UIView*)view status:(NSString*)string networkIndicator:(BOOL)show posY:(CGFloat)posY {
 
    [self setFrame:CGRectMake(0, 0, 1024, 768)];
	if(fadeOutTimer != nil)
        fadeOutTimer = nil;
	
	if(show)
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	else
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	self.imageView.hidden = YES;
    
//    self.frame = view.bounds;
//    self.center = view.center;
    
    //Configure background view
	[self setStatus:string];
	[spinnerView startAnimating];

	if(![self.backgroundView isDescendantOfView:view]) {
		self.backgroundView.layer.opacity = 0;
        [self setFrame:CGRectMake(0, 0, 1024, 768)];
		[view addSubview:self];
	}

	if(self.backgroundView.layer.opacity != 1) {
		
//		posY+=(CGRectGetHeight(self.backgroundView.bounds)/2);
//		self.backgroundView.center = CGPointMake(CGRectGetWidth(self.backgroundView.superview.bounds)/2, posY);
        
        //Check for the interface orientation Of that particular screen
        UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        if(interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight){
            int xForView = self.frame.size.width/2 - self.backgroundView.frame.size.width/2;
            int yForView = self.frame.size.height/2 - self.backgroundView.frame.size.height/2;

            self.backgroundView.frame = CGRectMake(xForView , yForView, self.backgroundView.frame.size.width, self.backgroundView.frame.size.height);
        }else{
            int xForView = self.frame.size.height/2 - self.backgroundView.frame.size.height/2;
            int yForView = self.frame.size.width/2 - self.backgroundView.frame.size.width/2;

            self.backgroundView.frame = CGRectMake(xForView , yForView, self.backgroundView.frame.size.width, self.backgroundView.frame.size.height);
        }
        
       
		self.backgroundView.layer.transform = CATransform3DScale(CATransform3DMakeTranslation(0, 0, 0), 1.3, 1.3, 1);
		self.backgroundView.layer.opacity = 0.3;
		
		[UIView animateWithDuration:0.15
							  delay:0
							options:UIViewAnimationOptionCurveEaseOut
						 animations:^{	
							 self.backgroundView.layer.transform = CATransform3DScale(CATransform3DMakeTranslation(0, 0, 0), 1, 1, 1);
							 self.backgroundView.layer.opacity = 1;
						 }
						 completion:NULL];
	}
}

- (void)dismiss {
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	[UIView animateWithDuration:0.15
						  delay:0
						options:UIViewAnimationOptionCurveEaseIn
					 animations:^{	
						 self.backgroundView.layer.transform = CATransform3DScale(CATransform3DMakeTranslation(0, 0, 0), 0.8, 0.8, 1.0);
						 self.backgroundView.layer.opacity = 0;
					 }
					 completion:^(BOOL finished){
                         if(self.backgroundView.layer.opacity == 0)
                             [self removeFromSuperview];
                     }];
}

- (void)dismissWithStatus:(NSString*)string error:(BOOL)error {
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
//	if(error)
//		self.imageView.image = [UIImage imageNamed:@"error.png"];
//	else
//		self.imageView.image = [UIImage imageNamed:@"success.png"];
	
	self.imageView.hidden = NO;
	
	[self setStatus:string];
	
	[self.spinnerView stopAnimating];
    
	if(fadeOutTimer != nil)
		fadeOutTimer = nil;
	
	fadeOutTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(dismiss) userInfo:nil repeats:NO];
//    [self performSelector:@selector(dismiss) withObject:nil afterDelay:1];
}

#pragma mark -
#pragma mark Getters

- (UILabel *)stringLabel {
    
    if (stringLabel == nil) {
        stringLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		stringLabel.textColor = [UIColor whiteColor];
		stringLabel.backgroundColor = [UIColor clearColor];
		stringLabel.adjustsFontSizeToFitWidth = NO;
		stringLabel.textAlignment = NSTextAlignmentCenter;
        stringLabel.numberOfLines = 3;
        stringLabel.lineBreakMode = NSLineBreakByWordWrapping   ;
		stringLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
		stringLabel.font = [UIFont boldSystemFontOfSize:16];
		stringLabel.shadowColor = [UIColor blackColor];
		stringLabel.shadowOffset = CGSizeMake(0, -1);
		[self.backgroundView addSubview:stringLabel];
    }
    
    return stringLabel;
}

- (UIView *)backgroundView {
    
    if (backgroundView == nil) {
        backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
		//Chaged : Abhinav
		self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self.backgroundView setUserInteractionEnabled:YES];
		[self addSubview:self.backgroundView];
    }
    
    return backgroundView;
}

- (UIImageView *)imageView {
    
    if (imageView == nil) {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
		[self.backgroundView addSubview:imageView];

    }
    
    return imageView;
}

- (UIActivityIndicatorView *)spinnerView {
    
    if (spinnerView == nil) {
        spinnerView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		spinnerView.hidesWhenStopped = YES;
		spinnerView.bounds = CGRectMake(0, 0, 37, 37);
		[self.backgroundView addSubview:spinnerView];
    }
    return spinnerView;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
            interfaceOrientation == UIInterfaceOrientationLandscapeRight || interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

-(NSUInteger)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskLandscape | UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate {
    return YES;
}

#pragma mark -
#pragma mark MemoryWarning

- (void)memoryWarning:(NSNotification *)notification {
	
}

@end
