CMPopTipView
============

An iOS UIView subclass that displays a rounded rect "bubble", containing
a text message, pointing at a specified button or view.

A CMPopTipView will automatically position itself within the view so that
it is pointing at the specified button or view, locating the "pointer"
as necessary.

A CMPopTipView can be dismissed by the user tapping on it.  It can also
be dismissed programatically.

CMPopTipView is rendered entirely by Core Graphics.


Screenshots
-----------

|iphone_demo_1| |iphone_demo_2|

.. |iphone_demo_1| image:: http://farm5.static.flickr.com/4005/5191641030_969f04b315.jpg
.. |iphone_demo_2| image:: http://farm5.static.flickr.com/4112/5191046667_db62f0a3e4.jpg


Usage
-----

Example::

  // Present a CMPopTipView pointing at a UIBarButtonItem in the nav bar
  CMPopTipView *navBarLeftButtonPopTipView = [[[CMPopTipView alloc] initWithMessage:@"A Message"] autorelease];
  navBarLeftButtonPopTipView.delegate = self;
  [navBarLeftButtonPopTipView presentPointingAtBarButtonItem:self.navigationItem.leftBarButtonItem animated:YES];
  
  // Dismiss a CMPopTipView
  [navBarLeftButtonPopTipView dismissAnimated:YES];
  
  // CMPopTipViewDelegate method
  - (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView {
    // Any cleanup code, such as releasing the CMPopTipView object if necessary
  }


License
-------

CMPopTipView is released under the MIT license.  See LICENSE for details.

CMPopTipView is copyright (c) Chris Miles 2010.
