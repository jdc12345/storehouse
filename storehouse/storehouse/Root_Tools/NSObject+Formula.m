//

#import "NSObject+Formula.h"

@implementation NSObject (Formula)

/**
 *  根据参考获取结果
 *
 *  @param consule      参考值
 *  @param resultValue  结果的start到end
 *  @param consultValue 参考的start到end
 *
 *  @return 结果指
 */
+ (CGFloat)resultWithConsult:(CGFloat)consule andResultValue:(YHValue)resultValue andConsultValue:(YHValue)consultValue {
    // a * r.start + b = c.start
    // a * r.end + b = c.end

    // a * (r.start - r.end) + b = c.start - c.ent;
    CGFloat a = (resultValue.startValue - resultValue.endValue) / (consultValue.startValue - consultValue.endValue);
    CGFloat b = resultValue.startValue - (a * consultValue.startValue);

    return a * consule + b;
}

@end
