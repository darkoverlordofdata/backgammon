import 'dart:async';
import 'dart:html';

import 'package:googleapis_auth/auth_browser.dart' as auth;
import 'package:googleapis/plus/v1.dart' as plus;
import 'package:googleapis/games/v1.dart' as games;


main() {
  GameLogin g = new GameLogin();
  g.connect();
}

class GameLogin {

  final identifier = new auth.ClientId(
      "260637501952-uva7urq0sm6uqhub7ojd1hu47pk7leam.apps.googleusercontent.com",
      null);

  final scopes = [plus.PlusApi.PlusLoginScope, games.GamesApi.GamesScope];

  ButtonElement loginButton;
  DivElement loginDiv;
  DivElement welcomeDiv;

  GameLogin() {
    loginButton = querySelector('#login_button');
    loginDiv = querySelector('#loginDiv');
    welcomeDiv = querySelector('#welcomeDiv');

  }

  connect() {
    authorizedClient(loginButton).then((client) {

      plus.PlusApi plusApi = new plus.PlusApi(client);
      plusApi.people.get('me').then((person) {
        welcomeDiv.setInnerHtml("Welcome, ${person.displayName}!");
      });

      games.GamesApi game = new games.GamesApi(client);
      game.leaderboards.get('CgkIgNTS-coHEAIQCA').then((games.Leaderboard l) {
        print(l.name);
      });

      loginButton.disabled = true;
      loginDiv.style.display = 'none';
      welcomeDiv.style.display = 'inline';


    }).catchError((error) {
      loginButton.disabled = true;
      if (error is auth.UserConsentException) {
        loginButton.text = 'You did not grant access :(';
        return new Future.error(error);
      } else {
        loginButton.text = 'An unknown error occured ($error)';
        return new Future.error(error);
      }
    });

  }

  // Obtain an authenticated HTTP client which can be used for accessing Google
  // APIs.
  Future authorizedClient(ButtonElement loginButton) {
    // Initializes the oauth2 browser flow, completes as soon as authentication
    // calls can be made.
    return auth.createImplicitBrowserFlow(identifier, scopes)
    .then((auth.BrowserOAuth2Flow flow) {
      // Try getting credentials without user consent.
      // This will succeed if the user already gave consent for this application.
      return flow.clientViaUserConsent(immediate: true).catchError((_) {
        // Ask the user for consent.
        //
        // Asking for consent will create a popup window where the user has to
        // authenticate with Google and authorize this application to access data
        // on it's behalf.
        //
        // Since most browsers block popup windows by default, we can only do this
        // inside an event handler (if a user action triggered a popup it will
        // usually not be blocked).
        // We use the loginButton for this.
        loginDiv.style.display = 'inline';
        welcomeDiv.style.display = 'none';
        return loginButton.onClick.first.then((_) {
          return flow.clientViaUserConsent(immediate: false);
        });
      }, test: (error) => error is auth.UserConsentException);
    });
  }

}