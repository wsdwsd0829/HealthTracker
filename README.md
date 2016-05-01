# HealthTracker
Display 30 and 7 day's Heart Rate and Weight data from network

[[https://github.com/wsdwsd0829/HealthTracker/blob/master/Intro/sevendays.png|alt=octocat]]
[[https://github.com/wsdwsd0829/HealthTracker/blob/master/Intro/thirtydays.png|alt=octocat]]



# References
http://solutionoptimist.com/2013/12/28/awesome-github-tricks/
https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/URLLoadingSystem/NSURLSessionConcepts/NSURLSessionConcepts.html

# Found leak with instrument tool 
  1. solve block keep strong self:
    __weak id weakself = self;
    [[WDLoginManager defaultManager] loginWithUsername:self.usernameField.text withPassword:self.passwordField.text withHandler:^(NSString *token) {
        ViewController * strongSelf = weakself;
  2. finishTasksAndInvalidate of NSURLSession to release task. 
  [[https://github.com/wsdwsd0829/HealthTracker/blob/master/Intro/urlsessionleak.png|alt=octocat]]

# Error handling

# Testing 
Fully tested model, service and builder. Partially tested controller, need more. 

# Bug fixing
  1. NSURLComponents cannot take nil url to parse, take it as Error and handle it. 
  2. Handle token invalid or login invalid like message from backend rather then NSError, create NSError by self.

# Issue framework has leaking some how. Need more time to investigate.
