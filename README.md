# Lemonogin

Tired of typing the same old username/password combinations for test accounts while developing your apps? Worry no more, you can use Lemonogin to do the typing for you.

This is a little tool I wrote to simplify the process of signin in.

![Image](./images/lemonogin.gif?raw=true)

Long press on a UI element, a popup appears with a list of accounts, pick one and the username/password fields are filled.

This is intended mostly for apps that:

1. Use user accounts
2. You have to frequentely sign out and sign in frequently
3. You and your team share and use the same test accounts

A word of warning though: this is intended only for use while developing, release versions should not include this tool.

## Usage

Add Lemonogin.h/.m to your project and include the header in your auth view controller.

After your setup code, configure Lemonogin using the following snippet as a template.

~~~ {.objectivec}
#ifdef DEBUG

    [[Lemonogin manager] setSourceURL:[NSURL URLWithString:@"http://localhost:8000/lemonogin.html"]];
    [[Lemonogin manager] triggerOnAnchor:self.loginButton
                                    view:self.view
                                callback:^(NSString *username, NSString *password, NSString *notes) {
                                    self.usernameField.text = username;
                                    self.passwordField.text = password;
                                }];
#endif
~~~

1. The sourceURL property should point to a publicly accessible file. Put it in Dropbox, your server, or run a locally server with python -m SimpleHTTPServer or php -S localhost:8000. Use the provided lemonogin.html as a template.
2. The anchor should be the view you want to trigger Lemonogin from (only with a longpress for now).
3. Let it know the view where it can add the overlay
4. Do your thing in the callback!

## What now?

Hope you find this little tool useful and are not put off by the silly name.

Feel free to open issues or send me your comments.