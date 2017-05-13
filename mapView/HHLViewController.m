//
//  HHLViewController.m
//  mapView
//
//  Created by Mehul Solanki on 12/05/17.
//  Copyright © 2017 sufalam. All rights reserved.
//

#import "HHLViewController.h"
#import <MapKit/MapKit.h>

@interface HHLViewController ()

@end

@implementation HHLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
+ (NSArray *)countriesOverlays {
    NSString *fileName = [[NSBundle mainBundle] pathForResource:@"countries" ofType:@"json"];
    
    
    NSData *overlayData = [NSData dataWithContentsOfFile:fileName];
    
    NSArray *countries = [[NSJSONSerialization JSONObjectWithData:overlayData options:NSJSONReadingAllowFragments error:nil] objectForKey:@"features"];
    
    NSMutableArray *overlays = [NSMutableArray array];
    
    for (NSDictionary *country in countries) {
        
        NSDictionary *geometry = country[@"geometry"];
        if ([geometry[@"type"] isEqualToString:@"Polygon"]) {
            MKPolygon *polygon = [HHLViewController overlaysFromPolygons:geometry[@"coordinates"] id:country[@"properties"][@"name"]];
            if (polygon) {
                [overlays addObject:polygon];
            }
            
            
        } else if ([geometry[@"type"] isEqualToString:@"MultiPolygon"]){
            for (NSArray *polygonData in geometry[@"coordinates"]) {
                MKPolygon *polygon = [HHLViewController overlaysFromPolygons:polygonData id:country[@"properties"][@"name"]];
                if (polygon) {
                    [overlays addObject:polygon];
                }
            }
        } else {
            NSLog(@"Unsupported type: %@", geometry[@"type"]);
        }
    }
    
    return overlays;
    
}

+ (MKPolygon *)overlaysFromPolygons:(NSArray *)polygons id:(NSString *)title
{
    NSMutableArray *interiorPolygons = [NSMutableArray arrayWithCapacity:[polygons count] - 1];
    for (int i = 1; i < [polygons count]; i++) {
        [interiorPolygons addObject:[HHLViewController polygonFromPoints:polygons[i] interiorPolygons:nil]];
    }
    
    MKPolygon *overlayPolygon = [HHLViewController polygonFromPoints:polygons[0] interiorPolygons:interiorPolygons];
    overlayPolygon.title = title;
    
    
    return overlayPolygon;
}

+ (MKPolygon *)polygonFromPoints:(NSArray *)points interiorPolygons:(NSArray *)polygons
{
    NSInteger numberOfCoordinates = [points count];
    CLLocationCoordinate2D *polygonPoints = malloc(numberOfCoordinates * sizeof(CLLocationCoordinate2D));
    
    NSInteger index = 0;
    for (NSArray *pointArray in points) {
        polygonPoints[index] = CLLocationCoordinate2DMake([pointArray[1] floatValue], [pointArray[0] floatValue]);
        index++;
    }
    
    MKPolygon *polygon;
    
    if (polygons) {
        polygon = [MKPolygon polygonWithCoordinates:polygonPoints count:numberOfCoordinates interiorPolygons:polygons];
    } else {
        polygon = [MKPolygon polygonWithCoordinates:polygonPoints count:numberOfCoordinates];
    }
    free(polygonPoints);
    
    return polygon;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
