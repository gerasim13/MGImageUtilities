//
//  UIImage+Tint.m
//
//  Created by Matt Gemmell on 04/07/2010.
//  Copyright 2010 Instinctive Code.
//

#import "UIImage+Tint.h"


@implementation UIImage (MGTint)


- (UIImage *)imageTintedWithColor:(UIColor *)color
{
	// This method is designed for use with template images, i.e. solid-coloured mask-like images.
	return [self imageTintedWithColor:color fraction:0.0]; // default to a fully tinted mask of the image.
}


- (UIImage*)imageTintedWithColor:(UIColor*)color fraction:(CGFloat)fraction
{
	if (color)
    {
        UIImage *image = nil;
        UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
        {
            // Construct new image the same size as this one.
            CGRect rect = CGRectZero;
            rect.size   = self.size;
            // Composite tint color at its own opacity.
            CGContextRef context = UIGraphicsGetCurrentContext();
            [color set];
            CGContextFillRect(context, rect);
            CGContextTranslateCTM(context, 0, self.size.height);
            CGContextScaleCTM(context, 1.0, -1.0);
            // Mask tint color-swatch to this image's opaque mask.
            // We want behaviour like NSCompositeDestinationIn on Mac OS X.
            {
                CGContextSetAlpha(context, 1.0);
                CGContextSetBlendMode(context, kCGBlendModeDestinationIn);
                CGContextDrawImage(context, rect, self.CGImage);
            }
            // Finally, composite this image over the tinted mask at desired opacity.
            // We want behaviour like NSCompositeSourceOver on Mac OS X.
            if (fraction > 0.0)
            {
                CGContextSetAlpha(context, fraction);
                CGContextSetBlendMode(context, kCGBlendModeSourceAtop);
                CGContextDrawImage(context, rect, self.CGImage);
            }
            image = UIGraphicsGetImageFromCurrentImageContext();
        }
        UIGraphicsEndImageContext();
        return image;
	}
	return self;
}



@end
