-- Tabla principal: prendas (un solo registro por artículo, vista pedidos y cortes lo comparten)
create table if not exists public.prendas (
  id uuid primary key default gen_random_uuid(),
  owner uuid references auth.users not null default auth.uid(),
  "no" text default '',
  "desc" text default '',
  tela1 text default '',
  tela2 text default '',
  color text default '',
  bies text default '',
  cuello text default '',
  cuello_foto jsonb default '{"src":"","posX":50,"posY":50,"scale":1,"rot":0}'::jsonb,
  notas text default '',
  cliente text default '',
  pedido text default '',
  especificacion text default '',
  maquilador text default '',
  fecha date,
  contraentrega date,
  sizes jsonb default '{}'::jsonb,
  photos jsonb default '[]'::jsonb,
  estado text default 'sin_iniciar' check (estado in ('sin_iniciar','en_proceso','casi_listo','terminado')),
  ops jsonb default '[]'::jsonb,
  in_trash boolean default false,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create index if not exists prendas_owner_idx on public.prendas(owner);
create index if not exists prendas_trash_idx on public.prendas(owner, in_trash);

-- Row Level Security: cada usuario solo ve sus propias prendas
alter table public.prendas enable row level security;

drop policy if exists "Own prendas" on public.prendas;
create policy "Own prendas" on public.prendas
  for all to authenticated
  using (auth.uid() = owner)
  with check (auth.uid() = owner);

-- updated_at automático
create or replace function public.tg_set_updated_at()
returns trigger language plpgsql as $$
begin new.updated_at = now(); return new; end; $$;

drop trigger if exists prendas_set_updated_at on public.prendas;
create trigger prendas_set_updated_at
  before update on public.prendas
  for each row execute function public.tg_set_updated_at();

-- Storage bucket privado para las fotos
insert into storage.buckets (id, name, public)
  values ('fotos', 'fotos', false)
  on conflict (id) do nothing;

-- Políticas de Storage: cada usuario solo puede ver/subir/borrar dentro de su carpeta {auth.uid()}/...
drop policy if exists "Own fotos select" on storage.objects;
create policy "Own fotos select" on storage.objects
  for select to authenticated
  using (bucket_id='fotos' and (storage.foldername(name))[1] = auth.uid()::text);

drop policy if exists "Own fotos insert" on storage.objects;
create policy "Own fotos insert" on storage.objects
  for insert to authenticated
  with check (bucket_id='fotos' and (storage.foldername(name))[1] = auth.uid()::text);

drop policy if exists "Own fotos delete" on storage.objects;
create policy "Own fotos delete" on storage.objects
  for delete to authenticated
  using (bucket_id='fotos' and (storage.foldername(name))[1] = auth.uid()::text);
