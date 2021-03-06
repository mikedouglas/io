
#import "IPhoneIoPlayerAppDelegate.h"
#import "IoObject.h"

@implementation IPhoneIoPlayerAppDelegate

@synthesize window;
@synthesize contentView;

void MyIoStatePrintCallback(void *state, const UArray *u)
{
	printf("print: '%s'\n", UArray_bytes(u));
}

void MyIoStateExceptionCallback(void *state, IoObject *o)
{
	IoObject *result = IoObject_asString_(result, NULL);
	printf("exception: '%s'\n", CSTRING(result));
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	IoObject *result = IoState_doCString_(ioState, [[input text] UTF8String]);
	
	result = IoObject_asString_(result, NULL);
	
	if (ISSEQ(result))
	{
		[output setText:[NSString stringWithCString:CSTRING(result)]];
	}
	else
	{
		[output setText:@"[error]"];
	}
	
	return NO;
}

- (void)applicationDidFinishLaunching:(UIApplication *)application 
{	
	self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
	//self.contentView = [[[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]] autorelease];

	{
		CGRect inputFrame = [[UIScreen mainScreen] applicationFrame];
		inputFrame.origin.y = 25;
		inputFrame.size.height = 25;
		input = [[[UITextField alloc] initWithFrame:inputFrame] autorelease];
		input.borderStyle = UITextFieldBorderStyleRounded;
		[input setFont:[UIFont systemFontOfSize:18]];
		[window addSubview:input];
		input.delegate = self;
	}

	{
		CGRect outputFrame = [[UIScreen mainScreen] applicationFrame];
		int h = 60;
		outputFrame.origin.y = h;
		outputFrame.size.height -= h;
		output = [[[UITextView alloc] initWithFrame:outputFrame] autorelease]; 

		//[output setText:@"hello world!"];
		[output setEditable:NO];
		[window addSubview:output];
	}

	{
		ioState = IoState_new();
		//IoState_setBindingsInitCallback(ioState, (IoStateBindingsInitCallback *)IoAddonsInit);
		IoState_init(ioState);
		IoState_argc_argv_(ioState, 0, NULL);
		IoState_printCallback_(ioState, MyIoStatePrintCallback);
		IoState_exceptionCallback_(ioState, MyIoStateExceptionCallback);
	}
	
	[window makeKeyAndVisible];
}

- (void)dealloc 
{
	IoState_free(ioState);
	[contentView release];
	[window release];
	[super dealloc];
}

@end
