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

  final identifier = new auth.ClientId(
      "260637501952-uva7urq0sm6uqhub7ojd1hu47pk7leam.apps.googleusercontent.com",
      null);

  final scopes = [plus.PlusApi.PlusLoginScope, games.GamesApi.GamesScope];

  DivElement loginDiv;
  ButtonElement loginButton;


  GameLogin(String login_div_id, String login_button_id) {

    loginButton = querySelector('#$login_button_id');
    loginDiv = querySelector('#$login_div_id');
    BackgammonApplication app = new BackgammonApplication(this);
  }

  connect(var game) {
    authorizedClient().then((client) {

      games.GamesApi api = new games.GamesApi(client);
      plus.PlusApi plusApi = new plus.PlusApi(client);

      plusApi.people.get('me').then((plus.Person person) {
        game.login(api, person);
      });

//      api.leaderboards.get('CgkIgNTS-coHEAIQCA').then((games.Leaderboard l) {
//
//        print(l.name);
//      });
//
      loginButton.disabled = true;
      loginDiv.style.display = 'none';


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
  Future authorizedClient() {
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
        return loginButton.onClick.first.then((_) {
          return flow.clientViaUserConsent(immediate: false);
        });
      }, test: (error) => error is auth.UserConsentException);
    });
  }

}