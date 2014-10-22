
#import "Fraction.h"

//类的实现部分.
@implementation Fraction
{
  int numerator;
  int denominator;
}
-(void) print
{
  NSLog(@"%i/%i",numerator,denominator);
}
-(void) setNumerator: (int) n
{
  numerator = n;
}

-(void) setDenominator: (int) d
{
   denominator = d;
}
@end
