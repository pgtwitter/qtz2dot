#import <Foundation/Foundation.h>

void f(NSDictionary *obj, NSString *parent){
    NSString *name= [obj objectForKey:@"key"]?[obj objectForKey:@"key"]:@"rootPath";
    NSString *key= parent?[NSString stringWithFormat:@"%@__%@", parent, name]:name;
    obj= [obj objectForKey:@"state"];
    
    //if ([obj objectForKey:@"userInfo"]) {
    //    NSDictionary *udic= [NSUnarchiver unarchiveObjectWithData:[obj objectForKey:@"userInfo"]];
    //    NSLog(@"%@", udic);
    //}
    
    NSArray *aobjs= (NSArray *)[obj objectForKey:@"nodes"];
    if (aobjs) {
        printf("\tsubgraph cluster_%s {\n", [key cStringUsingEncoding:NSUTF8StringEncoding]);
        printf("\t\tlabel = \"%s\";\n", [name cStringUsingEncoding:NSUTF8StringEncoding]);
        
        for(int i= 0;i<[aobjs count];i++){
            NSDictionary *aobj= [aobjs objectAtIndex:i];
            NSString *aname= [aobj objectForKey:@"key"];
            if (!aname)
                continue;
            NSString *akey= [NSString stringWithFormat:@"%@__%@", key, aname];
            NSString *aclass= [aobj objectForKey:@"class"];
            NSString *style= @"";
            if ([aclass isEqualToString:@"QCSprite"]||[aclass isEqualToString:@"QCLine"]) { //ZURU
                style= @"style=\"filled\" fillcolor=\"#EAEAFA\"";
            }
            else if ([aclass isEqualToString:@"QCKeyboard"]) { //ZURU
                style= @"style=\"filled\" fillcolor=\"#FAEAEA\"";
            }
            NSString* line= [NSString stringWithFormat:@"%@ [label=\"%@:%@\" %@];", akey, aname, aclass, style];
            printf("\t\t%s\n", [line cStringUsingEncoding:NSUTF8StringEncoding]);
            
            f(aobj, key);
        }
        
        NSDictionary *dobj= [obj objectForKey:@"connections"];
        if (dobj) {
            NSString *key2;
            NSEnumerator *keyEnum2= [dobj keyEnumerator];
            while((key2= [keyEnum2 nextObject])!=nil) {
                if ([key2 hasPrefix:@"connection_"]) {
                    NSDictionary *ddobj= (NSDictionary *)[dobj objectForKey:key2];
                    NSString* line= [NSString stringWithFormat:@"%@__%@ -> %@__%@ [taillabel = \"%@\" headlabel = \"%@\"];",
                                     key, [ddobj objectForKey:@"sourceNode"],
                                     key, [ddobj objectForKey:@"destinationNode"],
                                     [ddobj objectForKey:@"sourcePort"],
                                     [ddobj objectForKey:@"destinationPort"]];
                    printf("\t\t%s\n", [line cStringUsingEncoding:NSUTF8StringEncoding]);
                }
            }
        }
        
        printf("\t}\n");
        
        for(int i= 0;i<[aobjs count]&&i<1;i++){
            NSDictionary *aobj= [aobjs objectAtIndex:i];
            NSString *aname= [aobj objectForKey:@"key"]?[aobj objectForKey:@"key"]:@"rootPath";
            NSString *akey= [NSString stringWithFormat:@"%@__%@", key, aname];
            NSString* line= [NSString stringWithFormat:@"%@ -> %@ [lhead = cluster_%@ ]", key, akey, key];
            printf("\t\t%s\n", [line cStringUsingEncoding:NSUTF8StringEncoding]);
        }
    }
    
}
int main (int argc, const char * argv[])
{
    if (argc!=2)
        return 1;
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    {
        NSString *file= [NSString stringWithCString:argv[1] encoding:NSUTF8StringEncoding];
        if ([[file pathExtension] isEqualToString:@"qtz"]) {
            NSDictionary *dic= [NSDictionary dictionaryWithContentsOfFile:file];
            printf("digraph g {\n");
            //printf("\trankdir=LR;\n");
            printf("\tgraph [compound = true];\n");
            f([dic objectForKey:@"rootPatch"], nil);
            printf("}\n");
        }
    }
    [pool drain];
    return 0;
}
