# Archivos de verificacion de dominio

Para que `https://<dominio>/breed/<raza>` abra la app directamente (sin pasar
por el navegador ni por el selector de apps), el dominio tiene que publicar
estos dos archivos en la raiz:

| Archivo | URL publica | Plataforma |
|---|---|---|
| `.well-known/assetlinks.json` | `https://<dominio>/.well-known/assetlinks.json` | Android App Links |
| `.well-known/apple-app-site-association` | `https://<dominio>/.well-known/apple-app-site-association` | iOS Universal Links |

Estan publicados en `luisturiz.com` desde el repo del portafolio
(`public/.well-known/`), y los dos sistemas ya verifican el dominio. Si cambian
(otra huella, otro ambiente), hay que actualizar esa copia: es la que leen
Android e iOS.

Requisitos de los servidores:

- HTTPS valido y **sin redirecciones** en esas dos rutas.
- `Content-Type: application/json` (el de Apple no lleva extension, hay que
  forzar el tipo; en S3 se hace con los metadatos del objeto: el deploy del
  portafolio lo sube con `aws s3 cp --content-type application/json`).

## Que contiene cada uno

- `assetlinks.json`: paquete `com.luisturiz.cat_directory_app` y la huella
  SHA-256 del certificado que firma el APK. La que esta aqui es la del APK
  publicado en los releases. Si firmas con otra clave (por ejemplo con
  `android/key.properties`), saca la huella con
  `apksigner verify --print-certs app-prod-release.apk` y agregala a la lista.
- `apple-app-site-association`: `TEAMID.bundleId` (`Y6QAJXAGX6.com.luisturiz.catDirectoryApp`)
  y el patron `/breed/*`.

Los dos archivos son del flavor prod. DEV y QA declaran el mismo dominio con
su propio id (`com.luisturiz.cat_directory_app.dev` / `.qa` en Android,
`com.luisturiz.catDirectoryApp.dev` / `.qa` en iOS); si tambien tienen que
verificar, hay que sumar esas entradas a los dos archivos.

## Dominio

Por defecto la app declara `luisturiz.com`. Para usar otro:

```bash
# Android (manifestPlaceholders)
fvm flutter build apk --release --flavor prod -PdeepLinkHost=mi-dominio.com --dart-define=DEEP_LINK_HOST=mi-dominio.com
```

En iOS se cambia `DEEP_LINK_HOST` en los build settings del target Runner, en
todas sus configuraciones (lo usa `Runner.entitlements`:
`applinks:$(DEEP_LINK_HOST)`).

## Como probar

```bash
# Lo que ve Google (misma regla que usa Android)
curl "https://digitalassetlinks.googleapis.com/v1/statements:list?source.web.site=https://luisturiz.com&relation=delegate_permission/common.handle_all_urls"

# Lo que ve Apple (los iPhone bajan el archivo de su CDN, no del dominio)
curl https://app-site-association.cdn-apple.com/a/v1/luisturiz.com

# Android: estado de la verificacion (debe decir luisturiz.com: verified)
adb shell pm get-app-links com.luisturiz.cat_directory_app

# Android: abrir un link (con o sin dominio verificado)
adb shell am start -a android.intent.action.VIEW -d "https://luisturiz.com/breed/abyssinian"

# Sin dominio: esquema propio, funciona en cualquier instalacion
adb shell am start -a android.intent.action.VIEW -d "nekodex://open/breed/abyssinian"
xcrun simctl openurl booted "nekodex://open/breed/abyssinian"

# Cada ambiente tiene su esquema: nekodex-dev:// y nekodex-qa://
adb shell am start -a android.intent.action.VIEW -d "nekodex-dev://open/breed/abyssinian"
```

En VS Code, las tareas *Deep link: Android* y *Deep link: simulador iOS* hacen
lo mismo preguntando la app y la raza.
