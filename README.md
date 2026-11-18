# OMB APP · Oh My Brunch

Página web y app de pedidos de **Oh My Brunch**, Himalaya #402, San Luis Potosí.
*Sandwiches for the people.* 🥪

## Qué hay aquí

| Carpeta | Qué es |
|---|---|
| `sitio/` | Página web (menú, cómo pedir, reseñas, ubicación). Fuente que se edita. |
| `prototipo/` | App de pedidos: cliente, cocina, repartidor y ajustes de reparto. Fuente que se edita. |
| `docs/` | Versión lista para publicar. **No se edita a mano**: se genera con el script. |
| `fotos-ubereats/` | Fotos del menú tomadas de la tienda en Uber Eats (temporales, hasta tener las originales). |
| `scripts/` | Herramientas para armar y revisar la versión publicable. |

> La app es un **prototipo**: los pedidos no llegan al restaurante ni se cobran.
> El reparto (repartidores propios + Uber Direct) está simulado.

## Publicar un cambio

1. Edita `sitio/index.html` o `prototipo/index.html`.
2. Arma la versión publicable:
   ```powershell
   powershell -File scripts/build-docs.ps1
   ```
3. (Opcional) Revísala en tu computadora: `node scripts/serve.js` y abre http://localhost:5173
4. Sube el cambio:
   ```bash
   git add -A
   git commit -m "Describe el cambio"
   git push
   ```
   GitHub Pages actualiza el sitio en 1–2 minutos.

## Configuración de GitHub Pages (una sola vez)

En el repositorio: **Settings → Pages → Build and deployment → Source: Deploy from a branch**,
rama `main`, carpeta `/docs`.

- Página: `https://<usuario>.github.io/<repositorio>/`
- App: `https://<usuario>.github.io/<repositorio>/app/`

Cuando haya dominio propio (p. ej. `ohmybrunch.mx`), se agrega en esa misma pantalla, en **Custom domain**.
