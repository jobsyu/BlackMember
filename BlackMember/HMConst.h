#import <Foundation/Foundation.h>

#ifdef DEBUG
#define HMLog(...) NSLog(__VA_ARGS__)
#else
#define HMLog(...)
#endif

#define HMColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define HMGlobalBg HMColor(230, 230, 230)

#define HMString(str) [NSString stringWithFormat:@"  %@  ", str]
#define HMNotificationCenter [NSNotificationCenter defaultCenter]
#define HMAddObsver(methodName, noteName) [HMNotificationCenter addObserver:self selector:@selector(methodName) name:noteName object:nil];
#define HMRemoveObsver [HMNotificationCenter removeObserver:self];

extern NSString *const HMCityDidChangeNotification;
extern NSString *const HMSelectCityName;

extern NSString *const HMSortDidChangeNotification;
extern NSString *const HMSelectSort;

extern NSString *const HMCategoryDidChangeNotification;
extern NSString *const HMSelectCategory;
extern NSString *const HMSelectSubcategoryName;

extern NSString *const HMRegionDidChangeNotification;
extern NSString *const HMSelectRegion;
extern NSString *const HMSelectSubregionName;

extern NSString *const HMCollectStateDidChangeNotification;
extern NSString *const HMIsCollectKey;
extern NSString *const HMCollectDealKey;

extern NSString *const HMRecentStateDidChangeNotification;
extern NSString *const HMIsRecentKey;
extern NSString *const HMRecentDealKey;

extern NSString * const HMedit;
extern NSString * const HMdone;

