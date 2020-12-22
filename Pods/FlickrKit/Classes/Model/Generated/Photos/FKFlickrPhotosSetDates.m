//
//  FKFlickrPhotosSetDates.m
//  FlickrKit
//
//  Generated by FKAPIBuilder.
//  Copyright (c) 2013 DevedUp Ltd. All rights reserved. http://www.devedup.com
//
//  DO NOT MODIFY THIS FILE - IT IS MACHINE GENERATED


#import "FKFlickrPhotosSetDates.h" 

@implementation FKFlickrPhotosSetDates



- (BOOL) needsLogin {
    return YES;
}

- (BOOL) needsSigning {
    return YES;
}

- (FKPermission) requiredPerms {
    return 1;
}

- (NSString *) name {
    return @"flickr.photos.setDates";
}

- (BOOL) isValid:(NSError **)error {
    BOOL valid = YES;
	NSMutableString *errorDescription = [[NSMutableString alloc] initWithString:@"You are missing required params: "];
	if(!self.photo_id) {
		valid = NO;
		[errorDescription appendString:@"'photo_id', "];
	}

	if(error != NULL) {
		if(!valid) {	
			NSDictionary *userInfo = @{NSLocalizedDescriptionKey: errorDescription};
			*error = [NSError errorWithDomain:FKFlickrKitErrorDomain code:FKErrorInvalidArgs userInfo:userInfo];
		}
	}
    return valid;
}

- (NSDictionary *) args {
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
	if(self.photo_id) {
		[args setValue:self.photo_id forKey:@"photo_id"];
	}
	if(self.date_posted) {
		[args setValue:self.date_posted forKey:@"date_posted"];
	}
	if(self.date_taken) {
		[args setValue:self.date_taken forKey:@"date_taken"];
	}
	if(self.date_taken_granularity) {
		[args setValue:self.date_taken_granularity forKey:@"date_taken_granularity"];
	}

    return [args copy];
}

- (NSString *) descriptionForError:(NSInteger)error {
    switch(error) {
		case FKFlickrPhotosSetDatesError_PhotoNotFound:
			return @"Photo not found";
		case FKFlickrPhotosSetDatesError_NotEnoughArguments:
			return @"Not enough arguments";
		case FKFlickrPhotosSetDatesError_InvalidGranularity:
			return @"Invalid granularity";
		case FKFlickrPhotosSetDatesError_InvalidDate_posted:
			return @"Invalid date_posted";
		case FKFlickrPhotosSetDatesError_InvalidDateTakenFormat:
			return @"Invalid Date Taken Format";
		case FKFlickrPhotosSetDatesError_InvalidDateTaken:
			return @"Invalid Date Taken";
		case FKFlickrPhotosSetDatesError_SSLIsRequired:
			return @"SSL is required";
		case FKFlickrPhotosSetDatesError_InvalidSignature:
			return @"Invalid signature";
		case FKFlickrPhotosSetDatesError_MissingSignature:
			return @"Missing signature";
		case FKFlickrPhotosSetDatesError_LoginFailedOrInvalidAuthToken:
			return @"Login failed / Invalid auth token";
		case FKFlickrPhotosSetDatesError_UserNotLoggedInOrInsufficientPermissions:
			return @"User not logged in / Insufficient permissions";
		case FKFlickrPhotosSetDatesError_InvalidAPIKey:
			return @"Invalid API Key";
		case FKFlickrPhotosSetDatesError_ServiceCurrentlyUnavailable:
			return @"Service currently unavailable";
		case FKFlickrPhotosSetDatesError_WriteOperationFailed:
			return @"Write operation failed";
		case FKFlickrPhotosSetDatesError_FormatXXXNotFound:
			return @"Format \"xxx\" not found";
		case FKFlickrPhotosSetDatesError_MethodXXXNotFound:
			return @"Method \"xxx\" not found";
		case FKFlickrPhotosSetDatesError_InvalidSOAPEnvelope:
			return @"Invalid SOAP envelope";
		case FKFlickrPhotosSetDatesError_InvalidXMLRPCMethodCall:
			return @"Invalid XML-RPC Method Call";
		case FKFlickrPhotosSetDatesError_BadURLFound:
			return @"Bad URL found";
  
		default:
			return @"Unknown error code";
    }
}

@end
