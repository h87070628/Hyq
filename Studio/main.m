
//
//  main.m
//  HelloLua
//
//  Created by Walzer on 11-6-15.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

//  #import <UIKit/UIKit.h>

#import <Foundation/Foundation.h>
#import "Fraction.h"

int main(int argc, char *argv[]) {

    @autoreleasepool {

      Fraction *myFaction = [Fraction new];

      [myFaction setNumerator:1]; 
      [myFaction setDenominator:3];

      NSLog(@"The value of myFraction is:");
      [myFaction print];

    }

    return 0;
}


