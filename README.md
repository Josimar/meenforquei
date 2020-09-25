# meenforquei

O MeEnforquei ajuda você a realizar o seu evento

## Getting Started

// Site de casamento
https://www.zapwedding.com.br/funcionalidades/
// Ícones
https://fontawesome.com/icons?d=gallery&m=free
// Exemplos
https://github.com/iampawan/FlutterExampleApps
// State
https://medium.com/flutter-community/widget-state-buildcontext-inheritedwidget-898d671b7956
// Firebase cloud message e notifications
https://www.youtube.com/watch?v=P8Y84OnVkdg
// Layout
https://www.youtube.com/watch?v=RJEnTRBxaSg

### Versão do Dart
dart --version

Visual Code
- Instalar plugin "Flutter", "Dart", "Code Runner"

CTRL + ALT + N => roda um script dart

Linha de comando
- Mostra tudo que está usando o flutter e as atualizações
flutter doctor 

#Gerar chave
// keytool -genkey -v -keystore debug.keystore -storepass android -alias androiddebugkey -keypass android -keyalg RSA -keysize 2048 -validity 10000
keytool -genkey -v -keystore C:\Josimar\Free\MeEnforquei\meenforquei.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias key

#listar dados da chave
// keytool -list -v -alias androiddebugkey -keystore C:\Josimar\Free\MeEnforquei\debug.keystore
keytool -list -v -alias key -keystore C:\Josimar\Free\MeEnforquei\meenforquei.jks

SHA1: E9:8A:F0:15:24:79:23:7F:E4:07:F0:A4:FA:E6:BE:FD:C8:ED:DA:43

Fazer download do google-services.json

No Arquivo:
C:\Josimar\Free\MeEnforquei\meenforquei\android\build.gradle
    dependencies {
        classpath 'com.android.tools.build:gradle:4.0.0'
        classpath 'com.google.gms:google-services:4.3.3'
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
    }
	
No Arquivo:
C:\Josimar\Free\MeEnforquei\meenforquei\android\app\build.gradle

dependencies {
  Todos os Firebases
  implementation 'com.google.firebase:firebase-core:17.4.3'
  ...
}
apply plugin: 'com.google.gms.google-services'  // Google Play services Gradle plugin


# caso erro: Minimum supported Gradle version is 6.1.1. Current version is 5.6.2. If using the gradle
My_project
  /gradle
  /wrapper
  /gradle-wrapper.properties 
  
Modify this line with the Gradle 5.1.1
distributionUrl=https\://services.gradle.org/distributions/gradle-5.1.1-all.zip

#caso erro uses unchecked or unsafe operations
In the Project Gradle (project/app/build.gradle) add the following lines:
defaultConfig {
    ...
    multiDexEnabled true
}
and
dependencies {
    ...
    implementation 'com.android.support:multidex:1.0.3'
}

#Caso erro de acesso ao user do Google
Make sure to be logged in with the same account of Firebase
Select your firebase project
Select Android
Open terminal inside your flutter project
cd android
./gradlew signingReport or gradlew signingReport
Paste your package name and your SHA1 key
Download Client Information
Download and replace the google-services.json
flutter clean

# LogCat - aba no rodapé do Android Studio
... Tem opção de tirar print e filmar APP

 # Ícones na aplicação
   flutter_launcher_icons: 0.7.5
 
 flutter_icons:
   android: true
   ios: true
   image_path: "assets/icone.png"
   adaptive_icon_background: "#FFFFFF"
   adaptive_icon_foreground: "assets/icone-adaptive.png"
   
Linha de comando: flutter pub run flutter_launcher_icons:main
