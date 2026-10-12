create table if not exists public.listings (
  id uuid primary key default gen_random_uuid(),
  status text not null check (status in ('lost', 'found')),
  title text not null check (char_length(trim(title)) between 1 and 60),
  category text not null check (category in ('ID Card', 'Electronics', 'Personal items', 'Books & stationery', 'Keys', 'Other')),
  description text not null check (char_length(trim(description)) between 1 and 240),
  location text not null check (char_length(trim(location)) between 1 and 80),
  item_date date not null,
  contact_name text not null check (char_length(trim(contact_name)) between 1 and 50),
  email text not null check (char_length(email) <= 100 and email ~* '^[^@[:space:]]+@[^@[:space:]]+\.[^@[:space:]]+$'),
  user_id uuid references auth.users(id) on delete set null,
  created_at timestamptz not null default now()
);

alter table public.listings
  add column if not exists user_id uuid references auth.users(id) on delete set null;

alter table public.listings enable row level security;
grant usage on schema public to anon, authenticated;

drop policy if exists "Anyone can read UPSA Find listings" on public.listings;
create policy "Anyone can read UPSA Find listings"
  on public.listings
  for select
  to anon, authenticated
  using (true);

drop policy if exists "Anyone can post valid UPSA Find listings" on public.listings;
drop policy if exists "Signed-in students can post their own UPSA Find listings" on public.listings;
create policy "Signed-in students can post their own UPSA Find listings"
  on public.listings
  for insert
  to authenticated
  with check (auth.uid() = user_id);

grant select on public.listings to anon, authenticated;
grant insert on public.listings to authenticated;
revoke insert on public.listings from anon;

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
