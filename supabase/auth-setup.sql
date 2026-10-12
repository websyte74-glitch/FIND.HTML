alter table public.listings
  add column if not exists user_id uuid references auth.users(id) on delete set null;

alter table public.listings
  add column if not exists resolution_status text not null default 'active';

do $$
begin
  if not exists (
    select 1 from pg_constraint
    where conrelid = 'public.listings'::regclass
      and conname = 'listings_resolution_status_check'
  ) then
    alter table public.listings
      add constraint listings_resolution_status_check
      check (resolution_status in ('active', 'returned'));
  end if;
end;
$$;

alter table public.listings enable row level security;
grant usage on schema public to anon, authenticated;

drop policy if exists "Anyone can post valid UPSA Find listings" on public.listings;
drop policy if exists "Signed-in students can post their own UPSA Find listings" on public.listings;
create policy "Signed-in students can post their own UPSA Find listings"
  on public.listings
  for insert
  to authenticated
  with check (auth.uid() = user_id);

grant select on public.listings to anon, authenticated;
revoke insert on public.listings from authenticated;
revoke insert on public.listings from anon;
revoke insert (id, status, title, category, description, location, item_date, contact_name, email, user_id, resolution_status, created_at)
  on public.listings from anon, authenticated;
grant insert (status, title, category, description, location, item_date, contact_name, email, user_id)
  on public.listings to authenticated;
revoke update on public.listings from anon, authenticated;
revoke update (id, status, title, category, description, location, item_date, contact_name, email, user_id, resolution_status, created_at)
  on public.listings from anon, authenticated;
revoke delete on public.listings from anon, authenticated;

drop policy if exists "Students can update their own UPSA Find listings" on public.listings;
create policy "Students can update their own UPSA Find listings"
  on public.listings
  for update
  to authenticated
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

drop policy if exists "Students can delete their own UPSA Find listings" on public.listings;
create policy "Students can delete their own UPSA Find listings"
  on public.listings
  for delete
  to authenticated
  using (auth.uid() = user_id);

grant update (status, title, category, description, location, item_date, contact_name, resolution_status)
  on public.listings to authenticated;
grant delete on public.listings to authenticated;

create or replace function public.require_upsa_email()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  if new.email is null or lower(new.email) not like '%@upsamail.edu.gh' then
    raise exception 'Only UPSA email addresses ending in @upsamail.edu.gh may register.';
  end if;
  return new;
end;
$$;

drop trigger if exists require_upsa_email_on_signup on auth.users;
create trigger require_upsa_email_on_signup
  before insert or update of email on auth.users
  for each row execute function public.require_upsa_email();
