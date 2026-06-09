# Pedidos de Uniforme — Ludivina 2026

Sistema para gestionar pedidos y cortes de uniformes escolares.

## Versiones

- **`index.html`** (= `nube.html`): versión en la nube con login y sincronización (Supabase). Es la página principal del sitio publicado.
- **`sistema.html`**: versión offline que guarda en el navegador (localStorage), sin login.
- **`pedidos.html`**: versión original solo de pedidos (legado).

## Acceso al sitio publicado

- Página principal (nube con login): `/`
- Versión offline: `/sistema.html`
- Versión legado: `/pedidos.html`

## Estructura

- `schema.sql` — esquema de la base de datos en Supabase (tabla `prendas` + bucket `fotos` + RLS).
- `respaldo_pedidos.json` / `respaldo_unificado.json` — respaldos locales del histórico.

## Supabase

Proyecto: **PEDIDOS DE UNIFORME LUDIVINA 2026**
- URL: `https://bonpgqhxyzaafzqmpytp.supabase.co`
- La *publishable key* va embebida en `nube.html` (es segura para uso del lado del cliente — las políticas RLS son las que protegen los datos).
