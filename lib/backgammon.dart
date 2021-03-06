/*
      _                _
     | |              | |
     | |__   __ _  ___| | ____ _  __ _ _ __ ___  _ __ ___   ___  _ __
     | '_ \ / _` |/ __| |/ / _` |/ _` | '_ ` _ \| '_ ` _ \ / _ \| '_ \
     | |_) | (_| | (__|   < (_| | (_| | | | | | | | | | | | (_) | | | |
     |_.__/ \__,_|\___|_|\_\__, |\__,_|_| |_| |_|_| |_| |_|\___/|_| |_|
                            __/ |
                           |___/



Copyright (c) 2014 Bruce Davidson <darkoverlordofdata@gmail.com>

This file is part of Backgammon.

Backgammon is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Backgammon is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Backgammon.  If not, see <http://www.gnu.org/licenses/>.
*/

library backgammon;

import 'dart:html';
import 'dart:async';
import 'dart:math' as Math;

import 'package:dartemis/dartemis.dart' as Artemis;
import 'package:play_phaser/phaser.dart' as Phaser;
import 'package:play_phaser/arcade.dart' as Arcade;
import "package:dilithium/dilithium.dart" as Li2;
import "package:mt19937/mt19937.dart";
import 'package:googleapis_auth/auth_browser.dart' as Auth;
import 'package:googleapis/plus/v1.dart' as Plus;
import 'package:googleapis/games/v1.dart' as Games;


part 'src/backgammon_application.dart';
part 'src/game.dart';
part 'src/game_login.dart';
/**
 * Model
 */
part 'src/model/bgm_const.dart';
part 'src/model/bgm_game.dart';
part 'src/model/bgm_match.dart';
part 'src/model/bgm_move.dart';
part 'src/model/bgm_turn.dart';
/**
 * Engine
 */
part 'src/engine/abstract_entity.dart';
part 'src/engine/base_level.dart';
part 'src/engine/context.dart';
part 'src/engine/entity_factory.dart';
part 'src/engine/system_factory.dart';
/**
 * Components
 */
part 'src/components/animation.dart';
part 'src/components/action.dart';
part 'src/components/bonus.dart';
part 'src/components/bounce.dart';
part 'src/components/count.dart';
part 'src/components/gravity.dart';
part 'src/components/immovable.dart';
part 'src/components/number.dart';
part 'src/components/opacity.dart';
part 'src/components/player.dart';
part 'src/components/position.dart';
part 'src/components/scale.dart';
part 'src/components/state.dart';
part 'src/components/text.dart';
part 'src/components/sprite.dart';
part 'src/components/velocity.dart';
/**
 * Entities
 */
part 'src/entities/button_entity.dart';
part 'src/entities/checker_entity.dart';
part 'src/entities/dice_entity.dart';
part 'src/entities/image_entity.dart';
part 'src/entities/input_entity.dart';
part 'src/entities/legend_entity.dart';
part 'src/entities/player_entity.dart';
part 'src/entities/score_entity.dart';
part 'src/entities/string_entity.dart';
/**
 * Systems
 */
part 'src/systems/arcade_physics_system.dart';
part 'src/systems/button_render_system.dart';
part 'src/systems/checker_render_system.dart';
part 'src/systems/legend_render_system.dart';
part 'src/systems/player_control_system.dart';
part 'src/systems/score_render_system.dart';
part 'src/systems/sprite_render_system.dart';
part 'src/systems/string_render_system.dart';


const bool DEBUG = true;
