# Archivos de verificacion de dominio

Para que `https://<dominio>/breed/<raza>` abra la app directamente (sin pasar
por el navegador ni por el selector de apps), el dominio tiene que publicar
estos dos archivos en la raiz:

| Archivo | URL publica | Plataforma |
|---|---|---|
| `.well-known/assetlinks.json` | `https://<dominio>/.well-known/assetlinks.json` | Android App Links |
| `.well-known/apple-app-site-association` | `https://<dominio>/.well-known/apple-app-site-association` | iOS Universal Links |

Requisitos de los servidores:

- HTTPS valido y **sin redirecciones** en esas dos rutas.
- `Content-Type: application/json` (el de Apple no lleva extension, hay que
  forzar el tipo; en S3 se hace con los metadatos del objeto).

## Que contiene cada uno

- `assetlinks.json`: paquete `com.luisturiz.cat_directory_app` y la huella
  SHA-256 del certificado que firma el APK. La que esta aqui es la del APK
  publicado en los releases. Si firmas con otra clave (por ejemplo con
  `android/key.properties`), saca la huella con
  `apksigner verify --print-certs app-release.apk` y agregala a la lista.
- `apple-app-site-association`: `TEAMID.bundleId` (`Y6QAJXAGX6.com.luisturiz.catDirectoryApp`)
  y el patron `/breed/*`.

## Dominio

Por defecto la app declara `luisturiz.com`. Para usar otro:

```bash
# Android (manifestPlaceholders)
fvm flutter build apk --release -PdeepLinkHost=mi-dominio.com --dart-define=DEEP_LINK_HOST=mi-dominio.com
```

En iOS se cambia `DEEP_LINK_HOST` en los build settings del target Runner (lo
usa `Runner.entitlements`: `applinks:$(DEEP_LINK_HOST)`).

## Como probar

```bash
# Android: estado de la verificacion
adb shell pm get-app-links com.luisturiz.cat_directory_app

# Android: abrir un link (con o sin dominio verificado)
adb shell am start -a android.intent.action.VIEW -d "https://luisturiz.com/breed/abyssinian"

# Sin dominio: esquema propio, funciona en cualquier instalacion
adb shell am start -a android.intent.action.VIEW -d "nekodex://open/breed/abyssinian"
xcrun simctl openurl booted "nekodex://open/breed/abyssinian"
```
