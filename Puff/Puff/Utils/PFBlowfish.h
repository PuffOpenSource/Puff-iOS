#import <Foundation/Foundation.h>

typedef enum PFBlowFishMode
{
    modeEBC,    // electronic-code-book
    modeCBC     // cipher-block-chaining
} PFBlowFishMode;

typedef enum PFBlowFishPadding
{
    paddingRFC,
    paddingZero
} PFBlowFishPadding;

@interface PFBlowfish : NSObject {
    PFBlowFishMode mode;
    PFBlowFishPadding padding;
    unsigned short int N, blockSize;
    
@private
    SInt32 P[16 + 2];
    SInt32 S[4][256];
}
@property(nonatomic, retain) NSString *Key; // Maximum 448 Bits, will be encoded using ASCII
@property(nonatomic, retain) NSString *IV;  // 8 Byte ASCII

- (NSString *)encrypt:(NSString *)plain withMode:(PFBlowFishMode)pMode
          withPadding:(PFBlowFishPadding)pPadding;
- (NSString *)decrypt:(NSString *)crypted withMode:(PFBlowFishMode)pMode
          withPadding:(PFBlowFishPadding)pPadding;
- (void)prepare;
- (NSString *)pad:(NSString *)plain;
- (NSString *)removePad:(NSString *)plain;
- (void)encipher:(SInt32 *)xl xr:(SInt32 *)xr;
- (void)decipher:(SInt32 *)xl xr:(SInt32 *)xr;
- (SInt32)F:(SInt32)v;

@end

static inline void pfswap(SInt32 *l, SInt32 *r) {
    *l ^= *r;
    *r ^= *l;
    *l ^= *r;
}
