//
//  GitHubUserFactory.m
//  GitHubLib
//
//  Created by Magnus Ernstsson on 10/3/10.
//  Copyright 2010 Patchwork Solutions AB. All rights reserved.
//

#import "GitHubUserFactory.h"

@implementation GitHubUserFactory

#pragma mark -
#pragma mark Internal implementation declaration

static NSDictionary *localEndElement;

static NSDictionary *localStartElement;

#pragma mark -
#pragma mark Memory and member management

//Retain
@synthesize user;

-(void)cleanUp {
  self.user = nil;
  [super cleanUp];
}

-(void)dealloc {
  [self cleanUp];
  [super dealloc];
}

-(NSDictionary *)startElement {
  
  return localStartElement;
}

-(NSDictionary *)endElement {
  
  return localEndElement;
}

#pragma mark -
#pragma mark Internal implementation declaration

-(void)startElementUser {
  
  self.user = [GitHubUserImp user];
}

-(void)endElementUser {
  
  [(id<GitHubServiceGotUserDelegate>)self.delegate gitHubService:self
                                                         gotUser:self.user];
}

-(void)endElementName {
  
  self.user.name = currentStringValue;
}

-(void)endElementGravatarId {
  
  self.user.gravatarId = currentStringValue;
}

-(void)endElementCompany {
  
  self.user.company = currentStringValue;
}

-(void)endElementLocation {
  
  self.user.location = currentStringValue;
}

-(void)endElementBlog {
  
  self.user.blog = [self createURLFromString:self.currentStringValue];
}

-(void)endElementEmail {
  
  self.user.email = currentStringValue;
}

-(void)endElementLogin {
  
  self.user.login = currentStringValue;
}

-(void)endElementId {
  
  self.user.ID = currentStringValue;
}

-(void)endElementCreatedAt {

  self.user.creationDate =
  [self createDateFromString:self.currentStringValue];
}

-(void)endElementPublicRepoCount {
  
  self.user.publicRepoCount = [currentStringValue intValue];
}

-(void)endElementPublicGistCount {
  
  self.user.publicGistCount = [currentStringValue intValue];
}

-(void)endElementFollowingCount {
  
  self.user.followingCount = [currentStringValue intValue];
}

-(void)endElementFollowersCount {
  
  self.user.followersCount = [currentStringValue intValue];
}

-(void)endElementType {
  
  self.user.type = currentStringValue;
}

-(void)endElementError {
  
  [self handleErrorWithCode:GitHubServerServerError];
}

#pragma mark -
#pragma mark Super override implementation

+(void)initialize {
  
  localStartElement =
  [[NSDictionary dictionaryWithObjectsAndKeys:
    [NSValue valueWithPointer:@selector
     (startElementUser)], @"user",
    nil] retain];
  
  localEndElement =
  [[NSDictionary dictionaryWithObjectsAndKeys:
    [NSValue valueWithPointer:@selector
     (endElementUser)], @"user",
    [NSValue valueWithPointer:@selector
     (endElementName)], @"name",
    [NSValue valueWithPointer:@selector
     (endElementGravatarId)], @"gravatar-id",
    [NSValue valueWithPointer:@selector
     (endElementCompany)], @"company",
    [NSValue valueWithPointer:@selector
     (endElementLocation)], @"location",
    [NSValue valueWithPointer:@selector
     (endElementBlog)], @"blog",
    [NSValue valueWithPointer:@selector
     (endElementEmail)], @"email",
    [NSValue valueWithPointer:@selector
     (endElementLogin)], @"login",
    [NSValue valueWithPointer:@selector
     (endElementId)], @"id",
    [NSValue valueWithPointer:@selector
     (endElementCreatedAt)], @"created-at",
    [NSValue valueWithPointer:@selector
     (endElementPublicRepoCount)], @"public-repo-count",
    [NSValue valueWithPointer:@selector
     (endElementPublicGistCount)], @"public-gist-count",
    [NSValue valueWithPointer:@selector
     (endElementFollowingCount)], @"following-count",
    [NSValue valueWithPointer:@selector
     (endElementFollowersCount)], @"followers-count",
    [NSValue valueWithPointer:@selector
     (endElementType)], @"type",
    [NSValue valueWithPointer:@selector
     (endElementError)], @"error",
    nil] retain];
}

#pragma mark -
#pragma mark Interface implementation
#pragma mark - Class

+(GitHubUserFactory *)userFactoryWithDelegate:
(id<GitHubServiceGotUserDelegate>)delegate {
  
  return [[[GitHubUserFactory alloc] initWithDelegate:delegate] autorelease]; 
}

#pragma mark - Instance

-(void)requestUserByName:(NSString *) name {
  
  [self makeRequest:[NSString
                     stringWithFormat:@"%@/api/v2/xml/user/show/%@",
                     [GitHubBaseFactory serverAddress], name]];
}

-(void)requestUserByEmail:(NSString *) email {
  
  [self makeRequest:[NSString
                     stringWithFormat:@"%@/api/v2/xml/user/email/%@",
                     [GitHubBaseFactory serverAddress], email]];
}

@end
