import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Firma de release opcional: si existe android/key.properties (no versionado)
// se usa esa clave; si no, el APK de release se firma con la de debug.
val keystoreProperties = Properties().apply {
    val file = rootProject.file("key.properties")
    if (file.exists()) file.inputStream().use { load(it) }
}

// Dominio de los App Links. Se cambia con -PdeepLinkHost=mi-dominio.com
val deepLinkHost = (project.findProperty("deepLinkHost") as String?) ?: "luisturiz.com"

android {
    namespace = "com.luisturiz.cat_directory_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        // flutter_local_notifications usa java.time en versiones viejas de Android.
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.luisturiz.cat_directory_app"
        minSdk = maxOf(flutter.minSdkVersion, 24)
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        manifestPlaceholders["deepLinkHost"] = deepLinkHost
    }

    // Un flavor por ambiente, instalables lado a lado. iOS repite estos valores
    // en ios/Flutter/flavors y lo que usa Dart esta en AppEnvironment.
    flavorDimensions += "env"
    productFlavors {
        create("dev") {
            dimension = "env"
            applicationIdSuffix = ".dev"
            versionNameSuffix = "-dev"
            manifestPlaceholders["appName"] = "NekoDex DEV"
            manifestPlaceholders["deepLinkScheme"] = "nekodex-dev"
        }
        create("qa") {
            dimension = "env"
            applicationIdSuffix = ".qa"
            versionNameSuffix = "-qa"
            manifestPlaceholders["appName"] = "NekoDex QA"
            manifestPlaceholders["deepLinkScheme"] = "nekodex-qa"
        }
        create("prod") {
            dimension = "env"
            manifestPlaceholders["appName"] = "NekoDex"
            manifestPlaceholders["deepLinkScheme"] = "nekodex"
        }
    }

    signingConfigs {
        if (keystoreProperties.isNotEmpty()) {
            create("release") {
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
                storeFile = file(keystoreProperties["storeFile"] as String)
                storePassword = keystoreProperties["storePassword"] as String
            }
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.findByName("release")
                ?: signingConfigs.getByName("debug")
        }
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}

flutter {
    source = "../.."
}
