CMPopTipView
============

An iOS UIView subclass that displays a rounded rect "bubble", containing
a text message, pointing at a specified button or view.

A CMPopTipView will automatically position itself within the view so that
it is pointing at the specified button or view, positioning the "pointer"
as necessary.

A CMPopTipView can be pointed at any UIView within the containing view.
It can also be pointed at a UIBarButtonItem within either a UINavigationBar
or a UIToolbar and it will automatically position itself to point at the
target.

The background and text colors can be customised if the defaults are not
suitable.

Two animation options are available for when a CMPopTipView is presented:
"slide" and "pop".

A CMPopTipView can be dismissed by the user tapping on it.  It can also
be dismissed programatically.

CMPopTipView is rendered entirely by Core Graphics.

The source includes a universal (iPhone/iPad) demo app.

一个泡泡风格的提示框开源控件, 继承自UIView。iPad,iPhone通用


URLs
----

 * https://github.com/chrismiles/CMPopTipView
 * http://chrismiles-tech.blogspot.com/2010/12/cmpoptipview-custom-popup-view-for-ios.html
 * http://chrismiles-tech.blogspot.com/2011/05/cmpoptipview-new-animation-option.html

Used in apps:
 * River Level http://itunes.apple.com/au/app/river-level/id356158594?mt=8
 * The Happiest Hour http://itunes.apple.com/au/app/the-happiest-hour/id414453120?mt=8
 * I-Sea http://www.i-sea.no/
 * *Many many more apps*
 * *Your app here ...?*


Screenshots
-----------

|iphone_demo_1| |iphone_demo_2| |ipad_demo_1|

.. |iphone_demo_1| image:: http://farm5.static.flickr.com/4005/5191641030_2b93a4a559.jpg
.. |iphone_demo_2| image:: http://farm5.static.flickr.com/4112/5191046667_109a98dfc7.jpg
.. |ipad_demo_1| image:: http://farm6.static.flickr.com/5170/5266199718_4720c56384.jpg


Videos
------

http://www.youtube.com/watch?v=nul9VA_QsGI


Usage
-----

Example 1 - point at a UIBarButtonItem in a nav bar::

  // Present a CMPopTipView pointing at a UIBarButtonItem in the nav bar
  CMPopTipView *navBarLeftButtonPopTipView = [[[CMPopTipView alloc] initWithMessage:@"A Message"] autorelease];
  navBarLeftButtonPopTipView.delegate = self;
  [navBarLeftButtonPopTipView presentPointingAtBarButtonItem:self.navigationItem.leftBarButtonItem animated:YES];
  
  // Dismiss a CMPopTipView
  [navBarLeftButtonPopTipView dismissAnimated:YES];
  
  // CMPopTipViewDelegate method
  - (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView {
    // Any cleanup code, such as releasing a CMPopTipView instance variable, if necessary
  }


Example 2 - pointing at a UIButton, with custom color scheme::

  - (IBAction)buttonAction:(id)sender {
    // Toggle popTipView when a standard UIButton is pressed
    if (nil == self.roundRectButtonPopTipView) {
      self.roundRectButtonPopTipView = [[[CMPopTipView alloc] initWithMessage:@"My message"] autorelease];
      self.roundRectButtonPopTipView.delegate = self;
      self.roundRectButtonPopTipView.backgroundColor = [UIColor lightGrayColor];
      self.roundRectButtonPopTipView.textColor = [UIColor darkTextColor];

      UIButton *button = (UIButton *)sender;
      [self.roundRectButtonPopTipView presentPointingAtView:button inView:self.view animated:YES];
    }
    else {
      // Dismiss
      [self.roundRectButtonPopTipView dismissAnimated:YES];
      self.roundRectButtonPopTipView = nil;
    }
  }

  #pragma mark CMPopTipViewDelegate methods
  - (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView {
    // User can tap CMPopTipView to dismiss it
    self.roundRectButtonPopTipView = nil;
  }


ARC
---

The CMPopTipView Master branch uses ARC as of version 2.0.

If you want a non-ARC version you should look at tag 1.3.0.


Support
-------

CMPopTipView is provided open source with no warranty and no guarantee
of support. However, best effort is made to address issues raised on Github
https://github.com/chrismiles/CMPopTipView/issues .

If you would like assistance with integrating CMPopTipView or modifying
it for your needs, contact the author Chris Miles <miles.chris@gmail.com> for consulting
opportunities.


License
-------

CMPopTipView is Copyright (c) 2010-2013 Chris Miles and released open source
under a MIT license:

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.
