# Hiddo App - Estado del proyecto

## Stack
- Flutter
- Riverpod
- Firebase Auth anónimo
- Cloud Firestore
- Firebase Storage

## Features terminadas
- auth foundation
- game foundation
- lobby screen
- create game / join game
- assignment system
- list submission
- hunt screen
- subida de fotos
- ranking en results
- temporizador configurable hasta 5h

## Estructura importante
- game.dart
- game_model.dart
- game_firestore_datasource.dart
- game_firestore_datasource_impl.dart
- game_provider.dart
- game_lobby_screen.dart
- list_submission_screen.dart
- hunt_screen.dart
- results_screen.dart

## Problemas ya resueltos
- upstream branch en git
- error admin-restricted-operation por auth anónima no activada
- errores de override en datasources
- Firestore no escribía por método createGame
- fotos suben pero algunas no cargan en web
- temporizador no funcionaba porque endsAt no se persistía bien

## Estado actual
- El temporizador ya funciona tras corregir game.dart y game_model.dart
- Pendiente: cerrar la partida globalmente con status finished y winnerId

## Siguiente paso
- implementar finishGame()
- guardar winnerId y finishedAt
- redirigir a results cuando status == finished