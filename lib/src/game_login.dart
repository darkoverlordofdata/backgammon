/**
 *--------------------------------------------------------------------+
 * game_login.dart
 *--------------------------------------------------------------------+
 * Copyright DarkOverlordOfData (c) 2014
 *--------------------------------------------------------------------+
 *
 * This file is a part of Backgammon
 *
 * Backgammon is free software; you can copy, modify, and distribute
 * it under the terms of the GPLv3 License
 *
 *--------------------------------------------------------------------+
 *
 * Wrap the login workflow
 */
part of backgammon;

class GameLogin {

  final identifier = new Auth.ClientId(
      "260637501952-uva7urq0sm6uqhub7ojd1hu47pk7leam.apps.googleusercontent.com",
      null);

  final scopes = [Plus.PlusApi.PlusLoginScope, Games.GamesApi.GamesScope];

  DivElement loginDiv;
  ButtonElement loginButton;


  GameLogin(String login_div_id, String login_button_id) {

    loginButton = querySelector('#$login_button_id');
    loginDiv = querySelector('#$login_div_id');
    BackgammonApplication app = new BackgammonApplication(this);
  }

  connect(Game game) {
    authorizedClient().then((client) {

      Games.GamesApi api = new Games.GamesApi(client);
      Plus.PlusApi plusApi = new Plus.PlusApi(client);

      plusApi.people.get('me').then((Plus.Person person) {
        game.connect(api, person);
      });
      loginButton.hidden = true;


    }).catchError((error) {
      loginButton.disabled = true;
      if (error is Auth.UserConsentException) {
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
  Future authorizedClient() {
    // Initializes the oauth2 browser flow, completes as soon as authentication
    // calls can be made.
    return Auth.createImplicitBrowserFlow(identifier, scopes)
    .then((Auth.BrowserOAuth2Flow flow) {
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
        return loginButton.onClick.first.then((_) {
          return flow.clientViaUserConsent(immediate: false);
        });
      }, test: (error) => error is Auth.UserConsentException);
    });
  }

}