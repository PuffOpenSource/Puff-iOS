//
//  Constants.h
//  Puff
//
//  Created by bob.sun on 17/10/2016.
//  Copyright © 2016 bob.sun. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

static uint64_t const       catTypeBuiltIn                  =  0x100;
static uint64_t const       catTypeCustom                   =  0x101;

//Builtin Category ID
static uint64_t const       catIdPrivate                    = -1;
static uint64_t const       catIdRecent                     = 1;
static uint64_t const       catIdMail                       = 2;
static uint64_t const       catIdSocial                     = 3;
static uint64_t const       catIdCards                      = 4;
static uint64_t const       catIdComputers                  = 5;
static uint64_t const       catIdDevices                    = 6;
static uint64_t const       catIdEntry                      = 7;
static uint64_t const       catIdWebsite                    = 8;


static uint64_t const       typeMaster                      = 0x5020;//The account type in db
static uint64_t const       typeQuick                       = 0x5022;

static NSString * const     kPFNewInstall                   = @"kPFNewInstall";

//String Constants
static NSString * const kUserDefaultGroup       =   @"group.sun.bob.leela";
static NSString * const kTodayNewData           =   @"sun.bob.leela.today.newdata";
static NSString * const kTodayAccount           =   @"sun.bob.leela.today.accout";
static NSString * const kTodayPassword          =   @"sun.bob.leela.today.password";
static NSString * const kTodayAdditional        =   @"sun.bob.leela.today.additional";
static NSString * const kTodayIcon              =   @"sun.bob.leela.today.icon";
#endif /* Constants_h */
