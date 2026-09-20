-- Mee-ERP OS — Auto Table (ส่วนเสริมของ supabase-schema.sql)
-- =============================================================
-- รันไฟล์นี้ "ครั้งเดียว" ใน Supabase › SQL Editor
--
-- ทำอะไร: สร้างฟังก์ชัน mee_ensure_table() ให้ระบบเรียกเองอัตโนมัติ
-- เมื่อโมดูลใดบันทึกข้อมูลลงตารางที่ยังไม่มี หรือมีคอลัมน์ใหม่เพิ่มเข้ามา
-- ฟังก์ชันจะสร้างตาราง/เพิ่มคอลัมน์ พร้อมเปิด RLS และให้สิทธิ์ให้ครบ
-- ผลคือ "ทุกโมดูล" บันทึกลง Supabase ได้ โดยไม่ต้องรันสคริปต์สร้างตารางใหม่ทุกครั้ง

create extension if not exists "pgcrypto";

create table if not exists tenant (
  id          uuid primary key default gen_random_uuid(),
  code        text unique not null,
  name_th     text not null,
  is_active   boolean not null default true,
  created_at  timestamptz not null default now()
);
insert into tenant (code, name_th) values ('default','องค์กรเริ่มต้น') on conflict (code) do nothing;
alter table tenant enable row level security;
drop policy if exists tenant_all on tenant;
create policy tenant_all on tenant for all to anon, authenticated using (true) with check (true);
grant select, insert, update, delete on tenant to anon, authenticated;

create or replace function public.mee_ensure_table(p_table text, p_cols jsonb default '{}'::jsonb)
returns text
language plpgsql
security definer
set search_path = public
as $fn$
declare
  t        text;
  k        text;
  v        text;
  ty       text;
  made     boolean := false;
  added    int := 0;
begin
  t := lower(regexp_replace(coalesce(p_table,''), '[^a-zA-Z0-9_]', '_', 'g'));
  if t !~ '^[a-z_][a-z0-9_]{0,60}$' then
    raise exception 'ชื่อตารางไม่ถูกต้อง: %', p_table;
  end if;
  if t = 'tenant' then return 'skip'; end if;

  if not exists (select 1 from information_schema.tables
                 where table_schema = 'public' and table_name = t) then
    execute format($q$
      create table public.%I (
        _pk         bigint generated always as identity primary key,
        _tenant     uuid references tenant(id) on delete cascade,
        _seq        integer not null default 0,
        _extra      jsonb not null default '{}'::jsonb,
        _created_at timestamptz not null default now(),
        _updated_at timestamptz not null default now()
      )$q$, t);
    execute format('create index %I on public.%I (_tenant, _seq)', t || '_tenant_seq_idx', t);
    made := true;
  end if;

  -- คอลัมน์ระบบ (กรณีตารางเคยสร้างด้วยสคริปต์เวอร์ชันเก่า)
  execute format('alter table public.%I add column if not exists _tenant uuid references tenant(id) on delete cascade', t);
  execute format('alter table public.%I add column if not exists _seq integer not null default 0', t);
  execute format('alter table public.%I add column if not exists _extra jsonb not null default ''{}''::jsonb', t);
  execute format('alter table public.%I add column if not exists _created_at timestamptz not null default now()', t);
  execute format('alter table public.%I add column if not exists _updated_at timestamptz not null default now()', t);

  -- คอลัมน์ข้อมูลจาก p_cols  {"ชื่อคอลัมน์":"text|numeric|boolean"}
  for k, v in select key, value from jsonb_each_text(coalesce(p_cols, '{}'::jsonb)) loop
    continue when k is null or k = '' or left(k, 1) = '_' or length(k) > 60;
    continue when k !~ '^[A-Za-z_][A-Za-z0-9_]*$';
    ty := case lower(coalesce(v, 'text')) when 'numeric' then 'numeric'
                                          when 'boolean' then 'boolean'
                                          when 'jsonb'   then 'jsonb'
                                          else 'text' end;
    if not exists (select 1 from information_schema.columns
                   where table_schema = 'public' and table_name = t and column_name = k) then
      execute format('alter table public.%I add column %I %s', t, k, ty);
      added := added + 1;
    end if;
  end loop;

  -- RLS + สิทธิ์ (idempotent)
  execute format('alter table public.%I enable row level security', t);
  execute format('drop policy if exists %I on public.%I', t || '_all', t);
  execute format('create policy %I on public.%I for all to anon, authenticated using (true) with check (true)', t || '_all', t);
  execute format('grant select, insert, update, delete on public.%I to anon, authenticated', t);
  begin
    execute format('grant usage, select on sequence %I to anon, authenticated', t || '__pk_seq');
  exception when others then null;
  end;

  notify pgrst, 'reload schema';
  return case when made then 'created' else 'updated' end || ' ' || t || ' (+' || added || ' cols)';
end;
$fn$;

grant execute on function public.mee_ensure_table(text, jsonb) to anon, authenticated;
notify pgrst, 'reload schema';
