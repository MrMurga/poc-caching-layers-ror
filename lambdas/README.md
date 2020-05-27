# Lambdas
Lambdas must be declared in the N.Virgina zone (region: us-east-1)

After a lambda is created, it's recommended to use Visual Studio Code + AWS plugin to test the lambda, or create a test suite under the "Test" button in the Lambda page itself

Note that lambdas can be tested using the AWS or Visual Studio Code only after they're saved. It's recommended that the lambda be saved locally and an rspec be created
around it to avoid production issues

## Lambda events
https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/lambda-cloudfront-trigger-events.html

How to choose events: https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/lambda-how-to-choose-event.html

### Examples
https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/lambda-event-structure.html
https://aws.amazon.com/blogs/networking-and-content-delivery/dynamically-route-viewer-requests-to-any-origin-using-lambdaedge/
https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/lambda-examples.html
https://docs.aws.amazon.com/lambda/latest/dg/lambda-edge.html

## Framework for testing lambdas
See ./redirect_to_webp/test.js