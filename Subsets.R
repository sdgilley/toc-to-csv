## Run Create-CSV first to create the main data.frame, merged.

## Here's some subsets I've created by searching for specific terms in ms.custom.

# Pick out the cliv1 and cliv2 entries only from custom metadata
merged$cliv1 <- grepl( "cliv1", merged$ms.custom, fixed = TRUE)
merged$cliv2 <- grepl( "cliv2", merged$ms.custom, fixed = TRUE)
cli1 <- subset(merged, merged$cliv1 == TRUE )   # Apply subset function
cli2 <- subset(merged, merged$cliv2 == TRUE )   # Apply subset function

cli <- subset(merged, merged$cliv1 == TRUE | merged$cliv2 == TRUE)   # Apply subset function
cli$ms.custom <- NULL
write.csv(cli, file= "cli-docs.csv", na="")

# Pick out the sdkv1 and sdkv2 entries only
merged$sdkv1 <- grepl( "sdkv1", merged$ms.custom, fixed = TRUE)
merged$sdkv2 <- grepl( "sdkv2", merged$ms.custom, fixed = TRUE)

sdk1 <- subset(merged, merged$sdkv1 == TRUE )   # Apply subset function
sdk2 <- subset(merged, merged$sdkv2 == TRUE )   # Apply subset function

sdk <- subset(merged, merged$sdkv1 == TRUE | merged$sdkv2 == TRUE)   # Apply subset function
sdk$ms.custom <- NULL
write.csv(sdk, file= "sdk-docs.csv", na="")


# find me
merged$me <- merged$ms.author == 'sgilley' 
merged$me2 <- merged$ms.reviewer == 'sgilley'
me <- subset(merged, merged$me == TRUE | merged$me2 == TRUE)   # Apply subset function
me$ms.custom <- NULL
write.csv(me, file= "mydocs.csv", na="")
